---
title: Rust 入门
date: 2019-11-23 15:09:40
tags: rust
---
这是`Rust`入门第一课，我们要学会安装`rust`，编译一个`rust`文件，还有如何升级`rust`工具链

## 工具安装

### 下载
1. 适合任何平台
`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
2. `mac os` 平台
推荐使用`brew install rust`来安装

### 验证下载是否成功
`rustc --version`返回版本信息，则说明`rust`安装成功

## 工具介绍
### rustc 简介
`rust`编译器，负责处理，编译，链接`rust`语言源文件，比如说，要编译`file.rs`文件，可以使用命令`rustc file.rs`
### rustup 简介
`rust`工具链安装器，负责安装，管理和更新rust工具链，比如说，要更新所有工具链, 也就是说升级rust，可以使用命令 `rustup update`
### cargo 简介
`rust`包管理器，负责管理`rust`工程和他们的`module`依赖，这是是我们学习最常用的一个工具，我们来看看这个命令包含哪些参数

```
➜  ~ cargo
Rust's package manager

USAGE:
    cargo [OPTIONS] [SUBCOMMAND]

OPTIONS:
    -V, --version           Print version info and exit
        --list              List installed commands
        --explain <CODE>    Run `rustc --explain CODE`
    -v, --verbose           Use verbose output (-vv very verbose/build.rs output)
    -q, --quiet             No output printed to stdout
        --color <WHEN>      Coloring: auto, always, never
        --frozen            Require Cargo.lock and cache are up to date
        --locked            Require Cargo.lock is up to date
        --offline           Run without accessing the network
    -Z <FLAG>...            Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
    -h, --help              Prints help information

Some common cargo commands are (see all commands with --list):
    build       Compile the current package
    check       Analyze the current package and report errors, but don't build object files
    clean       Remove the target directory
    doc         Build this package's and its dependencies' documentation
    new         Create a new cargo package
    init        Create a new cargo package in an existing directory
    run         Run a binary or example of the local package
    test        Run the tests
    bench       Run the benchmarks
    update      Update dependencies listed in Cargo.lock
    search      Search registry for crates
    publish     Package and upload this package to the registry
    install     Install a Rust binary. Default location is $HOME/.cargo/bin
    uninstall   Uninstall a Rust binary
```

## 实战
### 创建一个工程
下面的命令是创建一个`hello`的工程，--bin指明创建一个二进制文件,是binary的缩写
` cargo new hello --bin`
### 编写源码
在目录`hello`下创建文件 `hello.rs`

```rust
fn main() {
  println!("hello world");
}
```
### 运行
下面的命令是运行一个`rust`工程
`cargo run`

## 总结
我们学会了如何利用`cargo`工具创建一个工程，编译源码，其实原理就是`cargo`编译源码时调用了`rustc`工具



