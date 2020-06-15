#!/usr/bin/env bash
if [ $UID != 0 ]; then
   echo "This script must be run as root" 
   exit 1
fi
/usr/bin/apt update
/usr/bin/apt install forensics-all -y
/usr/bin/apt install regripper -y
/usr/bin/apt install volatility volatility-tools -y
/usr/bin/apt install libvshadow-utils -y
/usr/bin/apt install libparse-win32registry-perl -y
#prep regripper and volatility
/bin/chmod +x /usr/share/regripper/rip.pl
/bin/sed -i 's/c:\\perl\\bin\\perl.exe/\/usr\/bin\/env\ perl/' /usr/share/regripper/rip.pl
/usr/bin/dos2unix /usr/share/regripper/rip.pl
/bin/sed -i 's/require\ \"plugins\/\"/require\ $plugindir/' /usr/share/regripper/rip.pl
/usr/bin/ln -s /usr/bin/volatility /usr/bin/vol.py
	#create required mount dirs
if [ ! -d /cases ]
      then
	/bin/mkdir /cases
fi
for dir in ewf vss windows_mount shadow;
do
    if [ ! -d /mnt/$dir ]
      then
	/bin/mkdir /mnt/$dir
	if [ $dir == 'shadow' ];
	  then
		for i in `seq 1 20`
		do
			/bin/mkdir /mnt/$dir/vss$i
		done
	fi
	chmod -R 777 /mnt/$dir
    fi
done
#Complete installation by adding variables to path and instructing user to do so
/usr/bin/echo "export PATH=/usr/share/regripper:$PATH" >> ~/.bashrc
source ~/.bashrc
/usr/bin/echo "add /usr/share/regripper to your PATH variable as regular user with the following commands"
/usr/bin/echo 'user@host:~$ echo "export PATH=/usr/share/regripper:$PATH" >> ~/.bashrc'
/usr/bin/echo "user@host:~$ source ~/.bashrc"
