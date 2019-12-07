---
title: Linux 常用命令
date: 2019-12-07 14:58:54
tags: Linux
---

防火墙知识点:

添加访问端口号: firewall-cmd --zone=public --add-port=6379/tcp --permanent

列出可访问的端口 firewall-cmd --list-ports

使配置生效 firewall-cmd --reload

查看状态： firewall-cmd --state

禁用防火墙: sudo systemctl stop firewalld

ps -ef | grep redis

查看程序运行端口 netstat -nl | grep 61616



解压命令到某个具体目录

tar -zxvf xx.tar.gz -C xxx

查询文件包含指定字符串 grep -i "mystring" /tmp/myfile, 其中 i 代表忽略大小写

