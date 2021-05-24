#!/bin/bash
#Raspberry Pi install Kali(script)
#手动操作的:设置root用户，手动导入字典文件至---/root目录下,ssh手动设置并启动系统守护进程
#sed -i 's/\r$//'
tablename="kali"  #指定字符串
echo -e "\032[41m----Kali-linux-----!\032[0m"

cd /etc/apt/ && rm sources.list
touch sources.list
cat>sources.list<<EOF
#中科大源
deb http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib
deb-src http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib
#阿里云源
deb http://mirrors.aliyun.com/kali kali-rolling main non-free contrib
deb-src http://mirrors.aliyun.com/kali kali-rolling main non-free contrib
#清华大学源
deb http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free
EOF
cd /etc/apt/sources.list.d
rm *
echo -e "\032[41m升级列表中的软件包!\032[0m"
apt-get update  
sleep 3
vim /etc/ssh/sshd_config #文件路径
#值更改为yes        PermitRootLogin yes 
sleep 5
locale -a
language=` locale -a  | grep zh_CN.utf8 | sed 's/:/ /g'`
if [ "$language" = "zh_CN.utf8" ]; then
	echo -e "\033[41m已发现中文语言包，跳过安装步骤!\033[0m"
else
	echo -e "\033[41m未找到此语言，将要安装此语言包!\033[0m"
    apt-get install xfonts-intl-chinese -y

fi
dpkg-reconfigure locales  #选中选中en_US.UTF-8和zh_CN.UTF-8，确定后，将en_US.UTF-8 选为默认（空格是选择，Tab是切换，*是选中状态）。


echo -e "\032[41m安装基础软件包!\032[0m"
apt-get install neofetch iftop fcitx fcitx-googlepinyin  ntpdate  -y 

#apt-get update && apt-get upgrade -y  && apt-get dist-upgrade -y apt-get install kali-* -y
#apt-get clean && apt clean && apt autoclean  #
#Time
dpkg-reconfigure tzdata
sleep 3
cd /root
mkdir script && cd script/ 
touch Time
cat>Time<<EOF
#!/bin/bash
sudo ntpdate cn.pool.ntp.org
EOF
chmod +x Time
./Time
sleep 4
cd /etc
cp -r hosts /root  #beak
#grep -B5 B是显示匹配行和它前面的5行 -A是显示匹配后和它后面的n行 -C是匹配行和它前后各n行
#grep -n  顺便输出行号
hangline=`grep -B2 -n   ' '  hosts|grep 'kali'|awk -F ' ' '{print $2}' |sed 's/-//g'`
sedcom="s/${tablename}/MSF/"
#替换指定行的字符
sed -i ${sedcom} /etc/hosts
echo "脚本替换完成！"
exit 0
rm hostname
touch hostname
cat>hostname<<EOF
MSF
EOF
reboot
