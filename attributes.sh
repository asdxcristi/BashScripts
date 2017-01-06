#!/bin/bash

################################################################################
# This script counts the bold, italic and bold and italic encoded using        #
#Markdown words from a file                                                    #
# Can be used in a parser/interpreter for Markdown                             #
#                                                                              #
# Markdown encodings:                                                          #
# *italic* _italic_                                                            #
# **bold**  __bold__                                                           #
# **bold and _italic_**                                                        #
#                                                                              #
#                                                                              #
#Usage:                                                                        #
#./attributes.sh <file>                                                        #
#                                                                              #
#                                                                              #
#                      author: TimeLord                                        #
#                      date: 2015                                              #
################################################################################


if [ $# -le 0 ]
then
	echo "Usage: ./${0##*/} <file> "
	exit
fi


if [ $# -eq 1 ]
then
	if [ ! -f $1 ]
	then
		echo "File $1 not found."
		exit
	fi
fi



if [ $# -eq 1 ]
then
	if [ -f $1 ]
	then

	cat $1 >test

	sed  's/ /@/g' $1 >asdatrib4
	sed ':a;N;$!ba;s/\n/@/g' asdatrib4 >asdatrib3

	sed  's/\*\*/#/g' asdatrib3 >asdatrib1
	sed  's/\_\_/~/g' asdatrib1 >asdatrib2

	cat asdatrib2| sed -e 's/\(.\)/\1\n/g'>asdatrib

	bold=0
	italic=0
	ib=0
	lampab=0
	lampai=0
	sex=0
	sexi=0
	sexy=0
	while read line
	do
		if [ $lampab -eq 2 ]
		then
			lampab=0
			((sex++))
		fi

		if [ $lampai -eq 2 ]
		then
			lampai=0
			((sexi++))
		fi


		if [ "$line" == "#" ]
		then
			((bold++))
			((lampab++))
		fi

		if [ "$line" == "~" ]
		then
			((bold++))
			((lampab++))
		fi

		if [ "$line" == "*" ]
		then
			((italic++))
			((lampai++))
		fi

		if [ "$line" == "_" ]
		then
			((italic++))
			((lampai++))
		fi

		if [ $lampab -eq 1 ]
		then
			if [ "$line" == "@" ]
			then
				((bold++))
			fi
		fi


		if [ $lampai -eq 1 ]
		then
			if [ "$line" == "@" ]
			then
				((italic++))
			fi
		fi

		if [ $lampai -eq 1 ]
		then
			if [ $lampab -eq 1 ]
			then
				if [ "$line" == "@" ]
				then
					((ib++))
				fi
			fi
		fi

		if [ $lampai -eq 2 ]
		then
			if [ $lampab -eq 1 ]
			then
				((sexy++))
			fi
		fi

		if [ $lampai -eq 1 ]
		then
			if [ $lampab -eq 2 ]
			then
				((sexy++))
			fi
		fi

	done <asdatrib

	bold=$((bold-sex))
	italic=$((italic-sexi))
	count=$(expr $ib + $sexy)
	echo "Words in bold: $bold"
	echo "Words in italic: $italic"
	echo "Words both in bold and italic: $count"
	fi
fi

#Quick fix for files doesn't exist message
rm asdatrib asdatrib1 asdatrib2 asdatrib3 asdatrib4 > /dev/null 2>&1  

