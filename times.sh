#!/bin/bash

################################################################################
# This script shows the time of last acces and last modification done to the   #
# file or to the files matching the <pattern>                                  #
#                                                                              #
#Usage:                                                                        #
#./times.sh <file> OR ./times.sh --pattern <pattern>                           #
#                                                                              #
#                                                                              #
#                      author: TimeLord                                        #
#                      date: 2015                                              #
################################################################################



if [ "$#" -le 0 ]
then
	echo "Usage: ./${0##*/} <file> OR ./${0##*/} --pattern <pattern>"
	exit
fi

if [ "$#" -ge 1 ]
then
	if [ "$1" != "--pattern" ]
	then
		if [ ! -f $1 ]
		then
			echo "File $1 not found."
			exit
		fi
	fi

	if [ -f $1 ]
	then
		echo "File $1 was modified on "$(stat -c %y $1|cut -d ' ' -f1|cut -d'-' -f3)"/"$(stat -c %y $1|cut -d ' ' -f1|cut -d'-' -f2)"/"$(stat -c %y $1|cut -d ' ' -f1|cut -d'-' -f1)" at "$(stat -c %y $1|cut -d' ' -f2|cut -d'.' -f1|cut -d':' -f1,2)" and accesed on "$(stat -c %x $1|cut -d ' ' -f1|cut -d'-' -f3)"/"$(stat -c %x $1|cut -d ' ' -f1|cut -d'-' -f2)"/"$(stat -c %x $1|cut -d ' ' -f1|cut -d'-' -f1)" at "$(stat -c %x $1|cut -d' ' -f2|cut -d'.' -f1|cut -d':' -f1,2)"."
	fi

	if [ "$1" == "--pattern" ]
	then
		if [ "$#" -le "1" ]
		then
			echo "Option --pattern must be followed by a pattern."
			exit
		fi

		if [ "$#" -ge "2" ]
		then
			nu='(.*)[.]+(.*)'
			asd=$2
			while [[ $asd =~ $nu ]];
			do
				asd=${BASH_REMATCH[1]}${BASH_REMATCH[2]}
			done

			ls -tu >asdtimes

			cat asdtimes|grep -x "$2">asdtimes1
			while IFS= read -r file
			do


				echo "File $file was modified on "$(stat -c %y $file|cut -d ' ' -f1|cut -d'-' -f3)"/"$(stat -c %y $file|cut -d ' ' -f1|cut -d'-' -f2)"/"$(stat -c %y $file|cut -d ' ' -f1|cut -d'-' -f1)" at "$(stat -c %y $file|cut -d' ' -f2|cut -d'.' -f1|cut -d':' -f1,2)" and accesed on "$(stat -c %x $file|cut -d ' ' -f1|cut -d'-' -f3)"/"$(stat -c %x $file|cut -d ' ' -f1|cut -d'-' -f2)"/"$(stat -c %x $file|cut -d ' ' -f1|cut -d'-' -f1)" at "$(stat -c %x $file|cut -d' ' -f2|cut -d'.' -f1|cut -d':' -f1,2)"."
				done<"asdtimes1"

		fi
	fi
fi

#Quick fix for files doesn't exist message
rm asdtimes asdtimes1 > /dev/null 2>&1                                                                                                                                                  
