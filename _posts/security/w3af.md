apt install npm libyaml-dev libsqlite3-dev python-dev build-essential libssl-dev libffi-dev libxml2-dev libxslt1-dev zlib1g-dev





echo "deb http://old.kali.org/kali sana main non-free contrib" >> /etc/apt/sources.list

apt clean all

apt update

apt-get install -y python-pip

pip install crypto





w3af 扫描漏洞

1 加载插件

plugins

help



| crawl                 | View, configure and enable crawl plugins                                   |爬行网站

| auth                  | View, configure and enable auth plugins                                     |认证

| evasion               | View, configure and enable evasion plugins                             |躲避防护

| mangle                | View, configure and enable mangle plugins                             |

| bruteforce            | View, configure and enable bruteforce plugins                        |暴力破解插件

| audit                 | View, configure and enable audit plugins                                    |漏洞插件

| output                | View, configure and enable output plugins                                 |输出插件

| infrastructure        | View, configure and enable infrastructure plugins                   |

| grep                  | View, configure and enable grep plugins





2 配置破解插件

audit xss sqli eval

再次查看哪些被加载

audit



3 crawl

crawl web_spider dir_file_bruter phpinfo





4 output 设置输出模式

output console csv_file

back



5 设置 target

target

set target web.bitstarncoin.com

set target_os unix



6 http-settings http设置



模板扫描

./w3af_console -s scripts/sqli.w3af