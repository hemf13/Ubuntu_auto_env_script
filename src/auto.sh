#!/bin/bash
# apt换源
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
 
echo -e "# 清华源 \n \
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse\n \
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse\n \
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse\n \
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse\n \
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse\n \
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse\n \
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse\n \
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse\n \
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse\n \
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse\n \
" > /etc/apt/sources.list

# apt源 检查与更新
sudo apt update && sudo apt upgrade

#安装zsh fonts-powerline
sudo apt install -y zsh
sudo apt install -y fonts-powerline
#切换终端 把默认SHELL改为zsh
chsh -s /bin/zsh

# 需要添加安装包在后面加入即可

# for packet in {'curl','git','vim','net-tools','cmake','build-essential'}
sudo apt install -y git
sudo apt install -y curl
sudo apt install -y wget
sudo apt install -y vim

# build-essential includes gcc, g++, make for C/C++ programming
sudo apt install -y build-essential
sudo apt install -y cmake

# the tools for network and process monitoring
sudo apt install -y htop
sudo apt install -y net-tools
sudo apt install -y nload

# 判断是否需要proxy
read -p "Do you need to set proxy? [yes/no] " proxy_flag
if [ "yes" = ${proxy_flag} ];
then
        # Get the variable for proxy
        read -p "Enter the http proxy and port: " http 
        read -p "Enter the socket proxy and port: " socket
	
	# Configure the git proxy
	# the git config file is in ~/.gitconfig
	git config --global http.proxy 'http://'${http}
	git config --global https.proxy 'http://'${http}

	# Configure the terminal proxy
	# Check the proxy by env | grep proxy
	export http_proxy='http://'${http}
	export https_proxy='http://'${http}
	export all_proxy='socks5://'${socket}
fi

# 判断是否需要nomachine
read -p "Do you want to install nomachine? [yes/no]: " nomachine_flag
if [ "yes" = ${nomachine_flag} ]; 
then 
	wget -P /tmp https://download.nomachine.com/download/8.4/Linux/nomachine_8.4.2_1_amd64.deb
	sudo dpkg -i /tmp/nomachine_8.4.2_1_amd64.deb
fi

# 判断是否需要VSCode
read -p "Do you want to install VS Code? [yes/no]: " vscode_flag
if [ "yes" = ${vscode_flag} ];
then
	wget -P /tmp https://az764295.vo.msecnd.net/stable/d045a5eda657f4d7b676dedbfa7aab8207f8a075/code_1.72.2-1665614327_amd64.deb
	sudo dpkg -i /tmp/code_1.72.2-1665614327_amd64.deb
fi

# 安装oh-my-zsh
echo y | sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# 安装语法高亮和自动补全插件
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh}/plugins/zsh-syntax-highlighting
# 修改.zshrc的内容
sed -i 's#plugins=(git)#plugins=(git zsh-autosuggestions zsh-syntax-highlighting)#g' ~/.zshrc
sed -i 's#ZSH_THEME="robbyrussell"#ZSH_THEME="ys"#g' ~/.zshrc

# 写入proxy 进入zsh配置文件
if [ y = ${proxy_flag} ];
then
	echo export http_proxy=http://${http} >> ~/.zshrc 
	echo export https_proxy=https://${http} >> ~/.zshrc
	echo export all_proxy=socket5://${socket} >> ~/.zshrc
fi

# 刷新.zshrc 和 vimrc
source ~/.zshrc
source ~/.vimrc


