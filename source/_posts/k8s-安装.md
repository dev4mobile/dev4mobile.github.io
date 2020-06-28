---
title: k8s 安装 
date: 2020-06-28 12:17:35
tags:
author: Patrick
authorURL: https://github.com/yutian2011/k8
---

- [使用kubeadm安装kubernetes集群](#使用kubeadm安装kubernetes集群)
  - [环境准备](#环境准备)
    - [关闭防火墙(如果开了的话)](#关闭防火墙如果开了的话)
    - [关闭 SELinux](#关闭-selinux)
    - [关闭swap](#关闭swap)
    - [加载内核相关模块](#加载内核相关模块)
    - [更改系统参数](#更改系统参数)
  - [安装docker](#安装docker)
    - [添加docker源](#添加docker源)
    - [查看docker版本](#查看docker版本)
    - [安装指定的docker版本](#安装指定的docker版本)
  - [kubeadm安装kubernetes](#kubeadm安装kubernetes)
    - [安装kubeadm和kubelet](#安装kubeadm和kubelet)
    - [docker的cgroup driver](#docker的cgroup-driver)
      - [cgroup driver和引入的问题](#cgroup-driver和引入的问题)
      - [修改docker](#修改docker)
      - [修改kubelet](#修改kubelet)
      - [cgroup driver选取: systemd vs cgroupfs](#cgroup-driver选取-systemd-vs-cgroupfs)
      - [重新加载服务 systemctl daemon-reload和 systemctl restart xxx](#重新加载服务-systemctl-daemon-reload和-systemctl-restart-xxx)
    - [kubeadm初始化集群](#kubeadm初始化集群)
    - [部署网络插件calico](#部署网络插件calico)
    - [存储插件 ceph](#存储插件-ceph)
    - [开启ipvs](#开启ipvs)
      - [编辑configmap](#编辑configmap)
    - [关于kubeadm的配置](#关于kubeadm的配置)
    - [Helm安装](#helm安装)
    - [镜像加速](#镜像加速)

# 使用kubeadm安装kubernetes集群
系统: Centos7  
[官方文档](https://kubernetes.io/zh/docs/setup/independent/install-kubeadm/) 

## 环境准备

### 关闭防火墙(如果开了的话)

```
systemctl stop firewalld  
systemctl disable firewalld  
```

### 关闭 SELinux
```
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
```

### 关闭swap

```
swapoff -a
sed -i "s/\(^.*swap.*$\)/#\1/" /etc/fstab
```



### 加载内核相关模块
```
modprobe br_netfilter  
modprobe  ip_vs     
modprobe  ip_vs_rr  
modprobe  ip_vs_wrr  
modprobe  ip_vs_sh  
modprobe  nf_conntrack_ipv4
```

modprobe br_netfilter     
> ipv4/v6 arp包转发过滤. 

modprobe  ip_vs     
modprobe  ip_vs_rr  
modprobe  ip_vs_wrr  
modprobe  ip_vs_sh  
> 4层负载均衡 


modprobe  nf_conntrack_ipv4  或 modprobe nf_conntrack  内核>=4.19
> nf_conntrack(在老版本的 Linux 内核中叫 ip_conntrack)是一个内核模块,用于跟踪一个连接的状态的。连接状态跟踪可以供其他模块使用,最常见的两个使用场景是 iptables 的 nat 的 state 模块。 iptables 的 nat 通过规则来修改目的/源地址,但光修改地址不行,我们还需要能让回来的包能路由到最初的来源主机。这就需要借助 nf_conntrack 来找到原来那个连接的记录才行。而 state 模块则是直接使用 nf_conntrack 里记录的连接的状态来匹配用户定义的相关规则.  
[Iptables之nf_conntrack模块](https://clodfisher.github.io/2018/09/nf_conntrack/)


### 更改系统参数
系统参数与上述加载的内核模块有关.  
/etc/sysctl.conf  
```
cat <<EOF >> /etc/sysctl.conf  
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
```
参数生效: sysctl -p 


## 安装docker
### 添加docker源

```
yum -y install yum-utils  
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

### 查看docker版本

```
yum list docker-ce --showduplicates|sort -r 
```

### 安装指定的docker版本
根据kubernetes版本安装对应版本的docker. 
具体信息可以查看 https://github.com/kubernetes/kubernetes/releases 查看对应版本的changelog.
 目前相对比较稳定, 以下截取的16版本的log: 
> Unchanged  
The list of validated docker versions remains unchanged.  
The current list is 1.13.1, 17.03, 17.06, 17.09, 18.06, 18.09. (#72823, #72831)  
CNI remains unchanged at v0.7.5. (#75455)  
cri-tools remains unchanged at v1.14.0. (#75658)  
......  
[kubernetes/CHANGELOG-1.16.md](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG-1.16.md#v1164)  



这边安装了docker18的版本
```
yum install -y docker-ce-18.09.9  
systemctl enable docker && systemctl start docker  
```

## kubeadm安装kubernetes
### 安装kubeadm和kubelet
添加kubernets源, 这里使用了的是阿里的kubernetes源.  
```
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
	   http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF



yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

systemctl enable kubelet && systemctl start kubelet

yum -y install ipset
yum -y install ipvsadm
``` 


### docker的cgroup driver 
#### cgroup driver和引入的问题
cgroup控制进程资源的使用, 具体实现的方式有两种driver, systemd和cgroupfs. 

在kubelet(kubernetes中控制容器生命周期组件)中可以配置cgroup的driver. docker默认设置中也有driver的设置. [kubelet控制一套runc接口, docker实现了一套runc的接口. --> kubelet控制docker]

在两者配置的driver不同时, 会导致安装kubernetes时报错. 

```
failed to create kubelet: misconfiguration: kubelet cgroup driver: "cgroupfs" is different from docker cgroup driver: "systemd"
```

这个问题的解决, 使docker和kubelet中配置参数一致即可, 都为systemd或都为cgroupfs.  


默认情形下, kubelet中cgroup driver使用的是systemd, 而docker中使用的是cgroupfs的driver. 

kubernetes推荐使用的是systemd作为cgroup的driver.  
> Cgroup 驱动程序
当某个 Linux 系统发行版使用 systemd 作为其初始化系统时，初始化进程会生成并使用一个 root 控制组 （cgroup），并充当 cgroup 管理器。 systemd 与 cgroup 集成紧密，并将为每个进程分配 cgroup。 您也可以配置容器运行时和 kubelet 使用 cgroupfs。 连同 systemd 一起使用 cgroupfs 意味着将有两个不同的 cgroup 管理器。
控制组用来约束分配给进程的资源。 单个 cgroup 管理器将简化分配资源的视图，并且默认情况下将对可用资源和使用中的资源具有更一致的视图。 当有两个管理器时，最终将对这些资源产生两种视图。 在此领域我们已经看到案例，某些节点配置让 kubelet 和 docker 使用 cgroupfs，而节点上运行的其余进程则使用 systemd；这类节点在资源压力下会变得不稳定。
更改设置，令容器运行时和 kubelet 使用 systemd 作为 cgroup 驱动，以此使系统更为稳定。 请注意在 docker 下设置 native.cgroupdriver=systemd 选项。
警告:
强烈建议不要更改已加入集群的节点的 cgroup 驱动。 如果 kubelet 已经使用某 cgroup 驱动的语义创建了 pod，尝试更改运行时以使用别的 cgroup 驱动，为现有 Pods 重新创建 PodSandbox 时会产生错误。 重启 kubelet 也可能无法解决此类问题。 推荐将工作负载逐出节点，之后将节点从集群中删除并重新加入。

[官网中文](https://kubernetes.io/zh/docs/setup/production-environment/container-runtimes/#cgroup-drivers)  
[官网英文](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#cgroup-drivers)


#### 修改docker

```
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "registry-mirrors": ["https://registry.docker-cn.com", "https://docker.mirrors.ustc.edu.cn"]
}
EOF
```
[Change default cgroup driver to systemd and verify parity w/docker on preflight](https://github.com/kubernetes/kubeadm/issues/1394)  

#### 修改kubelet
**默认不需要修改kubelet参数, 如果需要, 可以参考下面方式进行修改.**  

配置文件路径:  
```
/etc/systemd/system/kubelet.service.d/10-kubeadm.conf  
/usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf  
```
网上配置文件路径1居多, 在centos7安装中查找到的是路径2.   

举例将kubelet中driver修改为systemd.  
config中添加 --cgroup-driver=systemd    
```
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --cgroup-driver=systemd"
Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
......
``` 


#### cgroup driver选取: systemd vs cgroupfs

No results
[docker cgroup driver discussion - cgroupfs or systemd](https://github.com/coreos/bugs/issues/1435)  


#### 重新加载服务 systemctl daemon-reload和 systemctl restart xxx
见标题  

### kubeadm初始化集群
**上述命令需要在每个节点上执行. 以下命令初始化kubenetes集群, 只需要在主节点上运行初始化命令即可, 集群初始化完成后, 其他节点通过kubeadm join命令加入集群即可.**  


```
 kubeadm init  --image-repository  registry.aliyuncs.com/google_containers --pod-network-cidr=192.168.0.0/16
```


命令成功后会输出下面.  
```
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join xxxxx:6443 --token gf7pwf.dix9uzxq50u47n2f \
    --discovery-token-ca-cert-hash sha256:3166fc496e1b6613fc0e7173eb4f750535cd0df2f9ceb09564873e35dfa5581b

```

root账户:
```
  mkdir -p $HOME/.kube
  cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  chown $(id -u):$(id -g) $HOME/.kube/config
```

非root账户:

```
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

其他节点使用kubeadmin join命令加入集群.  

通过命令查看集群信息
```
[root@node201 charts]# kubectl cluster-info
Kubernetes master is running at https://xxxx:6443
KubeDNS is running at https://xxxx:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

[root@node201 charts]# kubectl get node
NAME      STATUS   ROLES    AGE     VERSION
node201   Ready    master   2m16s   v1.17.0
node202   Ready    <none>   52s     v1.17.0
node203   Ready    <none>   90s     v1.17.0

[root@node201 charts]# kubectl get pod -n kube-system -o wide
NAME                              READY   STATUS              RESTARTS   AGE     IP            NODE      NOMINATED NODE   READINESS GATES
coredns-9d85f5447-tpc9p           0/1     ContainerCreating   0          2m18s   <none>        node201   <none>           <none>
coredns-9d85f5447-wg5c2           0/1     ContainerCreating   0          2m18s   <none>        node201   <none>           <none>
etcd-node201                      1/1     Running             0          2m25s   10.0.40.201   node201   <none>           <none>
kube-apiserver-node201            1/1     Running             0          2m24s   10.0.40.201   node201   <none>           <none>
kube-controller-manager-node201   1/1     Running             0          2m24s   10.0.40.201   node201   <none>           <none>
kube-proxy-5hvp4                  1/1     Running             0          74s     10.0.40.202   node202   <none>           <none>
kube-proxy-6vgc8                  1/1     Running             0          112s    10.0.40.203   node203   <none>           <none>
kube-proxy-hxsnm                  1/1     Running             0          2m17s   10.0.40.201   node201   <none>           <none>
kube-scheduler-node201            1/1     Running             0          2m24s   10.0.40.201   node201   <none>           <none>

```
这里的coredns的容器没有起来的.  


### 部署网络插件calico
```
kubectl apply -f https://docs.projectcalico.org/v3.10/manifests/calico.yaml  
```

网络安装好之后, coredns的相关容器也启动起来了.   

```
[root@node201 charts]# kubectl get pod -n kube-system -o wide
NAME                                       READY   STATUS    RESTARTS   AGE     IP              NODE      NOMINATED NODE   READINESS GATES
calico-kube-controllers-74c9747c46-h7577   0/1     Running   0          65s     192.168.244.1   node202   <none>           <none>
calico-node-7stvb                          1/1     Running   0          65s     10.0.40.203     node203   <none>           <none>
calico-node-jncrb                          1/1     Running   0          65s     10.0.40.202     node202   <none>           <none>
calico-node-z2xpq                          1/1     Running   0          65s     10.0.40.201     node201   <none>           <none>
coredns-9d85f5447-tpc9p                    0/1     Running   0          3m35s   192.168.161.2   node201   <none>           <none>
coredns-9d85f5447-wg5c2                    1/1     Running   0          3m35s   192.168.161.1   node201   <none>           <none>
etcd-node201                               1/1     Running   0          3m42s   10.0.40.201     node201   <none>           <none>
kube-apiserver-node201                     1/1     Running   0          3m41s   10.0.40.201     node201   <none>           <none>
kube-controller-manager-node201            1/1     Running   0          3m41s   10.0.40.201     node201   <none>           <none>
kube-proxy-5hvp4                           1/1     Running   0          2m31s   10.0.40.202     node202   <none>           <none>
kube-proxy-6vgc8                           1/1     Running   0          3m9s    10.0.40.203     node203   <none>           <none>
kube-proxy-hxsnm                           1/1     Running   0          3m34s   10.0.40.201     node201   <none>           <none>
kube-scheduler-node201                     1/1     Running   0          3m41s   10.0.40.201     node201   <none>           <none>

```

### 存储插件 ceph
存储插件非必选, 了解.  
[ceph](https://rook.io/docs/rook/v1.1/ceph-quickstart.html)  

### 开启ipvs
为什么使用ipvs代替iptable?  

ipvs可以带来性能上的提升, kubernetes默认的是使用iptables, 当集群达到一定规模后, iptables可能会带来管理运维上的灾难.   

有几种可以实现的方式, 这里展示编辑configmap的方式, 同时, 在kubeadm init时也可以指定参数.   

安装工具ipset, ipvsadm(前面已安装):  
``` 
yum -y install ipset
yum -y install ipvsadm
```

#### 编辑configmap
编辑kube-proxy configmap, 将mode字段值改为ipvs. [默认为空]   
```
[root@node201 ~]# kubectl get cm -n kube-system
NAME                                 DATA   AGE
calico-config                        4      6m48s
coredns                              1      148m
extension-apiserver-authentication   6      148m
kube-proxy                           2      148m
kubeadm-config                       2      148m
kubelet-config-1.17                  1      148m
[root@host-10-0-40-201 ~]# kubectl edit cm kube-proxy -n kube-system
configmap/kube-proxy edited
```

重启kube-proxy pod. (删除pod后, 会自动新建pod)  

查看新kube-proxy日志, 显示Using ipvs Proxier.  
```
[root@node201 ~]# kubectl logs kube-proxy-dlv4k -n kube-system
I1231 05:47:33.918206       1 node.go:135] Successfully retrieved node IP: 10.0.40.202
I1231 05:47:33.918288       1 server_others.go:172] Using ipvs Proxier.
W1231 05:47:33.918595       1 proxier.go:414] clusterCIDR not specified, unable to distinguish between internal and external traffic
W1231 05:47:33.918615       1 proxier.go:420] IPVS scheduler not specified, use rr by default
I1231 05:47:33.918934       1 server.go:571] Version: v1.17.0
I1231 05:47:33.919484       1 conntrack.go:52] Setting nf_conntrack_max to 131072
I1231 05:47:33.919800       1 config.go:313] Starting service config controller
I1231 05:47:33.919834       1 shared_informer.go:197] Waiting for caches to sync for service config
I1231 05:47:33.919871       1 config.go:131] Starting endpoints config controller
I1231 05:47:33.919892       1 shared_informer.go:197] Waiting for caches to sync for endpoints config
I1231 05:47:34.020030       1 shared_informer.go:204] Caches are synced for service config
I1231 05:47:34.020145       1 shared_informer.go:204] Caches are synced for endpoints config
```

可以通过ipvsadm -ln查看信息.  
```
[root@node201 ~]# ipvsadm -ln
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  10.96.0.1:443 rr
  -> 10.0.40.201:6443             Masq    1      0          0
TCP  10.96.0.10:53 rr
  -> 192.168.207.193:53           Masq    1      0          0
  -> 192.168.207.194:53           Masq    1      0          0
TCP  10.96.0.10:9153 rr
  -> 192.168.207.193:9153         Masq    1      0          0
  -> 192.168.207.194:9153         Masq    1      0          0
UDP  10.96.0.10:53 rr
  -> 192.168.207.193:53           Masq    1      0          0
  -> 192.168.207.194:53           Masq    1      0          0

```  


更多关于ipvs和iptables可以了解: [ipvs 基本介绍如何在 kubernetes 中启用 ipvs](https://www.qikqiak.com/post/how-to-use-ipvs-in-kubernetes/ )  


### 关于kubeadm的配置
kubeadm的配置可以修改镜像仓库, ipvs的设置的.  
通过导出默认配置, 然后修改默认配置.  

```
kubeadm config print init-defaults > kubeadm.yaml
......
kubeadm init --config kubeadm.yaml
```

### Helm安装
[helm用户指南](https://whmzsu.github.io/helm-doc-zh-cn/)  
[使用Helm管理kubernetes应用](https://jimmysong.io/kubernetes-handbook/practice/helm.html)  

Helm是一个kubernetes应用的包管理工具，用来管理charts——预先配置好的安装包资源，有点类似于Ubuntu的APT和CentOS中的yum。

Helm chart是用来封装kubernetes原生应用程序的yaml文件，可以在你部署应用的时候自定义应用程序的一些metadata，便与应用程序的分发。 

Helm和charts的主要作用： 
应用程序封装   
版本管理   
依赖检查   
便于应用程序分发   

每一个版本 release, Helm 提供多种操作系统的二进制版本。这些二进制版本可以手动下载和安装。 

下载想要的版本 https://github.com/helm/helm/releases, 解压缩（tar -zxvf helm-v2.0.0-linux-amd64.tgz）. helm 在解压后的目录中找到二进制文件，并将其移动到所需的位置（mv linux-amd64/helm /usr/local/bin/helm）. 

以下以2.16版本为例.  
PS:  Helm v2与v3区别较大. 自行谷歌学习.  

```
wget https://get.helm.sh/helm-v2.16.3-linux-amd64.tar.gz
tar -xzvf helm-v2.16.3-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
helm init --service-account tiller --upgrade -i registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.16.3 --stable-repo-url http://mirror.azure.cn/kubernetes/charts/
```

如果有问题再执行.  

```
kubectl create serviceaccount --namespace kube-system tiller  
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller  
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'  
```

[forbidden: User "system:serviceaccount:kube-system:default" cannot get namespaces in the namespace "default](https://github.com/fnproject/fn-helm/issues/21)  




参考:  
https://whmzsu.github.io/helm-doc-zh-cn/quickstart/install-zh_cn.html
https://github.com/helm/helm/issues/3130


### 镜像加速
https://www.ilanni.com/?p=14534












