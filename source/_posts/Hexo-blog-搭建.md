---
title: 使用 Github Action 搭建 Hexo 博客
date: 2019-11-22 11:45:56
tags: hexo
---
`Hexo` 是使用 `nodejs` 写的博客框架，使用 `Markdown` 引擎来解析文章，在几秒内，即可生成绚丽的主题生成静态网页。作为一名有追求的程序员，我们必须得有自己的个人网站，所以我要开始搭建自己的博客了，于是开始了我选择博客平台之旅，最终选择了 `Hexo` 。我为什么选择 `Hexo` 搭建我的博客，其中最主要原因是国内程序员使用广泛，可选择的主题也很多，还有最重要的可迁移性强。

这是我的个人博客效果：[IT才华有限青年·dev4mobile](https://dev4mobiles.com/)

## 原理
我们可以通过命令 `hexo init xxx` 来生成 hexo 网站源码，然后通过 `hexo generate` 来编译源码，生成我们需要的静态文件，这些静态文件在 `public`目录下, 这个 `public` 目录就是我们要发布的网站目录。下面是我简单的画了一下 hexo 网站的运行原理
![运行原理图](https://dev4mobiles.com/images/hexo-blog-website-run.jpg)
## 搭建过程

### 软件准备

这里只选择 mac 平台做说明，其它平台请 google 

1. 安装 nodejs
     ```bash
     #搜索 node 是否存在
     brew search node
     #安装 node 
     brew install node
     ```
2. 安装 cnpm
     这里不用 cnpm 也行，使用 nodejs 自带的npm，只不过速度非常慢
     ```bash
     npm install cnpm -g
     ```
3. 安装 hexo-cli
    ```bash
    cnpm install hexo-cli -g 或者 npm install hexo-cli -g
    ```
4. 安装git
     ```bash
     brew install git
     ```

### 初始化 blog

搭建一个博客需要四步，初始化博客目录，安装博客依赖，本地发布，测试。记住目录名不能错,`<github_user_name>.github.io`，这里以我的 github 用户名 `dev4mobile` 为例，必须为`dev4mobile.github.io`, 我的博客目录结构
![网站目录结构](https://dev4mobiles.com/images/hexo-blog-website-dir.png)

1. 初始化博客目录结构 

     ```bash
     #hexo init <github_user_name>.github.io
     hexo init dev4mobile.github.io
     ```
2. 安装依赖

     ```bash
     cd dev4mobile.github.io
     cnpm install
     ```
3. 本地发布

     ```bash
     hexo server
     ```
4. 测试

     `hexo server` 执行完之后，命令行会打印 `http://localhost:4000`，这个地址就是我们本地访问的博客地址，能打开说明，我们的网站初步搭建成功。


### 新建新 blog

网站初步搭建成功之后，我们就可以开始写我们的博客了

执行下面命令，我们就可以新建一个博客

```bash
#新建blog
hexo new '文章名称'
#本地预览
hexo server
```

### 发布 blog 到 github 上

本地测试都没问题了，那么我们可以使用免费的 VPS 空间 github pages 来发布我们的博客。我这里是使用`develop` 分支来存放我的网站源码，`master` 分支作为我的网站发布目录，整个构建过程是使用github actions来做的，配置文件可以参考我写的，我假设你已经有了github账户，在这里以我的账户 dev4mobile 为例来说明.

1. 新建仓库 `dev4mobile.github.io`
2. 创建 github action配置文件，也就是在网站目录下新建.github 目录, 然后新建 workflows 目录，创建配置文件 deploy.yml 文件，可参考 https://github.com/dev4mobile/dev4mobile.github.io/blob/develop/.github/workflows/deploy.yml
3. 将本地创建的 hexo 网站推送到 `dev4mobile.github.io` 仓库的 develop 分支, 然后github action 会自动编译，部署到你的 master 分支上

     ```
     git push origin develop -f
     ```
4. 查看 github actions 构建是否成功，成功之后你就可以使用 `https://dev4mobile.github.io/` 来访问你的网站了

### 配置域名
如果你自己已经有个人域名，那么你可以配置一条CNAME记录来指向你的 `https://dev4mobile.github.io/` 的记录。并且需要在你的网站目录 `source` 目录下创建一个文件`CNAME`，里面的内容是你的网站，比如我的是`dev4mobiles.com`

### 更改主题
默认的主题实在太难看了，我选择 `again` 这个主题，把主题下载下来放在 `themes` 目录下，然后在 `_config.xml` 目录配置 `theme`这个key为 `again`就行了

### 总结
最后我想说的是，博客不在于有多漂亮，关键是要多写，多输出，这样才能有进步，还有更多的详细过程请参考hexo 官方文档，如果有问题也可以在 `twiter` 上给我留言

### 参考: 
> [Hexo 官方网站](https://hexo.io/)  
> [Github Actions 入门](http://www.ruanyifeng.com/blog/2019/09/getting-started-with-github-actions.html)