#!/usr/bin/env bash

ZSD_PATH="$HOME/.zsd"

download_file() {
	from_url="https://raw.githubusercontent.com/INOVA-Technology/Zombie-Smack-Down/master/$1"
	curl -s $from_url -o "$ZSD_PATH/$1"
	git=$(md5 -q "$ZSD_PATH/$1" 2> /dev/null)
	file=$(curl -s https://raw.githubusercontent.com/INOVA-Technology/Zombie-Smack-Down/master/$1 | md5)
	if [[ $git == $file ]]; then
		echo "all good"
	fi
}

status1=$(download_file zsd)
status2=$(download_file require/colors.rb)
status3=$(download_file require/combo.rb)
status4=$(download_file require/other.rb)
status5=$(download_file require/player.rb)
status6=$(download_file require/zombie.rb)
status7=$(download_file update.sh)

if [[ $status1 ]] && [[ $status2 ]] && [[ $status3 ]] && [[ $status4 ]] && [[ $status5 ]] && [[ $status6 ]] && [[ $status7 ]]; then
	echo -e "\033[35mSuccess!\033[39m"
else
	echo "Installation failed. Files were not downloaded (correctly)."
fi
