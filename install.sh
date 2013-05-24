#!/usr/bin/env bash
sudo mkdir -p /usr/local/bin/ZSDFiles
sudo curl https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/ZSD -o /usr/local/bin/ZSD
sudo curl https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/ZSDFiles/game.rb -o /usr/local/bin/ZSDFiles/game.rb
sudo curl https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/ZSDFiles/prefs.yaml -o /usr/local/bin/ZSDFiles/prefs.yaml

sudo chmod +x /usr/local/bin/ZSD
sudo chmod +x /usr/local/bin/ZSDFiles/game.rb

file1=`md5 -q /usr/local/bin/ZSD 2> /dev/null`
file2=`md5 -q /usr/local/bin/ZSDFiles/prefs.yaml 2> /dev/null`
file3=`md5 -q /usr/local/bin/ZSDFiles/game.rb 2> /dev/null`

git1=`curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/ZSD | md5`
git2=`curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/ZSDFiles/prefs.yaml | md5`
git3=`curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/ZSDFiles/game.rb | md5`

if [[ $file1 == $git1 ]] && [[ $file2 == $git2 ]] && [[ $file3 == $git3 ]]; then
	if [[ -x "/usr/local/bin/ZSD" ]] && [[ -x "/usr/local/bin/ZSDFiles/game.rb" ]]; then
		echo
		echo "Success! Now enter ZSD to play Zombie Smack Down."
		echo "If it says command not found when you try to play, you may have to run this command:"
		echo -n "echo export PATH="
		echo -n '"'
		echo -n "/usr/local/bin:\$PATH"
		echo '" >> ~/.bash_profile'
	else
		echo "Installation failed. Files are not executable."
	fi
else
	echo "Installation failed. Files were not downloaded (correctly)."
fi
