---
title: 使用 Github Action 搭建 Hexo 博客
date: 2019-11-21 11:45:56
tags: hexo
---
`HEXO`是常用的博客平台
## 搭建过程

### 软件准备
1）安装 `nodejs`
2) 安装 cnpm npm install cnpm -g
3) 安装 cnpm install hexo-cli -g

### 创建blog
git init
git submodule add --force https://github.com/dev4mobile/hexo-theme-again themes/again


修改主题之后，更新submodule
git submodule update --recursive --remote

1)hexo init \<github user name>.github.io
2) cd \<github user name>.github.io 目录
3)cnpm install
4)hexo server
参考: 1) [Hexo](https://hexo.io/)
     2) [Github Actions 入门](http://www.ruanyifeng.com/blog/2019/09/getting-started-with-github-actions.html)