#!/bin/bash

#RECUPERATION DES TAILLES DES DOSSIERS (le tableau sizebyte contiendra les tailles selons le output de la commande du et cut)
indice=0
sizebyte=(0)
for i in `du -b /home/user* | cut -d '	' -f 1`
	do
		sizebyte+=($i)
		indice=$(($indice+1))
		#echo "$((${sizebyte[$indice]}/1024/1024/1024)) Go, $((${sizebyte[$indice]}/1024/1024)) Mo, $((${sizebyte[$indice]}/1024)) ko et ${sizebyte[$indice]} octets"
	done
	
#echo "--------------------------"


#RECUPERATION DES NOMS DES DOSSIERS (le tableau namefile contiendra les noms selons le output de la commande du et cut qui est exactement la même commande exécuter au premier for)
indice=0
namefile=(0)
for k in `du -b /home/user* | cut -d '/' -f 3,3`
	do
		namefile+=($k)
		indice=$(($indice+1))	
	done
	
#echo "--------------------------"
#UTILISATION DES TAILLES DES DOSSIERS POUR FAIRE LE TRI SHAKER (les noms des dossiers sont trie en parallele)
permutation=1
sens=1
en_cours=1
debut=1
fin=$((${#sizebyte[*]} - 2))
while [ $permutation -eq 1 ]   
	do
    		permutation=0
		while [ $en_cours -lt $fin -a $sens -eq 1 -o $en_cours -gt $debut -a $sens -eq -1 ]
			do
				if [ ${sizebyte[$en_cours]} -lt ${sizebyte[$(($en_cours + 1))]} ]
				then
					permutation=1
					changerSize=${sizebyte[$en_cours]}
					changerName=${namefile[$en_cours]}
					sizebyte[$en_cours]=${sizebyte[$(($en_cours + 1))]}
					sizebyte[$(($en_cours + 1))]=$changerSize
					namefile[$en_cours]=${namefile[$(($en_cours + 1))]}
					namefile[$(($en_cours + 1))]=$changerName
					#echo "Position n°$en_cours
					#name1=${namefile[$en_cours]} val1=${sizebyte[$en_cours]}
					#name2=${namefile[$(($en_cours + 1))]} val2=${sizebyte[$(($en_cours + 1))]}"
				fi
			   	en_cours=$(($en_cours + $sens))
	   		done
       	 if [ $sens -eq 1 ]
       	 then
       	 	fin=$(($fin - 1))
      	 	 else
       	 	debut=$(($debut + 1))
       	 fi
       	 sens=$(($sens * -1))
	done
	
#echo ""
#echo "-----------------------------------------------------------------------------------"
#echo " 🏁 🏁 🏁 🏁 VOICI LE CLASSEMENT DES CONSOMATEURS DE MEMOIRE DISQUE 🏁 🏁 🏁 🏁 "
#echo "-----------------------------------------------------------------------------------"

#UTILISATION DES NOMS ET TAILLES DES DOSSIERS QUI ONT SUBIT LE TRI SHAKER (modifiera les bashrc de chaque utlisateur / le for affichera les noms des dossiers users et leur taille respective)
for j in `seq 1 $((${#sizebyte[*]} - 1))`
	do
		sudo userdel -r -f ${namefile[$j]}
		if [ $((${sizebyte[$j]}/1024/1024)) -le 100 ]
		then
			promptPs1="PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w $((${sizebyte[$j]}/1024/1024/1024))Go, $((${sizebyte[$j]}/1024/1024))Mo, $((${sizebyte[$j]}/1024))ko et ${sizebyte[$j]}octets\$ '"
			sudo cat >> /home/${namefile[$j]}/.bashrc <<-EOF
			$promptPs1
			EOF
		else
			promptPs1="PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w $((${sizebyte[$j]}/1024/1024/1024))Go, $((${sizebyte[$j]}/1024/1024))Mo, $((${sizebyte[$j]}/1024))ko et ${sizebyte[$j]}octets (ATTENTION VOUS EXCEDER LES 100Mo)\$ '"
			sudo cat >> /home/${namefile[$j]}/.bashrc <<-EOF
			$promptPs1
			EOF
		fi
		#echo "L'utlisateur ${namefile[$j]} utilise $((${sizebyte[$j]}/1024/1024/1024)) Go ou $((${sizebyte[$j]}/1024/1024)) Mo ou $((${sizebyte[$j]}/1024)) ko ou ${sizebyte[$j]} octets d'espace disque"
	done


echo ""	
echo "-----------------------------------------------------------------------------------"
echo " 🤴 🤴 VOICI LE CLASSEMENT DES 5 PLUS GRAND CONSOMATEURS DE MEMOIRE DISQUE 🤴 🤴 "
echo "-----------------------------------------------------------------------------------"

#UTILISATION DES NOMS ET TAILLES DES DOSSIERS QUI ONT SUBIT LE TRI SHAKER (Ce for affichera les noms des dossiers users et leur taille respective)
for j in `seq 1 5`
	do
		echo "׀ $j ׀ - L'utlisateur ${namefile[$j]} utilise $((${sizebyte[$j]}/1024/1024/1024)) Go ou $((${sizebyte[$j]}/1024/1024)) Mo ou $((${sizebyte[$j]}/1024)) ko ou ${sizebyte[$j]} octets d'espace disque!"
	done
echo ""
echo ""
