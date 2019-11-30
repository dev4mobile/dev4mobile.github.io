---
title: Linux Shell 快速入门
date: 2019-11-30 12:14:29
tags: shell
---
本文主要介绍 `Linux Shell` 编程相关基础知识，可以让初学者快速入门，内容主要包含以下几个方面：
> Shell 脚本概述
> Shell 脚本运行与调试 
> Shell 如何定义变量
> Shell 表达式
> Shell 流程控制
> Shell 函数

## Shell 脚本概述
`Shell` 脚本是一门简单的脚本语言，主要由 `Shell 基本语法` + `Linux 命令` 组成，所以说要写好 `Shell` 脚本，必须掌握好一些重要的 `Linux 命令`。
下面是一个最简单的 `Shell` 脚本内容，我们可以将其保存在一个`test.sh` 文件中
```bash
  #!/bin/bash
  # This is a output string `https://dev4mobiles.com`
  echo "https://dev4mobiles.com"
```
第一行 `#!` 是约定标记，英文读作`shell bang`，后面的 `/bin/bash` 指定了脚本需要哪种解释器来解释, 本文使用了常用 `bash` 解释器。
第二行 以 `#` 开头的行就是注释，会被解释器忽略
第三行 功能是向命令行输出字符串，字符串一般用双引号引起来

## Shell 运行与调试
`Shell` 脚本的执行是解释执行的，也就是说边解释边执行
### 运行
运行方式有两种:
1. 作为可执行程序 

  ```bash
    chmod u+x test.sh
    ./test.sh
  ```
  首先需要给文件 `test.sh` 添加可执行权限，然后执行 `./test.sh` 就可以得到输出结果, 其中的 `.` 是标识在当前目录找可行性程序 `test.sh` 来执行，并且使用定义的 shell bang `#!/bin/bash` 来执行程序

2. 作为解释器参数来执行, 可以使用解释器 `sh`, 或者其它解释器 `bash`, 使用这样的方式来执行程序，其中指定的 `shell bang` 是不生效的的
  ```bash
    sh test.sh
    bash test.sh
  ```
  作为解释器参数来执行脚本，不需要可执行性权限，所以这种方式也是使用最多的

### 调试
一般常用的有两个：
1. 检查语法命令 `sh -n test.sh`, 没有输出，说明没有语法错误
2. 调试命令 `sh -x test.sh` 
  下面是执行 `sh -x test.sh`的结果
  ```bash
    + echo https://dev4mobiles.com
    https://dev4mobiles.com
  ```
  第一行 带`+` 表明调试器真正执行的命令，不带 `+` 的是我们的程序输出, 所以结果 `https://dev4mobiles.com` 是命令 `echo "https://dev4mobiles.com"` 的输出

## 如何定义变量

下面来看一段程序，程序表明了如何定义程序

```bash
#!/bin/bash
name='dev4mobile'
age=20
website="dev4mobiles.com, name=${name}"
money=10.2
echo $name $age $website $money
echo "$name $age"
arr=(1 2 3)
echo "${arr[@]}"
```
程序说明：
第一行：指定了解释器为 `/bain/bash`
第二行：定义一个变量为 `name`，值为一个用单引号引起来的字符串
第三行：定义一个整形变量 `age`, 值为 `20`
第四行：定义一个用双引号引起来的字符串website, 双引号里面的字符串可以通过`${}` 的方式引用其它变量，这里引用了 `name` 字段，
但是像第一行用单引号定义的字符串里面不可以引用其它字符串，所以双引号可以拼接字符串
第五行：定义了一个浮点数
第六行：使用 `echo` 输出多个变量， 变量以空格分开
第七行：输出用双引号拼接的多个字符串
第八行：定义一个名为 `arr` 的数组
第九行：输出数组

执行 `bash test.sh`, 将会输出结果

```bash
dev4mobile 20 dev4mobiles.com, name=dev4mobile 10.2
dev4mobile 20
1 2 3
```

变量分为`自定义变量`和`环境变量`，上面的程序就是自定义变量，还有一种环境变量，是系统已经定义好的，我们直接拿来使用就行了
```bash
#!/bin/bash
echo "\$PWD=$PWD"
echo "\$TERM=$TERM"
echo "\$HOME=$HOME"
echo "\$PATH=$PATH"
```

为了不让`${}` 解析成变量， 我使用 `\` 进行转义

Output:
```bash
$PWD=/home/dev4mobile/data
$TERM=xterm-256color
$HOME=/home/dev4mobile
$PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
```

## Shell 表达式

```
#复制表达式
var=5
#表达式计算
expr $var + 5 
#测试 var 是否与 5 相等
test $var -eq 5 
#测试 var 变量 是否与 5 相等的另外一种写法
[ $var -eq 5 ], 记住[] 里面的内容必须以空格开始，空格结束
#测试develop文件是否为目录
test -d ./develop
```
注意上面的脚本不能直接拷贝来运行，需要配合其它表达式来执行


## Shell 流程控制
* if 流程

  ```bash
  #!/bin/bash
  read Name
  if test "$Name" = "dev4mobile";then
    echo "true"
  else
    echo "false"
  fi
  ```
  执行 `bash test.sh`
  注意：字符串相等使用 `=`且等号左右两边必须包含**空格**, 不然的话，解释执行会报错

* case 语句
```bash
#!/bin/bash
read Animal
case $Animal in
  "pig")
     echo "pig"
     ;;
  "beef")
     echo "beef"
     ;;
   *)
     echo "default"
   ;;
esac
```
* for 循环
两种写法
第一种写法
```bash
#!/bin/bash
for((var=1; var<10; var++));do
  echo $var
done
```
第二种写法
```bash
#!/bin/bash
for var in `ls -al`;do
  echo $var
done
```
其中 **\`ls -al\`** 是执行 `ls -al` 命令

## Shell 函数
定义函数有格式
```bash
[function] fun_name() {
  [return xxx]
}
```
其中`[]` 中的内容是可以省略的

```bash
#!/bin/bash

#定义函数
function print(){
  echo "https://dev4mobiles.com"
}
#调用函数
print
#定义带参数的函数
say(){
 echo $1 $2
 #只能返回数字且范围为0～255
 return 2
}
say 1 2
# 得到函数的返回值
echo $?
```

⚠️不能在函数 `()` 定义参数， 方法内接收参数 `$1`, `$2` 格式来接收参数
调用方法使用方法名后跟参数
只能立刻使用 `$?` 来得到结果，其中方法返回的参数只能是0～255之间的值(很奇葩，不知道为啥设计成这样)

## 总结
看过上面的教程，相信差不多能够入门了，剩下来的就是花时间多练习，相信你会成为 `shell` 脚本专家
