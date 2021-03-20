---
layout: post
title: k8s spring cloud 架构设计
categories: K8s
date: 2020-05-02 10:40:49
tags:
keywords:
description:
---

一、背景：由于容器化平台的成本、管理优势，现需要将spring cloud 迁移到容器化平台。
<br>

二、spring cloud、容器化平台特点。
<br>
  spring cloud：微服务框架，微服务的特点是每个服务器尽量少的完成独立任务，这就造成服务多，生产架构复杂，维护成本高。

  潜在隐患：

    1、服务压力伸缩不便捷
    2、服务部署速度慢

<br>
容器化平台：

    1、资源化服务器：所有node节点统一资源化，没有单点问题。
    2、服务压力管理：快速或者自动根据压力调整每个服务的节点数量
    3、服务调度管理：根据自定义或者默认规则调度pod到不通服务器，避免出现单点故障
<br>

三、迁移设计

服务器部署：

    1、需要在不同的机器部署注册中心，网关，其他的生产者和消费者需要填写eureka的注册中心ip。
    2、spring cloud架构如下图：

![sc](/public/img/sc.jpg)
<br>

容器化部署：

    1、由于k8s pods 更新迭代，每次变动都会更换ip地址，所以配置中的eureka 地址需要改成container id，container id是永久不变的。
    2、根据业务压力实际分布情况，调整服务节点数量，重分利用资源，避免浪费。
    3、由于k8s平台的架构不通，所以访问和请求过程也有部分区别，请求入口需要通过集群的ingres来负载，以便于实现高可用应用如下图：

![k8sc](/public/img/k8sc.jpg)
<br>

程序逻辑架构在整个设计过程中改动不大，较大的改动是在持续集成过程中，详情见：[<font color="blue">持续集成方案</font>](https://bravesnow.top/2020/05/01/git/Gitlab_cicd/)