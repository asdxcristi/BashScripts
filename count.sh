#!/bin/bash

################################################################################
# This script counts a top of the most occuring words in a file                #
#                                                                              #
#                                                                              #
#Usage:                                                                        #
#./count.sh <file> OPTIONAL: --count <NumberOfWords> --lines <NumberOfLines>   #
#                  --over <limit>                                              #
#Ex: ./${0##*/} file --count 2 --lines 5 --over 10"                            #
#Shows the first 2 words(based on the number of appearances in <file>) from the#
#first 5 lines, which appear at least 10 times"                                #
#                                                                              #
# By default the script shows the top 15 words                                 #
#                                                                              #
#                                                                              #
#                      author: TimeLord                                        #
#                      date: 2015                                              #
################################################################################


if [ "$#" -le 0 ]; then
	echo "Usage: ./${0##*/} <file> OPTIONAL: --count <NumberOfWords> --lines <NumberOfLines> --over <limit>"
	echo "Ex: ./${0##*/} file --count 2 --lines 5 --over 10"
	echo "Shows the first 2 words(based on the number of appearances in <file>) from the first 5 lines, which appear at least 10 times"
	exit
fi

NrOfCommands=0
countc=0
linesc=0
overc=0
file=$1

if [ $# -eq 1 ]
then
	grep -o -E '\w+' $file |sort -d|uniq -c|sort -k 1nr -k 2d|head -15>asdpublic
	awk '{ print $2 " "$1}' asdpublic
	exit
fi

ARGS=$(getopt -s bash --longoptions "count:,lines:,over:" -n "count.sh" -- "$@");
eval set -- "$ARGS";

while true;do
	case "$1" in
		--count)
			NrOfCommands=$((NrOfCommands+1))
			NrOfCommands=$((NrOfCommands+1))
			shift 1;
			count=$1
		;;

		--lines)
			linesc=$((linesc+1))
			NrOfCommands=$((NrOfCommands+1))
			shift 1;
			lines=$1
		;;

		--over)
			overc=$((overc+1))
			NrOfCommands=$((NrOfCommands+1))
			shift 1;
			limit=$1
		;;

		--)
			shift;
			break
		;;

		*)
			shift;
			break
		;;

	esac

shift
	stop=$((stop-1))
done

if [ "$NrOfCommands" == "3" ]
then
	if [ "$linesc" == "1" ]
	then
		cat $file |head -$lines>asdlines
		if [ "$countc" == "1" ]
		then
			grep -o -E '\w+' asdlines |sort -d|uniq -c|sort -k 1nr -k 2d|head -$count>asdcount
			if [ "$overc" == "1" ]
			then
				awk -v threshold="$limit" '$1 >=threshold' asdcount >asdover
				awk '{ print $2 " "$1}' asdover

			fi
		fi
	fi
fi

if [ "$NrOfCommands" == "1" ]
	then

	if [ "$countc" == "1" ]
	then
		grep -o -E '\w+' $file |sort -d|uniq -c|sort -k 1nr -k 2d|head -$count>asdpublic
		awk '{ print $2 " "$1}' asdpublic
	fi

	if [ "$linesc" == "1" ]
	then
		cat $file |head -$lines|grep -o -E '\w+' |sort -d|uniq -c|sort -k 1nr -k 2d>asdpublic
		awk '{ print $2 " "$1}' asdpublic
	fi

	if [ "$overc" == "1" ]
	then
		grep -o -E '\w+' $file |sort -d|uniq -c|sort -k 1nr -k 2d>asdpublic
		awk -v threshold="$limit" '$1 >=threshold' asdpublic >asdpublicp
		awk '{ print $2 " "$1}' asdpublicp
	fi

fi


if [ "$NrOfCommands" == "2" ]
then

	if [ "$linesc" == "1" ]
	then
	cat $file |head -$lines>asdlines
		if [ "$countc" == "1" ]
		then
			grep -o -E '\w+' asdlines |sort -d|uniq -c|sort -k 1nr -k 2d|head -$count>asdcount
			awk '{ print $2 " "$1}' asdcount
		fi

		if [ "$overc" == "1" ]
		then
			grep -o -E '\w+' asdlines|sort -d|uniq -c|sort -k 1nr -k 2d>asdover
			awk -v threshold="$limit" '$1 >=threshold' asdover>asdpublic
			awk '{ print $2 " "$1}' asdpublic
		fi
	exit 1
	fi

	grep -o -E '\w+' $file |sort -d|uniq -c|sort -k 1nr -k 2d|head -$count>asdcount
	awk -v threshold="$limit" '$1 >=threshold' asdcount>asdpublic
	awk '{ print $2 " "$1}' asdpublic

fi

#Quick fix for files doesn't exist message
rm asdcount asdpublic asdpublicp > /dev/null 2>&1


