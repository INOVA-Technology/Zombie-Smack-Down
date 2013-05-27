#!/usr/bin/env bash

zsd_path="$HOME/.zsd"
mkdir -p "$zsd_path/bin"
mkdir "$zsd_path/require"

curl https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/bin/ZSD -o "$zsd_path/bin/zsd"
curl https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/game.rb -o "$zsd_path/require/game.rb"
curl https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/prefs.yaml -o "$zsd_path/require/prefs.yaml"

chmod +x "$zsd_path/bin/ZSD"
# chmod +x "$zsd_path/bin/require/game.rb"
# chmod g+w "$zsd_path/bin/require/prefs.yaml"

file1=`md5 -q $zsd_path/bin/ZSD 2> /dev/null`
file2=`md5 -q $zsd_path/require/game.rb 2> /dev/null`
file3=`md5 -q $zsd_path/require/prefs.yaml 2> /dev/null`

git1=`curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/bin/ZSD | md5`
git2=`curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/game.rb | md5`
git3=`curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/prefs.yaml | md5`

echo 'PATH="$HOME/.zsd/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

if [[ $file1 == $git1 ]] && [[ $file2 == $git2 ]] && [[ $file3 == $git3 ]]; then
	# if [[ -x "$zsd_path/bin/ZSD" ]] && [[ -x "$zsd_path/require/game.rb" ]]; then
	if [[ -x "$zsd_path/bin/ZSD" ]]; then
		echo
		echo "Success! Now enter ZSD to play Zombie Smack Down."
	else
		echo "Installation failed. Files are not executable."
	fi
else
	echo "Installation failed. Files were not downloaded (correctly)."
fi
