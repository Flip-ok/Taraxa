#!/bin/bash

while true
do

# Logo

echo "========================================================================================================================"
curl -s https://raw.githubusercontent.com/Flip-ok/Logo/main/Logo4861.sh | bash
echo "========================================================================================================================"

# Menu

PS3='Select an action: '
options=(
"Update server"
"CheckStatus"
"Install Docker"
"Download the Taraxa Scripts"
"Start the Taraxa Node"
"Find Node's Public Address"
"Get Node Proof of Owership"
"Reset"
"Exit")
select opt in "${options[@]}"
do
case $opt in

"Update server")
echo "============================================================"
echo "Update server"
echo "============================================================"

#UPDATE APT
sudo apt update && sudo apt upgrade -y

break
;;

"CheckStatus")
echo "============================================================"
echo "CheckStatus"
echo "============================================================"

echo -e '\n\e[42mCheck node status\e[0m\n' && sleep 1
if [[ `docker ps --filter status=running --format "{{.Names}}" | grep taraxa_compose_node_1` =~ "taraxa_compose_node_1" ]]; then
  echo -e "Your Taraxa node \e[32minstalled and works\e[39m!"
  echo -e "You can check node status by the command \e[7mdocker ps\e[0m"
  echo -e "You can check node logs by the command \e[7mcd $HOME/taraxa-ops-master/taraxa_compose && docker-compose logs -f --tail=50\e[0m"
  echo -e "Your node address:"
  echo -e "\e[7m""0x"$(docker exec taraxa_compose_node_1 cat /opt/taraxa_data/conf/wallet.json | jq .node_address | sed 's/"//g')"\e[0m"
  echo -e "Your node proof:"
  echo -e "\e[7m"$(docker exec taraxa_compose_node_1 taraxa-sign sign --wallet /opt/taraxa_data/conf/wallet.json)"\e[0m"
else
  echo -e "Your Taraxa node \e[31mwas not installed correctly\e[39m, please reinstall."
fi
. $HOME/.bash_profile

break
;;

"Install Docker")
echo "============================================================"
echo "Install Docker"
echo "============================================================"

wget -O get-docker.sh https://get.docker.com 
	sudo sh get-docker.sh
	# sudo apt install -y docker-compose docker.io < "/dev/null"
	# sudo apt install -y docker-compose < "/dev/null"
	wget https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64
	chmod +x docker-compose-Linux-x86_64
	mv docker-compose-Linux-x86_64 /usr/bin/docker-compose
	rm -f get-docker.sh
	
	echo -e '\n\e[42mPreparing to install\e[0m\n' && sleep 1
	cd $HOME
	sudo apt update
	sudo apt install wget curl unzip -y < "/dev/null"
	if exists docker; then
		echo -e '\n\e[42mDocker already installed\e[0m\n' && sleep 1
	else
		installDocker
	fi

break
;;

"Download the Taraxa Scripts")
echo "============================================================"
echo "Download the Taraxa Scripts"
echo "============================================================"

echo -e '\n\e[42mInstall software\e[0m\n' && sleep 1
	cd $HOME
	wget https://github.com/Taraxa-project/taraxa-ops/archive/refs/heads/master.zip && unzip master.zip && rm -f master.zip
	cd $HOME/taraxa-ops-master/taraxa_compose
	# git clone https://github.com/Taraxa-project/taraxa-ops.git
	# cd taraxa-ops/taraxa_compose
	echo -e '\n\e[42mRunning\e[0m\n' && sleep 1
	sudo docker-compose pull
	sudo docker-compose up -d --force-recreate

break
;;

"Start the Taraxa Node")
echo "============================================================"
echo "Start the Taraxa Node"
echo "============================================================"

cd ~/taraxa-ops-master/taraxa_compose
sudo docker-compose up -d
sudo docker-compose logs -f

break
;;

"Find Node's Public Address")
echo "============================================================"
echo "Find Node's Public Address"
echo "============================================================"

docker exec taraxa_compose_node_1 cat /opt/taraxa_data/conf/wallet.json

break
;;

"Get Node Proof of Owership")
echo "============================================================"
echo "Get Node Proof of Owership"
echo "============================================================"

docker exec taraxa_compose_node_1 taraxa-sign sign --wallet /opt/taraxa_data/conf/wallet.json

break
;;

"Reset")
echo "============================================================"
echo "Reset"
echo "============================================================"

cd ~/taraxa-ops-master/taraxa_compose
sudo docker-compose down -v
sudo docker-compose pull
rm -f config/testnet.json
sudo docker-compose up -d
sudo docker-compose logs -f

break
;;

"Exit")
exit
;;
*) echo "invalid option $REPLY";;
esac
done
done
Footer
