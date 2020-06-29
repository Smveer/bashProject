#!/bin/bash

for i in `du -b /home/user* | cut -d '	' -f 1`
	do
		sizebyte=$i
		echo "$(($sizebyte/1024/1024/1024)) Go, $(($sizebyte/1024/1024)) Mo, $(($sizebyte/1024)) ko et $sizebyte octets"
	done
	
	permutation=1
	sens=1
	en_cours=0
	
    	debut=0
    	fin=${#i[*]}
    	while [ $permutation -eq 1 ]   
    		do
	    		permutation=0
			while [ $en_cours -lt $fin -a sens -eq 1 -o $en_cours -gt $debut -a sens -eq -1]
				do
				  	  # Test si echange
				   	 if tableau[en_cours] > tableau[en_cours + 1]:
				   	     permutation = True
				    	    # On echange les deux elements
				    	    tableau[en_cours], tableau[en_cours + 1] = \
				    	    tableau[en_cours + 1],tableau[en_cours]
				   	 en_cours = en_cours + sens
		   		done
	       	 # On change le sens du parcours
	       	 if sens==1:
	       	     fin = fin - 1
	      	 	 else:
	       	     debut = debut + 1
	      	  	sens = -sens
	      	  	
    		done
        
