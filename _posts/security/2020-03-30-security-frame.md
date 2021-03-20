---
layout: post
title: 安全架构方案
categories: Security
date: 2020-03-30 16:37:49
tags:
keywords:
description:
---

一、 背景： 应公司需求，按照当时环境设计一套安全架构体系

二、 思维导图

<iframe id="embed_dom" name="embed_dom" frameborder="0" style="display:block;width:750px; height:1200px;" src="https://www.processon.com/embed/5dcb7190e4b022abb6321730"></iframe>

三、 设计方案

- 1	外部安全
    - 1.1	各种类型攻击
        - 1.1.1	 流量攻击
            - 1.1.1.1 出口部署高防代理服务器，如有必须要部署欧美大流量高防主机，相对于亚洲流量清洗能力，欧美的清洗能力较为强劲，但是就速度而言相对较慢，所以，目前策略尽量使用亚洲，如果流量达到无法清晰，则选用欧美流量清洗厂商
            - 1.1.1.2	智能dns监控，自动切换解析ip到可用主机，目前各大DNS厂商均提供付费只能检测服务，通过检测结果来只能解析到可用IP，从而实现智能防攻击
        - 1.1.2	 Cc攻击
            - 1.1.2.1	现有安全市场很多产品可以针对cc攻击做有效的防护，这类有特征的攻击模式，选用云厂商或者亚洲节点厂商即可。
            - 1.1.2.2	服务主机部署防御模块，利用nginx的lua扩展模块，来增加防御能力，通过控制频率，以及验证cookie等方式来达到- 防御目的
        - 1.1.3	 系统漏洞攻击
            - 1.1.3.1	利用云主机安全组和主机防火墙策略，只打开服务端口防止他人进行扫描从而获取系统基础服务漏洞。
            - 1.1.3.2	集群内容所有主机部署安全防御工具，如有异常的行为即会被自动添加到黑名单，从而拒绝来源ip的访问。
        - 1.1.4	 程序攻击
            - 1.1.4.1	通过服务器防御模块，禁止扫描目录，防止常见注入攻击以及上传文件等漏洞。
            - 1.1.4.2	加强代码程序健壮性，尽量避免常见和以及被其他平台已经暴露过的漏洞，从而提高安全性
        - 1.1.5	 Xss攻击
            - 1.1.5.1	对用户输入的数据进行HTML Entity编码
            - 1.1.5.2	移除用户上传的DOM属性，如onerror等，移除用户上传的style节点，script节点，iframe节点等
            - 1.1.5.3	避免直接对HTML Entity编码，使用DOM Prase转换，校正不配对的DOM标签
    - 1.2	其他因素
        - 1.2.1	 行业敏感性
        - 1.2.1.1	服务器托管厂商
            - 1.2.1.1.1	目前使用华为云厂商，存在一定风险，由于国内政策问题，我们将所有服务放在华为云风险较大，所以目前计划使- 用代理来隔离真实服务器的所在位置。
            - 1.2.1.1.2	备用环境计划使用其他海外主机厂商或者租用IDC使用自己的服务器来部署灾备环境，能做到短时间内快速迁移环- 境规避风险
        - 1.2.1.2	DNS服务器厂商
            - 1.2.1.2.1	DNS厂商使用cloudflare，属于海外厂商，不存在行业问题。
        - 1.2.1.3	CDN厂商
            - 1.2.1.3.1	CDN用cloudflare，属于海外厂商，不存在行业问题，由于目前没有大量用户，使用免费版尚可，以后可能考虑- 更换其他厂商cdn
        - 1.2.1.4	代理厂商
            - 1.2.1.4.1	目前使用多家高防主机做代理服务器，可以隔离真实服务器信息，避免暴露服务器集群ip信息，保护隐私信息
