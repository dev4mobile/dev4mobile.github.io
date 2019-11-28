---
title: Lua 基础入门
date: 2019-11-28 10:10:29
tags:
---
# 学习 Lua 的必要性
因为工作中经常与 `nginx` 打交道，而 `nginx` 又有大量的模块是由 `Lua` 写的，所以有必要学习下 `Lua` 基础的语法知识。`Lua` 作为一门动态脚本语言，解释执行，和 `JavaScript` 有点相似。

## 语言特点
1. 语句结束没有分号
2. 跟 `JavaScript` 很像
3. 默认定义的是全局变量，定义局部变量需要加 `local` 关键字
4. 数组索引从1开始
5. 没有 `i++ ` 操作符号，只能 `i = i + 1`

## 注释
1. 单行注释  
	`--` 注释内容
3. 多行注释
	`--[[ `
       注释内容
	`]]--`
	
## 内置数据类型	
总共有6种内置数据类型， 其中包括nil, boolean, number, string, table, function
1. `nil`
	通常是没有赋值，直接使用才会是这个值, 比如说下面的代码直接打印 变量 `name`
	```lua
	   print(name)
	```
   在 `ifelse ` 判断语句中，nil 被当成false 分支，但 `nil ~= false`, 在 Lua 语言当中，不等于使用 `~=` 来表示, 而不是我们常见的 `!=` 。
2. `boolean`
    有两种取值：true, false
3. `number`
    所有的数值类型都使用 `number` 来表示，不管是整数，还是浮点数，其实内部的存储方式是双精度类型。
4. `string`
	字符串可以用双引号，也可以用单引号包围起来，特殊字符需要转义
	```lua
	name = "dev4mobile"
	name = 'dev4mobile'
	nameWithAge = 'dev4mobile \n 25'
	```
	多行字符串
	```lua
	 welcome = [[
	   hello world
	 ]]
	```
	
5. `table`
   其实就是其它语言里面的对象， 有两种表现方式，一种是数组，一种是字典(Map)，
   都是使用大括号括起来的。记住数组索引从1开始。
   ```lua
    arr = { 1, "dev4mobile", 'cn.dev4mobile@gamil.com', 12.3, function()endv}
    person = { name = 'dev4mobile' }
   ```
6. `function`
定义如下，以 `function `关键字作为开头，`add` 是函数名字
	 ```lua
	 -- 一般定义
	 function add(a, b)
	    return a + b
	 end
	 -- 传递多个参数
	 funcation print(...)
	   print(...)
	 end
	 -- 返回多个参数
	 function()
	   return "abc", 12, function() end
	 end
	 ```
	
## 控制流语句
1. 循环
 	循环有3种写法，for， while，repeat .. until
 	说明： `#变量名` 表示读取变量的长度，可以是字符串和数组
 	```lua
 	  -- for 循环
    	arr = { 1, 2, 3, 4, 5 }
    	for i=1, #arr do  -- 索引从1开始
    	  print(arr[i])
    	end
   ```
   ```lua
   -- while 循环
     arr = { 1, 2, 3, 4, 5 }
     i = 1
     while i <= #arr do
       print(arr[i])
       i = i + 1
     end
   ```
   ```lua
   -- repeate until 循环
   arr = { 1, 2, 3, 4, 5 }
   i = 1
   repeat
   		print(arr[i])
   		i = i + 1
   until i >= #arr
   ```
2. 分支	( ifelse )
```lua
name = "dev4mobile"
if #name > 10 then
  print("name length = ".. #name)
elseif #name >5 then
   print("name length > 5, real length = "..#name)    -- 两个点..代表字符串?
else 
  print("name length < "..#name)
end
```
## 面向对象
实现原理：有点类似 `JavaScript` 的实现使用原型方式，使用`函数 + table` 实现。
* 模块
在写demo之前有必要先介绍下模块的概念，一般来说一个文件就是一个模块，跟 `JavaScript` 一样， 导入模块关键字 `require`, 导出模块关键字`return`
下面我们来新建一个模块名
首先新建一个文件名： perosn.lua，输入下面代码
	```lua
	-- 定义模块
	-- 解释器
	#!/usr/local/bin/lua
	local Person = {}
	-- 导出模块名，类似JavaScript中的export
	return Person 
	```
	```lua
	-- 导入模块
	-- 解释器
	#!/usr/local/bin/lua
	local perosn = require('person')
	```
* 构造对象
首先新建一个文件名： perosn.lua，输入下面代码
```lua
	-- 定义模块
	-- 解释器
	#!/usr/local/bin/lua
	local Person = {}
	-- 定义构造函数
	function Person:new(name, age)
	   -- __index 指向 父类 table
	   -- setmetatable 关联了 新创建的对象 { name = name, age = age } 与 Person 对象
	  return setmetatable({ name = name, age = age }, { __index = Person })
	 end
	function Person:toString() 
		print('name='..self.name..', age='..self.age)
	end
	-- 导出模块名，类似JavaScript中的export
	return Person 
```
```lua
	-- 导入模块
	-- 解释器
	#!/usr/local/bin/lua
	local Perosn = require('person')
	-- 调用构造函数
	local person = Person:new("dev4mobile", 21)
	-- 调用对象的toString方法, 这个方法是父类方法，需要我们setmetatable来绑定，也就是我们定义对象时 setmetatable({ name = name, age = age }, { __index = Person }) 来绑定的
	person.toString()
```