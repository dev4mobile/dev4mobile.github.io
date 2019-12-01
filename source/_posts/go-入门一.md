---
title: go 入门一
date: 2019-12-01 20:34:10
tags: go
---
`Go` 作为一门云时代的语言，作为一名有追求的程序员，有必要开始学了，下面我们开始入门吧

## 开始 Go 之旅

### 安装 Go 开发工具
macOS 平台

```bash
brew install go
```
`brew` 是 `macOS` 平台上使用比较方便的软件管理工具，可以安装，卸载和升级，所以这里也就使用了 `brew` 这种方式，`brew` 可执行文件默认的安装地址是 `/usr/local/bin`，所以我们可以在 `/usr/local/bin/go` 找到可执行程序 `go`。

### 测试安装是否成功

```bash
➜  dev4mobile.github.io git:(develop) ✗ go version
go version go1.13 darwin/amd64
➜  dev4mobile.github.io git:(develop) ✗
```
我们看到 `go1.13` 已经安装完成

### 第一个 `Hello World` 程序

新建文件 `hello.go`, 输入下面的内容

```go
package main
import "fmt"
func main() {
  fmt.Printf("hello world!")
}
```
执行 `go run hello.go`

**Output**:
```bash
➜  ~ go run hello.go
hello world!
```
### 总结
我们学会了如何安装 `Go`， 并且使用 `Go` 打印了一个 `hello world!`。
