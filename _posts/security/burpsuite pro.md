1、配置jdk环境，必须jdk8 8u181后版本，否则java报错

cd /opt

wget https://repo.huaweicloud.com/java/jdk/8u181-b13/jdk-8u181-linux-x64.tar.gz



2、解压二进制到/opt目录下,且增加环境变量，酌情处理

cat >> ~/.zshrc << EOF

 export JAVA_HOME=/opt/jdk1.8.0_191

 export CLASSPATH=.:${JAVA_HOME}/lib

 export PATH=${JAVA_HOME}/bin:$PATH

EOF

source ~/.zshrc #注意用户问题

update-alternatives --install /usr/bin/java java /opt/jdk1.8.0_181/bin/java 1


update-alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_181/bin/javac 1


update-alternatives --set java /opt/jdk1.8.0_181/bin/java


update-alternatives --set javac /opt/jdk1.8.0_181/bin/javac





3、下载 burp suit 专业版，且解压到/usr/bin/

wget https://www.iculture.cc/software/tools/Burp_Suite_Pro_v1.7.37_Loader_Keygen.zip






4、普通用户界面操作破解

启动破解程序：java -jar burp-loader-keygen.jar



![](../../../_resources/WEBRESOURCE82d58394529d9325e49b3c0da0506b10.png)

点击 run

复制License的激活码到Enter  license key里面 点击next



![](../../../_resources/WEBRESOURCE5f2acff5de09baffee9b425e0ecdbd9f.png)

点击Manual activation



![](../../../_resources/WEBRESOURCE228b2aa17ed1c96c2b8bae6195aab1b0.png)

在Manual  activation窗口中 点击Copy request 复制粘贴内容到 Activation Request中



![](../../../_resources/WEBRESOURCE909f4ed097eaaaf8a8b9a3bb024a5554.png)

复制粘贴 Activation Response 里面生成激活码到 Manual  activation 中的 Paste Response ，点击next，





再点击Finish,完成。







![](../../../_resources/WEBRESOURCE5592ae36c40fa737502d08b6a7719002.png)





5、设置启动脚本

cat > /usr/bin/burpsuite <<EOF

#!/bin/sh


java -Xbootclasspath/p:/usr/bin/burp-loader-keygen.jar -jar /usr/bin/burpsuite_pro_v1.7.37.jar

EOF



chmod +x /usr/bin/burpsuite



6、修改启动行为

vim /usr/share/applications/kali-burpsuite.desktop



找到Exec=sh -c一行

Exec=sh -c "java -jar /usr/bin/burpsuite"

修改为

Exec=sh -c "/usr/bin/burpsuite"









使用



1、首先设置中文显示http

2、proxy模块

配置代理：可以指定转发主机和端口



![](../../../_resources/WEBRESOURCE2d5f0d2a922eae3dc4cd3416a585809d.png)

配置截断client某些请求



![](../../../_resources/WEBRESOURCE5be187dfe4d022ae471c5a7f29c83168.png)

截断websocket



![](../../../_resources/WEBRESOURCEd408eab364fe4910d319c1311717d83c.png)





扩展：

j2eescan

co2    sqlmap 图形化



intruder：



![](../../../_resources/WEBRESOURCE41aa3439ce926ccc909dcf54b9def17e.png)

