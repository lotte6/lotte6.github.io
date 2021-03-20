---
layout: post
title: linux_error
categories: Linux
date: 2018-12-24 10:22:23
tags:
keywords:
description:
---

<font color="red" size='10'>最大连接数</font>  
```auto错误
error: "net.ipv4.netfilter.ip_conntrack_max" is an unknown key
error: "net.ipv4.netfilter.ip_conntrack_tcp_timeout_established" is an unknown key

需要加载模块
nf_conntrack_ipv4
nf_conntrack
auto
```