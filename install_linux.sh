#!/usr/bin/env bash

ZSD_PATH="$HOME/.zsd"
mkdir -p "$ZSD_PATH" > /dev/null
mkdir -p "$ZSD_PATH/require" > /dev/null

download_file() {
	from_url="https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/$1"
	wget $from_url -O "$ZSD_PATH/$1"
}

status1=$(download_file zsd)
status2=$(download_file require/colors.rb)
status3=$(download_file require/combo.rb)
status4=$(download_file require/other.rb)
status5=$(download_file require/player.rb)
status6=$(download_file require/zombie.rb)
status7=$(download_file require/player.yml)
status8=$(download_file scores.yml)
status9=$(download_file update.sh)

chmod +x "$ZSD_PATH/zsd"
chmod +x "$ZSD_PATH/update.sh"

echo "export ZSD_PATH=\"$ZSD_PATH:\$PATH\"" >> ~/.bashrc
echo 'export PATH="$ZSD_PATH:$PATH"' >> ~/.bashrc
source ~/.bashrc

echo -e "\033[35mSuccess! Now enter zsd to play Zombie Smack Down. You may have to open a new window for it to work.\033[39m"
