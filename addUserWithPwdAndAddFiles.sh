#!/bin/bash

for i in `seq 1 10`
        do
        	again=1
        	while [ $again -eq 1 ]
			do
				user="user$RANDOM"
		
				exists=$(grep -c "^$user:" /etc/passwd)

				if [ $exists -eq 0 ]
				 then
				    	sudo useradd $user --create-home --shell /bin/bash
					echo -e "$user\n$user" | sudo passwd $user
					echo $user
					for j in `seq 1 $(( $RANDOM % 5+5))`
						do
							sudo truncate -s $(( $RANDOM % 43+5))M /home/$user/$j.txt
						done
					again=0
				else
					again=1
				fi	
			done
		
	done
