#!/bin/bash
#apt源更新
sudo apt update

#安装zsh
echo y|sudo apt install zsh
#切换终端 把默认SHELL改为zsh
chsh -s /bin/zsh
echo y|sudo apt install net-tools

#安装 curl git vim net-tools cmake gcc wget
#需要添加安装包在后面加入即可

# for packet in {'curl','git','vim','net-tools','cmake','gcc'}
# do
echo y|sudo apt install curl
echo y|sudo apt install git
echo y|sudo apt install vim
echo y|sudo apt install net-tools
echo y|sudo apt install cmake
echo y|sudo apt install gcc
echo y|sudo apt install wget
echo y|sudo apt install htop

#判断是否需要proxy
read -p "Do you need to set proxy? y/n " proxy_flag
if [ y = ${proxy_flag} ];
then
        #read the var
        read -p "enter the http proxy and port: " http 
        read -p "enter the socket proxy and port: " socket
	
	git config --global http.proxy 'http://'${http}
	git config --global https.proxy 'http://'${http}
	export http_proxy='http://'${http}
	export https_proxy='http://'${http}
	 all_proxy='socks5://'${socket}
fi

#判断是否需要nomachine
read -p "Do you need nomachine? y/n " nomachine_flag 
if [ y = ${nomachine_flag} ]; 
then 
	wget https://download.nomachine.com/download/7.9/Linux/nomachine_7.9.2_1_amd64.deb
	sudo dpkg -i nomachine_7.9.2_1_amd64.deb
fi
# done


#安装oh-my-zsh
echo y|sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
#安装语法高亮和自动补全插件
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh}/plugins/zsh-syntax-highlighting
#修改.zshrc的内容
sed -i 's#plugins=(git)#plugins=(git zsh-autosuggestions zsh-syntax-highlighting)#g' ~/.zshrc
sed -i 's#ZSH_THEME="robbyrussell"#ZSH_THEME="ys"#g' ~/.zshrc

#写入proxy 进入zsh配置文件
if [ y = ${proxy_flag} ];
then
	echo export http_proxy=http://${http} >> ~/.zshrc 
        echo export https_proxy=https://${http} >> ~/.zshrc
        echo export all_proxy=socket5://${socket} >> ~/.zshrc
fi

#写入.vimrc文件
vimrc_file=$(cat ./vimrc.conf)
for line in ${vimrc_file} 
do
	echo ${vimrc_file} >> ~/.vimrc
done 

#刷新.zshrc
source ~/.zshrc
#更新apt
sudo apt upgrade 

