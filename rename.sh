#!/bin/bash

################################################################################
# This script renames all files in a <folder> or in current folder             #
# using a <baseName> and an <extensionType>.                                   #
# Ex: asd.exe; tl.exe --->>> baseName1.exetensionType; baseName2.exetensionType#
#                                                                              #
# Usage: ./rename.sh <baseName> <extensionType> OPTIONAL:<folder>              #
# Ex: ./${0##*/} file exe KinkyFolder/"                                        #
#                                                                              #
#                                                                              #
#                      author: TimeLord                                        #
#                      date: 2015                                              #
################################################################################

if [ "$#" -le 1 ]; then
	echo "Usage: ./${0##*/} <baseName> <extensionType> OPTIONAL:<folder>"
	echo "Ex: ./${0##*/} file exe KinkyFolder/"
	exit
fi

if [ "$#" -eq 2 ]; then
	cd $(pwd)
	numberOfFiles=0
	count=1

	for i in *
	do
		numberOfFiles=$((numberOfFiles+1));
	done

	currentNumber=0

	while [ "$numberOfFiles" -gt 0 ]
	do
		currentNumber=$((currentNumber+1));
		numberOfFiles=$((numberOfFiles/10));
	done

	for i in *
	do
		mv $i "$1$(printf "%0"$currentNumber"d" "$count")"."$2"
		count=$((count+1));
	done
fi


if [ "$#" -eq 3 ]; then
	count=1
	cd $3
	numberOfFiles=0

	for i in *
		do
			numberOfFiles=$((numberOfFiles+1));
		done

	while [ "$numberOfFiles" -gt 0 ]
	do
		currentNumber=$((currentNumber+1));
		numberOfFiles=$((numberOfFiles/10));
	done

	for i in *
	do
		mv $i "$1$(printf "%0"$currentNumber"d" "$count")"."$2"
		count=$((count+1));
	done

fi

