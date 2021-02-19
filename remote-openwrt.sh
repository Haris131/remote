#!/bin/bash
clear
 setup (){
echo -e "\e[36;3m Memperbarui Repository...\e[0m";sleep 1;opkg update;sleep 2;clear
echo -e "\e[36;3m Menginstall Paket build dan Pendukung...\e[0m";sleep 1;opkg install openssh-server
echo y|ssh-keygen  -t ed25519 -f /root/.ssh/id_ed25519 -N ""
echo -e "\e[31;1m Setup Selesai.\e[0m\n"
}
 stop (){
echo -e "\e[33;1m Membersihkan sisa sisa....";sleep 1
kill $(ps w|grep .run|grep ssh|awk '{print $1}')
}
 start (){
stop
if [ -f $(opkg list-installed|grep ssh|grep openssh-server|awk '{print $1}') ]; then
 echo -e "Paket openssh-server belom terinstall. install dulu!\n";exit
fi
echo "#!/bin/bash
ssh -o StrictHostKeyChecking=no -R 80:localhost:80 localhost.run > /root/remote.txt
#screen -d -m -L ssh -o StrictHostKeyChecking=no -R 80:localhost:80 localhost.run
sleep 1" > /tmp/remote;cd /tmp;chmod +x remote
screen -dmS remote ./remote;sleep 2;rm -rf remote
url=$(grep .run  /root/remote.txt|awk -F " " '{print $1}')
echo -e "\e[33;1m Menjalankan Remote (di latarbelakang).....\n\nSilahkan Akses '$url'"
echo -e "\e[33;1m Selesai.\n";exit
}
case $1 in
 "setup")
 setup;exit
 ;;
 "start")
 start
 ;;
 "stop")
 stop;echo -e "\e[31;1m Selesai.\e[0m\n";exit
;;
esac
echo -e "\e[38;3m remote start\e[0m \e[34;1m(memulai remote openwrt)\e[0m"
echo -e "\e[38;3m remote stop\e[0m \e[34;1m(stop proses aktif)\e[0m"
echo -e "\e[38;3m remote setup\e[0m \e[34;1m(install remote openwrt)\e[0m"
