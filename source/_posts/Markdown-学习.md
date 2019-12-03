---
title: Markdown 学习
date: 2019-12-01 21:17:14
tags: markdown
---
我们写[博客](https://dev4mobiles.com)经常要使用到 `Markdown` 语法，所以本篇博客将会简单的介绍 `Markdown` 用法， 下边以**输入的文本**和**效果** 两部分来展示

## 一、标题

是以 **1 ~ 6** 个 `#` 开头的文本, `#` 越多，标题大小越小

```markdown
# 一级标题
## 二级标题
### 三级标题
#### 四级标题
##### 五级标题
###### 六级标题
```

# 一级标题
## 二级标题
### 三级标题

---

## 二、粗体和斜体

```markdown
**这是粗体**
*这是斜体*
***这是粗体加斜体***
```
**这是粗体**
*这是斜体*
***这是粗体加斜体***
---

## 三、图片引用

```markdown
![微信二维码.jpg](https://i.loli.net/2019/12/01/bKJMkfalvrVZhPp.jpg)
```

<img style="width:100px" src="https://i.loli.net/2019/12/01/bKJMkfalvrVZhPp.jpg">

---
## 四、无序列表
```markdown
- 第一部分
- 第二部分
- 第三部分
```

- 第一部分
- 第二部分
- 第三部分

---
## 五、引用
引用的格式是在 `>` 后面书写文字, 如下

```markdwon
> 读一本好书，就是在和高尚的人对话。 --歌德
> 雇佣制度对工人不利，但工人无法摆脱这个制度。 --dev4mobile
```
> 读一本好书，就是在和高尚的人对话。 --歌德
> 雇佣制度对工人不利，但工人无法摆脱这个制度。  --dev4mobile
---
## 六、表格

可以使用冒号来定义表格的对齐方式，如下：

```markdown
| 姓名   | 年龄  | 工作     |
| :----- | :---: | ----: |
| 小可爱 |  18   | 吃可爱多 |
```

| 姓名   | 年龄  | 工作     |
| :----- | :---: | ----: |
| 小可爱 |  18   | 吃可爱多 |

---
## 七、删除线

在需要删除文字的前后各使用两个 `~`, 如下：

```markdown
~~这是要被删除掉的内容～～
```
~~这是要被删除的内容~~

---
## 八、分割线

可以在一行中用三个以上的减号来建立一个分号，同时需要在分割线的上面空一行，如下：

```markdown
---
```
---

## 九、HTML

支持原生 `HTML` 语法, 如下：

```html
<span style="display:block; text-align:left; color:orangered;">橙色居中</span>
<span style="display:block; text-align:center; color:blue">蓝色居中</span>
```
<span style="display:block; text-align:left; color:orangered;">橙色居中</span>
<span style="display:block; text-align:center; color:blue">蓝色居中</span

---

## 总结

本文简单的介绍了 `markdown` 的一些基本用法，如果想要学习更多知识，请访问我的博客[https://dev4mobiles.com]

## 参考：

> https://mdnice.com/