- 2	内部安全
    - 2.1	办公环境安全
        - 2.1.1	 网络安全
            - 2.1.1.1	公网出口安全
            - 目前公司办公室主要在techzone大楼，接入了菲律宾本地、中国、香港宽带以满足各部门的办公需求。为确保公司网络不被入- 侵，在公网出口放置了一主一备两台华为USG6630防火墙，将所有出入公网的流量通过防火墙进行管控。根据公司业务需求，目前防火墙上启用了如下策略
                - 2.1.1.1.1	流量日志记录，保持24小时
                - 2.1.1.1.2	URL黑名单，阻止黑名单中的URL并且记录
                - 2.1.1.1.3	应用黑名单，阻止能够识别到的黑名单应用例如telegram、teamviewer
                - 2.1.1.1.4	根据不同部门创建不同的分流策略，使之使用最合适的网络宽带
                - 2.1.1.1.5	带宽限制，针对每个IP进行带宽使用限制不超过4MB
                - 2.1.1.1.6	仅仅对服务器网段的服务器的特定端口进行映射和开放，并且限制IP访问
            - 2.1.1.2	办公网络接入管控
            - 由于公司办公设备涉及计算机、手机、打印机、平板、笔记本等众多不同类型的设备，且还在不断增加，给统一管控带来了非常大- 的困难。在考虑工作量、实现方法、实现成本上，IT没有采取NAC的方案，而是直接使用mac地址准入的方式，限制外来设备以及- 公司设备入网。目前IT通过以下策略来进行网络准入：
                - 2.1.1.2.1	维护设备列表，列表中会登记对应设备的mac地址
                - 2.1.1.2.2	新设备需要连入网络时，需要到IT进行申请，添加白名单后方可入网
                - 2.1.1.2.3	Mac地址列表保存在核心交换机中，以确保设备漫游时不受影响
                - 2.1.1.2.4	IT定期清理设备列表，对于长期未上线的设备，将移除出白名单
            - 2.1.1.3	服务器网络访问
            - 公司内部办公服务器包括Exsi主机、windows AD、Exchange邮件、即时沟通工具大蚂蚁、文件共享、OA、考勤、DHCP、电话- 呼叫系统、IP-Guard、防病毒、WSUS、KMS、打印服务器、应用虚拟化、堡垒机以及财务后台、客服系统等。针对办公服务器的访问，目前通过以下策略来进行管控：
                - 2.1.1.3.1	所有服务器远程登录访问必须经过堡垒机
                - 2.1.1.3.2	Esxi主机仅允许IT部门访问
                - 2.1.1.3.3	针对不同的服务器，客户端仅能访问对应的端口
                - 2.1.1.3.4	内部网段之间22、3389端口全部关闭，仅堡垒机能够访问
                - 2.1.1.3.5	用户访问应用服务器，通过内部域名进行访问，尽量使用https
                - 2.1.1.3.6	针对应用服务器例如财务后台，限制仅特定的IP能够访问，阻止其他人访问
            - 2.1.1.4	网络设备管控
            - 公司内部网络设备包含各个防火墙、三层交换机、二层交换以及各个路由器，摄像头，考勤机等，全部与办公网络隔离，处于单独- 的VLAN，并且限制仅IT能够访问。目前公司对于网络设备管控策略如下：
                - 2.1.1.4.1	每天定期巡检网络设备，检查运行日志，防止故障和入侵；
                - 2.1.1.4.2	定期备份配置文件，并且统一存放；
                - 2.1.1.4.3	防火墙、核心交换机以及关键网络设备接入UPS，防止由于突然断电导致网络中断以及配置丢失；
                - 2.1.1.4.4	摄像头、考勤机、打印机等全部位于隔离的单独网络中，设置不允许连入互联网以及仅允许服务器网段访问；
                - 2.1.1.4.5	公司内部网络设备定期进行例行巡检，以确保运行稳定安全
            - 2.1.1.5	硬件服务器管控
            - 公司内部现有两个小机房，其中1003房的机房中部署有9台Dell机架式硬件服务器，型号为R740以及老旧的R620，服务器上运行- 由ESXI主机组成的群集。公司内部办公使用的各种服务器均运行在这些群集上。针对dell硬件服务器，目前管控策略如下：
                - 2.1.1.5.1	Dell服务器上部署了ESXI系统，管理口和数据口分开，并且多个网卡互为主备，确保运行稳定以及管理和生产数- 据流量分开；
                - 2.1.1.5.2	Dell服务器启用iDRAC管理，并且位于单独隔离的VLAN中，确保仅管理员能够访问和控制；
                - 2.1.1.5.3	核心服务器采用双电源，同时接通UPS和市电，确保跳电、断电时服务器仍然能够运行一段时间，确保数据存储不- 遗失；
            - 2.1.1.6	机房安全管控
            - 公司在techzon办公室部署有两个小机房，分别位于1002和1003。其中1002机房中仅部署了7台二层交换机，用于日常办公、- CCTV摄像头、考勤机、打印机等网络使用；1003机房中部署了防火墙、核心交换、安全审计设备以及物理服务器。针对机房安全- 管控，目前策略如下：
                - 2.1.1.6.1	机房使用单独一套门禁，仅授权管理员有进入的权限；
                - 2.1.1.6.2	每日定期对机房进行巡检，确保机房内部环境温度和湿度稳定；
                - 2.1.1.6.3	机房门口和内部安装摄像头，进行24小时监控；
                - 2.1.1.6.4	机房内部部署有两台空调，确保空调不因维修导致机房温度过高；
                - 2.1.1.6.5	机房内部使用UPS电源，确保短时间内不断电；

        - 2.1.2	 办公环境信息安全
            - 2.1.2.1	网络隔离
            - 由于公司内部部门众多，各部门对网络需求也不一致，IT部门为公司接入了菲律宾、香港、中国等多条线路，并且根据各部门的不- 同需求进行分配。同时，对每个不同需求的部门，设置不同的VLAN，VLAN之间设置了网络隔离，仅根据需求进行开放部分端口。目前总体策略如下：
                - 2.1.2.1.1	内部VLAN之间22、3389端口对应的ssh协议和RDP协议全部禁止，仅根据需求进行开放堡垒机的访问权限；
                - 2.1.2.1.2	根据公司当前的运营模式，每个二级或者三级部门都进行单独的VLAN划分，如果发生座位变换，VLAN信息将即时- 更新；
                - 2.1.2.1.3	内外网分离策略：通过vmware horizon viewer桌面云方式将部分敏感部门例如薪酬和签证的计算机进行内外- 网分离。由于桌面云性能以及操作体验问题，暂时未普及至业务部门和开发部门；
                - 2.1.2.1.4	根据不同业务类型，将公司内部办公网络进行分区，大致如下：
            - 2.1.2.2	设备网络准入
            - 目前公司启用了MAC地址网络准入的控制方式对设备进行网络准入控制，相比NAC等方案，MAC地址网络准入存在管理复杂，工作量- 较大等缺点，但是其优点是只要交换机支持，即可以低成本来获得网络准入控制的效果。目前准入策略如下：
                - 2.1.2.2.1	所有设备包括电脑、手机、平板、笔记本连入公司网络，需要登录mac地址，并且加入白名单方可入网；
                - 2.1.2.2.2	IT定期进行清理，对于长时间未上线的设备，将移除白名单；
                - 2.1.2.2.3	针对个人设备连入网络，设置单独的VLAN，临时接入后移除白名单；
                - 2.1.2.2.4	不允许员工将个人笔记本、平板等私自带入公司，一经发现，处以没收。
            - 2.1.2.3	企业用户统一身份验证
            - 企业用户统一身份验证用于员工使用公司办公计算机、信息化管理系统、即时沟通工具、文件共享、企业邮箱等登陆和验证。目前- IT在公司内部部署了windows AD进行员工账号和验证管控，其他IT系统均集成了AD验证，并且根据不同部门用户进行权限授权，- 同时为将来进行内外网分离进行了基础架构的设计。
            - 目前公司对于员工身份验证账号有如下策略：
                - 2.1.2.3.1	每个员工有唯一的账号ID，不允许重名以及重复使用；
                - 2.1.2.3.2	员工账号密码在第一次启用时必须修改密码；
                - 2.1.2.3.3	员工账号密码复杂度必须符合最少8位，3种字符组合；
                - 2.1.2.3.4	员工账号密码有效期为三个月，每三个月强制修改密码一次；
                - 2.1.2.3.5	员工账号ID与计算机权限、OA权限、邮箱发送邮件权限、大蚂蚁组织架构权限、考勤机权限等绑定；
                - 2.1.2.3.6	员工入职前一天，人事部门必须发送新人入职信息给IT，方可创建账号，未经人事确认的员工，将不予创建账号；
                - 2.1.2.3.7	员工账号不允许给与其他人使用，一经发现，将进行全公司通报批评并且处以对应惩罚；
                - 2.1.2.3.8	员工账号密码连续输入三次错误，账号自动锁定三分钟；
                - 2.1.2.3.9	普通员工账号对计算机仅有使用权限；
                - 2.1.2.3.10	IT收到员工离职流转单后，员工账号将被禁用，保留2周后将进行统一删除；
                - 2.1.2.3.11	员工账号仅能在公司内部使用；
            - 2.1.2.4	计算机硬件安全管控
            - 计算机硬件安全管控主要针对计算机本身具备的各种外置接口进行管控，目前IT通过IP-GUARD、物理措施等方式进行管控，针对- 于开发部门的计算机，后续还将采取机箱柜进行安全保护。目前的管控措施如下：
                - 2.1.2.4.1	通过IP-GUARD禁用USB口的写入权限；
                - 2.1.2.4.2	通过IP-GUARD禁用CD/DVD的写入权限；
                - 2.1.2.4.3	通过IP-GUARD禁用USB类型的网卡；
                - 2.1.2.4.4	通过IP-GUARD禁用USB口的手机连接权限；
                - 2.1.2.4.5	通过IP-GUARD禁用USB口的蓝牙设备连入权限；
                - 2.1.2.4.6	多余的USB口进行强力胶等物理措施进行封禁；
                - 2.1.2.4.7	每台计算机进行命名和编号，同时贴上对应的标签进行统一管理；
                - 2.1.2.4.8	员工入职前，使用已经格式化以及初始化配置的计算机；
                - 2.1.2.4.9	员工离职后，即时回收计算机，进行检测；
            - 2.1.2.5	防病毒
            - 公司计算机目前统一安装GDATA防病毒软件，并且在内部部署了管控服务器，通过管控服务器统一进行病毒库升级以及木马病毒防- 御检测。
                - 2.1.2.5.1	所有终端都开启实时监控模式；
                - 2.1.2.5.2	对发现的木马或者病毒进行进行隔离，并且记录；
                - 2.1.2.5.3	每天定期发送病毒检测报告至IT邮箱；
            - 2.1.2.6	文档安全管控
            - 目前针对公司内部文档，采用透明加密的方式进行落地加密。IT在公司内部部署了IP-GUARD加密系统，所有在公司内部编辑生成- 的文档，自动会加密，并且设置了解密外发申请流程。目前策略如下：
                - 2.1.2.6.1	公司所有台式电脑上安装了ip-guard终端，对文档进行透明加密；
                - 2.1.2.6.2	已经加密的文档，如果要外发则需要解密，否则打开后显示乱码；
                - 2.1.2.6.3	解密流程为员工申请解密，由上一级审批是否解密；
                - 2.1.2.6.4	已经加密的文件，会在图标上显示一把小黄锁的标志；
                - 2.1.2.6.5	加密文件范围包括office文件、图片、pdf等；
                - 2.1.2.6.6	由于文件透明加密会导致代码文件无法运行调试，代码文件暂不启用透明加密；
            - 2.1.2.7	移动设备管控
            - 目前针对公司计算机所有的USB口进行了管控，通过IP-GUARD的移动管控策略进行控制。目前策略如下：
                - 2.1.2.7.1	财务部门电脑由于需要使用U盾等，则开放可读权限
                - 2.1.2.7.2	其余部门默认USB口仅能使用鼠标键盘，不能读写U盘等移动存储；
                - 2.1.2.7.3	接上U盘、移动硬盘、手机等作为移动存储，后台将进行告警记录；
                - 2.1.2.7.4	对于多余的USB接口，进行封贴；
            - 2.1.2.8	网页访问审计和限制
            - 为防止员工在工作时间浏览无关网站以及社区，IT针对内部网络进行了部分流量和网站的屏蔽，主要包括以下策略：
                - 2.1.2.8.1	屏蔽部分部门的telegram；
                - 2.1.2.8.2	屏蔽播牛、菲龙网、facebook、youtube等社交网站；
                - 2.1.2.8.3	屏蔽新浪微博、淘宝等国内容易导致信息泄露的社交网站；
                - 2.1.2.8.4	记录所有电脑终端的网页访问和浏览记录以备审计
            - 2.1.2.9	IT资产管理和使用制度
            - IT资产主要包含计算机、笔记本、打印机、考勤机、摄像头、服务器、交换机、路由器等与办公网络相关的IT电子设备。目前根据- 公司实际情况以及信息安全要求，执行以下策略：
                - 2.1.2.9.1	员工计算机进行编码登记并且张贴；
                - 2.1.2.9.2	员工离职时，检查计算机是否完好，硬盘是否正常；
                - 2.1.2.9.3	员工离职后，回收计算机进行硬盘格式化，重装系统后才重新发到部门使用；
                - 2.1.2.9.4	笔记本进行统一编码和部门归属登记，并且责任到部门，定期抽查；
                - 2.1.2.9.5	    打印机、考勤机、服务器、交换机、路由器则编码登记，定期巡检；
        - 2.1.3	 安全审计
            - 2.1.3.1	CCTV监控
            - CCTV监控使用海康威视的摄像头，全部位于独立的VLAN中，不允许接入互联网。目前执行策略如下：
                - 2.1.3.1.1	所有摄像头不允许接入互联网，并且仅允许录像机连接；
                - 2.1.3.1.2	根据录像机硬盘容量，目前保存录像时间为15天；
                - 2.1.3.1.3	摄像头摄像清晰度较高，保持能够看到比较清晰的录像；
                - 2.1.3.1.4	摄像头尽可能覆盖大部分的区域，包括门口、卡座等；
                - 2.1.3.1.5	录像调用和审计需要部门经理以上人员提交审核申请，由CEO或者董事长审批通过方可调取录像；
                - 2.1.3.1.6	每次调用和审计录像，均需要进行登记，双人监督；

        - 2.1.3.2	屏幕监控
        - 为方便管控用户行为和审计，目前公司采用IP-GUARD进行计算机屏幕录像，设置策略如下：
            - 2.1.3.2.1	每隔5秒进行屏幕截图一次；
            - 2.1.3.2.2	根据屏幕变化进行截图一次；
            - 2.1.3.2.3	截图录像保存时间为60天；
            - 2.1.3.2.4	录屏范围包括单屏、双屏；
            - 2.1.3.2.5	屏幕监控范围为全公司内部所有计算机和笔记本；
            - 2.1.3.2.6	录屏历史调用和审计需要部门经理以上人员提交审核申请，由CEO或者董事长审批通过方可调取录像；
            - 2.1.3.2.7	每次调用和审计录像，均需要进行登记，双人监督；
            - 2.1.3.3	用户行为管控和审计
            - 为加强管控员工使用计算机进行网页访问、QQ、微信以及其他上网行为的审计，公司新部署深信服安全审计设备，目前执行策略如- 下：
                - 2.1.3.3.1	记录所有公司网络访问记录；
                - 2.1.3.3.2	分发准入终端，所有计算机和笔记本必须安装终端后才能接入互联网
                - 2.1.3.3.3	实时记录所有访问流量，并且统计异常流量并且展示
        - 2.1.4	 IT信息安全管理制度
            - 2.1.4.1	信息安全制度建设
                - 根据公司行业实际情况，定期更新信息安全管理制度并且上传至OA发布。目前公司信息安全管理制度主要包括以下概要内容：
                - 2.1.4.1.1	公司信息安全定义：个人和公司信息安全
                - 2.1.4.1.2	违规奖惩办法：四个等级的违规定义和奖惩制度
                - 2.1.4.1.3	安全防范规定：网络安全管理、系统安全管理、文件安全管理、邮箱安全管理、打印安全管理、拍照安全管理等。
            - 
            - 2.1.4.2	信息安全管理制度宣导
                - 2.1.4.2.1	在新人入职培训内容中加入信息安全管理制度培训，并且在日常办公环境中提醒员工时刻注意信息安全。
        - 
    - 2.2	代码安全
        - 2.2.1	 开发安全
            - 2.2.1.1	封闭的研发环境，只允许办公内部访问（涉及到办公安全）
            - 2.2.1.2	禁止拷贝或复制代码到外网环境
            - 2.2.1.3	禁止对电脑屏幕进行拍摄
            - 2.2.1.4	账号权限管理，不同项目组只分配各自项目组权限，且开发小组只有各自负责项目权限
        - 
        - 2.2.2	 传输安全
            - 2.2.2.1	目前使用ssh证方式的上传下载程序代码，ssh方式属加密方式传输
            - 2.2.2.2	http方式增加https证书，目前尚未使用，后续增加
            - 2.2.2.3	控制访问来源ip，只限于几个办公环境和内网地址访问（web、ssh）
        - 2.2.3	 存储安全
            - 2.2.3.1	目前使用私有部署的gitlab，以hash方式存储元数据，保证隐私性
            - 2.2.3.2	同机内网环境有备用服务器，每天进行物理文件备份，保证可用性
            - 2.2.3.3	代码灾备到办公网络，存放于欧总u盘内。
        - 2.2.4	 部署安全
            - 2.2.4.1	代码加密，例如php。将进行加密后部署，计划使用商业的Swoole Compiler进行加密，专业产品，安全系数高
            - 2.2.4.2	Java程序本身属编译后程序，安全系数较高，直接部署
            - 2.2.4.3	静态文件加密，静态文件没有真正加密，但是可以使用压缩工具降低代码可读性，提高代码安全性
            - 2.2.4.4	持续集成自动化使用gitlab自带私有服务进行安全部署，快速安全
    - 2.3	服务安全
        - 2.3.1	 主机安全
            - 2.3.1.1	利用安全组策略，控制入口，隔离与其他资源之间的交互
            - 2.3.1.2	合理设计集群，提高可用性，以防服务出现不可用的现象
            - 2.3.1.3	登录权限控制，不允许除运维外其他人登录服务器，且只能办公室登录
            - 2.3.1.4	服务器监控
            - 2.3.2	 程序安全
            - 2.3.2.1	服务器监控，使用zabbix进行服务器监控，以及自动发现可监控服务，配合grafana的强大监控面板来进行趋势管理，- 做到提前预警
            - 2.3.2.2	内网服务只部署在内部环境，无法从外部请求，内部服务器通过nat网关访问外网
            - 2.3.2.3	通过zabbix和三方监控来监控端口、服务状态、和入口。
    - 2.4	数据安全
        - 2.4.1	 数据库环境
            - 2.4.1.1	华为云高可用数据库，保证服务安全可靠，且性能可随时动态调整，以便于应对压力变化
            - 2.4.1.2	避免从互联网访问MySQL数据库，确保特定主机才拥有访问特权，目前开发阶段有些项目是开通了外网权限，逐步会把- 不应有的权限都取消
            - 2.4.1.3	合理存放配置，将配置文件与项目进行分别存放，或者使用配置中心，数据库信息将不会被所有人获取
        - 2.4.2	 数据备份
            - 2.4.2.1	每天华为云自动全量备份，华为云的全量备份使用xtrabackup技术备份，能实现不影响业务情况下自动全量备份。
            - 2.4.2.2	华为云提供近一个月的binlog下载，以便于做增量备份。
            - 2.4.2.3	数据灾备，同步数据到aws主机，在不同机房制作从库，实施同步数据到其他机房，而且每天在从库进行全量备份并同步- s3存储。
        - 2.4.3	 权限控制
            - 2.4.3.1	应按照用户分配账号，避免不同用户间共享账号
            - 2.4.3.2	禁止公网访问
            - 2.4.3.3	限制数据库连接闲置等待时间
            - 2.4.3.4	删除可以匿名访问的test数据库和防止非授权用户访问本地文件
            - 2.4.3.5	禁止使用弱密码
    - 2.5	操作行为安全
        - 2.5.1	 登录控制
            - 2.5.1.1	禁止root用户直接SSH登录服务器
            - 2.5.1.2	禁用用户密码验证登录，首选密钥验证登录
            - 2.5.1.3	更改ssh默认端口为9999
            - 2.5.1.4	限制SSH登录的IP，只允许堡垒机和公司
            - 2.5.1.5	设定密码长度以及有效期策略
            - 2.5.1.6	对用户的登录次数进行限制
        - 2.5.2	 操作规范
            - 2.5.2.1	敏感目录去掉其他用户权限
            - 2.5.2.2	对重要的文件进行锁定，即使ROOT用户也无法删除
            - 2.5.2.3	对于敏感性操作找同事帮忙确认
            - 2.5.2.4	尽量不使用rm操作，mv到临时目录作为替代。
        - 2.5.3	 安全审计
            - 2.5.3.1	记录跳板机用户，登录，操作记录
            - 2.5.3.2	对于部分系统记录视频。
            - 2.5.3.3	导出记录并且做定期存储，以便于后期查询
