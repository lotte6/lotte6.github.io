---
layout: post
title: 持续集成方案
categories: Git
date: 2020-05-01 20:05:00
tags:
keywords:
description:
---

在我的其他文章已经介绍过gitlab cicd的原理，这章就具体介绍一下cicd的生产应用方案。
<br>

一、如果选择使用gitlab的持续集成，那必须使用gitlab了，无可厚非，自行部署也好，使用官方的也罢原理和流程都是一样的。为什么选择gitlab cicd，一站式解决编译平台问题。最流行的Jenkins，臃肿配置步骤多，安装插件多，项目量较大情况备份无法处理。gitlab的runner节点是可以选用任意节点或者K8s平台。
<br>
二 、需要注意的地方很多，生产使用第一要素就是高可用，如果私有部署gitlab首先需要对gitlab做ha（High Availability 高可用）的解决方案。

1、首先需要了解gitlab哪些数据是需要持久化的：
    a. Database 
    b. Redis 
    c. file

    官方给出的解决方案：
        1. db，db使用的PostgreSQL所以需要高可用的PostgreSQL
        2. redis redis高可用方案：主备，redis cluster
        3. 持久化一些文件，官方推荐使用nfs，nfs需要HA，当然可以使用其他分布式文件系统也可以比如ceph集群。
        4. load balance。对gitlab 服务器进行有健康检查的负载均衡
        到此官方提供的ha方案结束，需要硬件成本很高，维护成本也很高，当然这样的HA比较完美，能做到无感的切换。

2、处于不同发展阶段的团队显然官方提出的方案成本较高并不适用，由于docker的普及，部署使用docker部署，根据docker的特性，挂载的数据目录是完全可控的，完全同步数据目录即可实现完整备份，这样虽然失去实时高可用的优势，但是带来的好处也是显而易见，只需要两台主机即可，定时或者实时同步文件即可，实时同步方案可选择lrsync或者inotify+rsync 来实现文件实时同步。

Gitlab docker部署详见[<font color="blue">Gitlab docker 部署</font>](https://bravesnow.top/2020/04/03/git/Gitlab_deploy/)
<br>


三、gitlab自动化文件来触发有几种条件:
 
    a. 每次推送都会触发 
    b. 根据tag触发 
    c.根据某个目录下文件变化

原理详情[<font color="blue">点击打开链接</font>](https://bravesnow.top/2020/04/03/git/Gitlab_ci/)。
<br>


四、每个runner 都需要部署gitlab runner服务来与gitlab通讯联动。runner也需要有对应的编译环境和处理中间过程的环境（批量部署ansible、对k8s集群或者服务器的认证）如果是k8s或者docker环境需要更新images，推送到registry服务器。如果是服务器集群需要同步更新包到目标服务器

    备注：这里面需要设计回滚流程
    如：docker环境需要对每次镜像打包做区分，可以选择tag或者commit id做区分，在做回滚时候可以快速识别对应版本。
    非k8s环境可以通过备份源文件以便于回滚操作。
<br>

五、最后进行代码更新，runner最后会调用k8s api对k8s集群进行升级或者使用批量部署工具来实现更新服务器应用。具体更新需要根据不用环境制定对应方案。流程图如下：
![cicd](/public/img/cicd.jpg)
<br>

六、在最后的升级过程中需要注意的是程序升级中怎么做到不间断服务：
    1、 首先说k8s集群：需要开启滚动升级配置如下:
    ```
    strategy:
    # indicate which strategy we want for rolling update
        type: RollingUpdate
        rollingUpdate:
        maxSurge: 1  
        maxUnavailable: 1 #可用百分比表示
    ```
还需要配合探针（liveness、Readiness）一起使用，否则仍然会出现无法访问的情况，还需要考虑到应用启动时间

2、 如果是服务器集群更新需要考虑到负载均衡的调整，或者轮训更新后端应用，根据应用的特性来具体部署。
<br>

七、代码提交审核权限控制和流程
```
1、角色阐述：
maintencer：具有master主分支控制权限，代码审查权限，merge权限
developer： 只有主分支之外的分支提交权限，merge request 权限

2、环境描述（命名方式自行定义，分支名称与环境保持一致，以便于区分）：
dogfood：   测试环境 
staging：   预发布环境
prod：      生产环境

3、上线流程：
Developer 提交非主分支，则会直接更新到对应环境。
如Developer需要将代码上线到prod，则需要发出merge request
需要具有maintance权限的用户审核后，执行merge操作。
```
![devprocess](/public/img/devprocess.jpg)
