---
title: clojure 入门
date: 2019-12-11 15:48:43
tags: clojure
---

安装

`brew install leiningen`

`tldr lein`

`lein repl`

`lein new hello-world`

```clojure
(ns hello-world.core)

(defn -main [& args]
  (println "Hello world"))
  
```

`lein run`