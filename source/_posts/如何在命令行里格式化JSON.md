---
title: 如何在命令行里格式化JSON
date: 2019-12-01 13:42:29
tags: json
---
身为一名软件工程师，我们经常需要在命令行里面优雅的显示 `JSON`，那么如何做呢？

有两种比较简单的方式可以从命令行漂亮的打印 `JSON` 字符串，第一种使用python，另外一种就是使用 `jq` 命令。

![Screen Shot 2019-12-01 at 14.18.36.png](https://i.loli.net/2019/12/01/ZpXtrfE4NkgOeDm.png)

## 使用 python
用法：
```bash
input | python -mjson.tool
```
`input` 作为json输入流，经过管道，最后使用 `python -mjson.tool` 处理

Example 1:
```bash
echo '{"perso":{"name": "dev4mobile"}}' | python -mjson.tool
```
Output:

```json
{
    "perso": {
        "name": "dev4mobile"
    }
}
```
Example 2:

```bash
curl http://127.0.0.1:8080 | python -mjson.tool
```
Output:

```json
{
    "timestamp": "2019-12-01T06:01:46.993+0000",
    "status": 404,
    "error": "Not Found",
    "message": "No message available",
    "path": "/"
}
```
上边是常用的两个例子

## 使用 jq 命令
安装 `jq`
1. mac os 平台
```bash
brew install jq
```
2. Ubuntu 平台  
```bash
sudo apt-get install jq
```
用法：

```
input | jq .
```
`jq` 后面的 `.` 是代表整个input 对象，所以`jq .`就是格式化整个 `JSON` 串

Example 1
```bash
echo '{"perso":{"name": "dev4mobile"}}' | jq .
```
Output:

```json
{
  "perso": {
    "name": "dev4mobile"
  }
}
```
Example 2

```bash
curl http://127.0.0.1:8080 | jq .
```
Output:

```json
{
  "timestamp": "2019-12-01T06:12:19.838+0000",
  "status": 404,
  "error": "Not Found",
  "message": "No message available",
  "path": "/"
}
```


