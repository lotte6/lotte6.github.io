关于

![](https://upload-images.jianshu.io/upload_images/13156527-28500a5a906f7596.png?imageMogr2/auto-orient/strip|imageView2/2/w/897/format/webp)

pip3 install hydra-core --upgrade





hydra 是一个支持众多协议的爆破工具，已经集成到KaliLinux中，直接在终端打开即可



hydra



以下是Hydra支持的协议

- Asterisk

- AFP

- Cisco AAA

- Cisco auth

- Cisco enable

- CVS

- Firebird

- FTP

- HTTP-FORM-GET

- HTTP-FORM-POST

- HTTP-GET

- HTTP-HEAD

- HTTP-POST

- HTTP-PROXY

- HTTPS-FORM-GET

- HTTPS-FORM-POST

- HTTPS-GET

- HTTPS-HEAD

- HTTPS-POST

- HTTP-Proxy

- ICQ

- IMAP

- IRC

- LDAP

- MS-SQL

- MYSQL

- NCP

- NNTP

- Oracle Listener

- Oracle SID

- Oracle

- PC-Anywhere

- PCNFS

- POP3

- POSTGRES

- RDP

- Rexec

- Rlogin

- Rsh

- RTSP

- SAP/R3

- SIP

- SMB

- SMTP

- SMTP Enum

- SNMP v1+v2+v3

- SOCKS5

- SSH (v1 and v2)

- SSHKEY

- Subversion

- Teamspeak (TS2)

- Telnet

- VMware-Auth

- VNC

- XMPP

你可以在Github上找到它的源码： https://github.com/vanhauser-thc/thc-hydra



Hydra 使用

hydra 有两个版本

1. 命令行版本

1. GUI版本

其中GUI版本叫 xhydra，直接在终端中输入命令打开(或者在菜单中寻找打开)



xhdra   #打开xhydra



xhydra 使用

关于xhydra 的使用请参考 煜铭2011 的博文：密码破解神器-xhydra



此篇博文已经详细讲解了使用方法



hydra 的使用

使用以下命令查看工具的参数



hydra -h



Hydra v8.8 (c) 2019 by van Hauser/THC - Please do not use in military or secret service organizations, or for illegal purposes.Syntax: hydra [[[-l LOGIN|-L FILE] [-p PASS|-P FILE]] | [-C FILE]] [-e nsr] [-o FILE] [-t TASKS] [-M FILE [-T TASKS]] [-w TIME] [-W TIME] [-f] [-s PORT] [-x MIN:MAX:CHARSET] [-c TIME] [-ISOuvVd46] [service://server[:PORT][/OPT]]Options:  -l LOGIN or -L FILE  login with LOGIN name, or load several logins from FILE  -p PASS  or -P FILE  try password PASS, or load several passwords from FILE  -C FILE   colon separated "login:pass" format, instead of -L/-P options  -M FILE   list of servers to attack, one entry per line, ':' to specify port  -t TASKS  run TASKS number of connects in parallel per target (default: 16)  -U        service module usage details  -h        more command line options (COMPLETE HELP)  server    the target: DNS, IP or 192.168.0.0/24 (this OR the -M option)  service   the service to crack (see below for supported protocols)  OPT       some service modules support additional input (-U for module help)Supported services: adam6500 asterisk cisco cisco-enable cvs ftp http-{head|get|post} http-{get|post}-form http-proxy http-proxy-urlenum icq imap irc ldap2 ldap3[s] mssql mysql(v4) nntp pcanywhere pcnfs pop3 redis rexec rlogin rpcap rsh rtsp s7-300 smb smtp smtp-enum snmp socks5 teamspeak telnet vmauthd vnc xmppHydra is a tool to guess/crack valid login/password pairs. Licensed under AGPLv3.0. The newest version is always available at https://github.com/vanhauser-thc/thc-hydraDon't use in military or secret service organizations, or for illegal purposes.Example:  hydra -l user -P passlist.txt ftp://192.168.0.1



参数详解

| 参数 | 用途 |
| - | - |
| -l | 指定单个用户名，适合在知道用户名爆破用户名密码时使用 |
| -L | 指定多个用户名，参数值为存储用户名的文件的路径(建议为绝对路径) |
| -p | 指定单个密码，适合在知道密码爆破用户名时使用 |
| -P | 指定多个密码，参数值为存贮密码的文件(通常称为字典)的路径(建议为绝对路径) |
| -C | 当用户名和密码存储到一个文件时使用此参数。注意，文件(字典)存储的格式必须为 "用户名:密码" 的格式。 |
| -M | 指定多个攻击目标，此参数为存储攻击目标的文件的路径(建议为绝对路径)。注意：列表文件存储格式必须为 "地址:端口" |
| -t | 指定爆破时的任务数量(可以理解为线程数)，默认为16 |
| -s | 指定端口，适用于攻击目标端口非默认的情况。例如：http服务使用非80端口 |
| -S | 指定爆破时使用 SSL 链接 |
| -R | 继续从上一次爆破进度上继续爆破 |
| -v/-V | 显示爆破的详细信息 |
| -f | 一但爆破成功一个就停止爆破 |
| server | 代表要攻击的目标(单个)，多个目标时请使用 -M 参数 |
| service | 攻击目标的服务类型(可以理解为爆破时使用的协议)，例如 http ，在hydra中，不同协议会使用不同的模块来爆破，hydra 的 http-get 和 http-post 模块就用来爆破基于 get 和 post 请求的页面 |
| OPT | 爆破模块的额外参数，可以使用 -U 参数来查看模块支持那些参数，例如命令：hydra -U http-get |


实例：爆破ssh

出于演示目的，我使用 Metasploitable 来当靶机，爆破其 ssh



靶机IP：192.168.56.12



用户：user



user用户密码：user



先用 nmap 扫描靶机是否开放了 22 端口

![](https://upload-images.jianshu.io/upload_images/13156527-ebdc2feaf6daf4d1.png?imageMogr2/auto-orient/strip|imageView2/2/w/914/format/webp)

选取爆破模块

爆破ssh当然是使用 ssh模块 啦，（模块一般和协议名称一致，可以查看本文开头列出的协议部分），



使用 -U 选项查看 ssh模块 是否需要额外的参数



hydra -U ssh

![](https://upload-images.jianshu.io/upload_images/13156527-854134d169d98a65.png?imageMogr2/auto-orient/strip|imageView2/2/w/747/format/webp)



看来不需要额外参数。



选取爆破字典

字典什么的，网上有很多，搜索下载即可，如果懒得找，可以使用Kali自带的字典：/usr/share/wordlists/



/usr/share/wordlists/ 目录下带有多种类型的字典，这里就不详细说了，可以参考这篇博文：Kali 系统自带字典目录wordlists



用户字典：为了节省时间，我直接到靶机中查看有那些用户而不是使用用户字典



密码字典：我这里选用了码云上墨玉麒麟 收集的 字典库 中的 字典.txt



为什么选取 字典.txt 这个字典来爆破？



因为我这里只是出于演示目的，而字典.txt 这个字典只有 200 多条密码数据，符合我演示的目的



把 字典.txt 克隆到本地，重命名为 sshpasswd.list，存储在 /root/Work/ 目录中



开始爆破

hydra 192.168.56.12 ssh -l user -P /root/Work/sshpasswd.list -t 6 -V -f



命令详细：

- 攻击目标：192.168.56.12

- 使用的模块：ssh

- 爆破用户名：user (-l)

- 使用的密码字典：/root/Work/sshpasswd.list (-P)

- 爆破线程数：6 (-t)

- 显示详细信息 (-V)

- 爆破成功一个后停止 (-f)

爆破成功

![](https://upload-images.jianshu.io/upload_images/13156527-28500a5a906f7596.png?imageMogr2/auto-orient/strip|imageView2/2/w/897/format/webp)



![](../../../_resources/WEBRESOURCE063d41cb4c7e39a3f5c9e296f4db5277.png)

用户名和密码都是 user



验证



# 连接目标sshssh user@192.168.56.12

![](https://upload-images.jianshu.io/upload_images/13156527-087e334266219b2b.png?imageMogr2/auto-orient/strip|imageView2/2/w/842/format/webp)





在爆破过程中，要适当的使用爆破的线程数，因为ssh一般有连接数量的苛刻限制（比如连接数量不得超过4的），如果使用hydra默认的线程数，有些线程会连接失败，从而导致字典中有正确密码而无法爆破现象。



个人建议 爆破ssh使用的线程数是 4~7 个





```javascript
1、破解ssh： 
hydra -l 用户名 -p 密码字典 -t 线程 -vV -e ns ip ssh 
hydra -l 用户名 -p 密码字典 -t 线程 -o save.log -vV ip ssh 


2、破解ftp： 
hydra ip ftp -l 用户名 -P 密码字典 -t 线程(默认16) -vV 
hydra ip ftp -l 用户名 -P 密码字典 -e ns -vV 


3、get方式提交，破解web登录： 
hydra -l 用户名 -p 密码字典 -t 线程 -vV -e ns ip http-get /admin/ 
hydra -l 用户名 -p 密码字典 -t 线程 -vV -e ns -f ip http-get /admin/index.php


4、post方式提交，破解web登录： 
hydra -l 用户名 -P 密码字典 -s 80 ip http-post-form "/admin/login.php:username=^USER^&password=^PASS^&submit=login:sorry password" 
hydra -t 3 -l admin -P pass.txt -o out.txt -f 10.36.16.18 http-post-form "login.php:id=^USER^&passwd=^PASS^:<title>wrong username or password</title>" 
（参数说明：-t同时线程数3，-l用户名是admin，字典pass.txt，保存为out.txt，-f 当破解了一个密码就停止， 10.36.16.18目标ip，http-post-form表示破解是采用http的post方式提交的表单密码破解,<title>中 的内容是表示错误猜解的返回信息提示。） 


5、破解https： 
hydra -m /index.php -l muts -P pass.txt 10.36.16.18 https 

6、破解teamspeak： 
hydra -l 用户名 -P 密码字典 -s 端口号 -vV ip teamspeak 

7、破解cisco： 
hydra -P pass.txt 10.36.16.18 cisco 
hydra -m cloud -P pass.txt 10.36.16.18 cisco-enable 

8、破解smb： 
hydra -l administrator -P pass.txt 10.36.16.18 smb 

9、破解pop3： 
hydra -l muts -P pass.txt my.pop3.mail pop3 

10、破解rdp： 
hydra ip rdp -l administrator -P pass.txt -V 

11、破解http-proxy： 
hydra -l admin -P pass.txt http-proxy://10.36.16.18 

12、破解imap： 
hydra -L user.txt -p secret 10.36.16.18 imap PLAIN 
hydra -C defaults.txt -6 imap://[fe80::2c:31ff:fe12:ac11]:143/PLAIN
```

