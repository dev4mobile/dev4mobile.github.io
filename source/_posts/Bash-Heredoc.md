---
title: Bash Heredoc
date: 2019-11-26 17:18:07
tags:
---
当写 `shell scripts` 时, 你可能会传递多行文本或代码块给交互式命令，比如 `cat`, `tee`, `sftp`。
`Heredoc` 是一种重定向类型，它允许你可以传递多行数据给到你当前输入的命令。
`Heredoc` 语法格式：
```bash
  [command] <<[-] ['DELIMITER' | DELIMITER]
    HERE-DOCUMENT
  DELIMITER
```
* 第一行是以可选命令开始，紧接着是重定向符号 `<<`, 可选 `-` 和 带引号的界定标识符号 或不带引号的标识符
  * 你可以使用任何字符串作为分隔符，我们最常用的是 `EOF` 或者 `END`
  * 如果使用未带引号的 `DELIMITER`, 那么传递给命令的 `HERE-DOCUMENT` 内容里面的 SHELL 变量会被替换掉, 当然可以使用 `\${}` 来解决
  * `<<` 后面添加 `-`, 将会导致以 **tab** 缩进的代码会被忽略掉，其它符号，比如空格不会被忽略掉
  * `HERE-DOCUMENT` 块里面可以包含命令，变量和任何其它类型的输入
  * 最后一行必须是不带引号的 `DELIMITER`

## `Heredoc` 基本用法
我将使用 `cat` 作为命令作为演示如何使用 `Heredoc`。

下面的 `Example`里面， 我向 `HERE-DOCUMENT` 内容块里面传递了环境变量 `PWD` 和 执行命令 `whoami` 
```bash
cat << EOF
  The current directory is: $PWD
  You are logged in as: $(whoami)
EOF
```
从下面的输出可以看出，环境变量 `PWD` 和 `whoami` 被替换掉了

```bash
  The current directory is: /root
  You are logged in as: root
```
如果我们在开始处的 `DELIMITER` 使用单引号或双引号, 那么结果又是怎样的？

```bash
cat << 'EOF'
  The current directory is: $PWD
  You are logged in as: $(whoami)
EOF
```
结果是环境变量和命令都没有被替换掉

```bash
Output:
  The current directory is: $PWD
  You are logged in as: $(whoami)
```

如果 `Heredoc` 使用 `-`, 那么 `HERE-DOCUMENT` 块里面的缩进将被移除。
```bash
cat << EOF
  The current directory is: $PWD
  You are logged in as: $(whoami)
EOF
```
```bash
Output:
The current directory is: $PWD
You are logged in as: $(whoami)
```

如果不想在命令行显示，那么可以使用 `>` 或者 `>>` 重定向

```bash
cat << EOF > test.txt
The current directory is: $PWD
You are logged in as: $(whoami)
EOF
```
`test.txt` 的内容如下所示， 当使用 `>` 文件将会被重写， 如果是 `>>`, 内容会被添加到文件后面
```bash
[root@panda ~]# cat test.txt
The current directory is: /root
You are logged in as: root
```

`heredoc` 的输入也会被管道化，下面的例子是使用 `sed` 处理 `heredoc` 的内容， 实现的是将所有 `l` 字母替换为 `e`
```bash
cat << EOF | sed 's/l/e/g'
Hello
World
EOF
```
结果为：

```bash
Output:
Heeeo
Wored
```

同样可以将管道里面的内容写入文件 

```bash
cat << EOF | sed 's/l/e/g' > test.txt
Hello
World
EOF
```

## SSH 连接使用 `Heredoc`

通过 `ssh` 远程执行多行命令，我们也可以使用 `Heredoc`。
比如 使用 ssh 连接远程的机器，-T 选项是不开启 tty, 这样执行完就断开连接了

```bash
ssh -T cdh.remote << 'EOF'
echo "The current local working directory is: $PWD"
EOF
```
结果：
```bash
 The current remote working directory is: /root 
```

## 总结

我们已经学会了如何在 `SHELL` 脚本里面如何使用 `heredoc`, 大家有什么问题，可以给我留言。
