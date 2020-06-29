#!/bin/bash

#RECUPERATION DES TAILLES DES DOSSIERS (le tableau sizebyte contiendra les tailles selons le output de la commande du et cut)
indice=0
sizebyte=(0)
for i in `du -b /home/user* | cut -d '	' -f 1`
	do
		sizebyte+=($i)
		indice=$(($indice+1))
		echo "$((${sizebyte[$indice]}/1024/1024/1024)) Go, $((${sizebyte[$indice]}/1024/1024)) Mo, $((${sizebyte[$indice]}/1024)) ko et ${sizebyte[$indice]} octets"
		
	done
	
echo "--------------------------"


#RECUPERATION DES NOMS DES DOSSIERS (le tableau namefile contiendra les noms selons le output de la commande du et cut qui est exactement la même commande exécuter au premier for)
indice=0
namefile=(0)
for k in `du -b /home/user* | cut -d '/' -f 3,3`
	do
		namefile+=($k)
		indice=$(($indice+1))	
	done
	
echo "--------------------------"

#UTILISATION DES NOMS ET TAILLES DES DOSSIERS (Ce for affichera les noms des dossiers users et leur taille respective)
for j in `seq 1 $((${#sizebyte[*]} - 1))`
	do
		echo "Le ${namefile[$j]} utilise ${sizebyte[$j]} bytes d'espace disque"
	done
	
#----------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------

#UTILISATION DES TAILLES DES DOSSIERS POUR FAIRE LE TRI SHAKER

permutation=1
sens=1
en_cours=0


debut=0
fin=$((${#sizebyte[*]} - 1))
while [ $permutation -eq 1 ]   
	do
    		permutation=0
		while [ $en_cours -lt $fin -a $sens -eq 1 -o $en_cours -gt $debut -a $sens -eq -1 ]
			do
				if [ ${sizebyte[$en_cours]} -gt ${sizebyte[$(($en_cours + 1))]} ]
				then
					permutation=1
					changer=${sizebyte[$en_cours]}
					echo ${sizebyte[$en_cours]}
					sizebyte=([$en_cours]=${sizebyte[$(($en_cours + 1))]})
					echo ${sizebyte[$en_cours]}
					sizebyte=([$(($en_cours + 1))]=$changer)
					echo ${sizebyte[$(($en_cours + 1))]}
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
