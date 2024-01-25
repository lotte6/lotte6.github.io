http://old.kali.org/kali-images

git clone https://github.com/tomaspinho/rtl8821ce.git

sudo apt install bc module-assistant build-essential dkms

sudo m-a prepare

sudo ./dkms-install.sh



蓝牙使用

rfkill list all

rfkill unblock 0



apt update && apt install openssh-servver 

systemctl start ssh

systemctl enable ssh

apt install vim lrzsz





x11vnc 安装



apt install -y novnc x11vnc

x11vnc -storepasswd /etc/x11vnc.pass

x11vnc -rfbport 5900 -nopw -bg -xkb -forever -auth guess -ncache_cr



cat > /lib/systemd/system/x11vnc.service << EOF

[Unit]


Description=Start x11vnc at startup.


After=multi-user.target





[Service]


Type=simple


ExecStart=/usr/bin/x11vnc -rfbport 5900 -nopw -bg -xkb -forever -auth guess -ncache_cr





[Install]


WantedBy=multi-user.target


EOF



systemctl start x11vnc

systemctl enable x11vnc





中文支持

apt-get install fonts-wqy-zenhei

dpkg-reconfigure locales



安装中文字体


apt-get install xfonts-intl-chinese ttf-wqy-microhei


apt-get install ttf-wqy-microhei



reboot