---
layout: post
title: shell_tcp_awk
categories: Linux
date: 2018-12-19 00:05:40
tags:
keywords:
description:
---
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'