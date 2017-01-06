#!/bin/bash

################################################################################
# This script gets info from "world database" and shows it according to your   #
#specifications                                                                #
#                                                                              #
#                                                                              #
#Usage: ./query_world --population --capital <capital> --country <country>     #
#--speakers --language <language> --languages --language <language>            #
#                                                                              #
#Ex:./query_world.sh --population --country Romania                            #
#./query_world.sh --population --capital Bucuresti --country Romania           #
#./query_world.sh --languages --language Romanian                              #
#                                                                              #
#                                                                              #
#  *REQUIERMENTS: mysql-server-5.5                                             #
#                                                                              #
#                                                                              #
#                      author: TimeLord                                        #
#                      date: 2015                                              #
################################################################################


  
nrcom=0
capitalc=0
countryc=0
languagec=0

if [ $# -eq 0 ]
then
	echo "At least 1 argument needed"
	echo "Usage: ./${0##*/} --population --capital <capital> --country <country> --speakers --language <language> --languages --language <language>"
	exit 0
fi

if [ $# -eq 1 ]
then
	if [ "$1" == "--population" ]
	then
		echo "SELECT Country.Name, Country.Population, City.Name, City.Population FROM City,Country WHERE Country.Capital=City.ID  ;" | mysql -uroot -proot world >asdsql
		if [  -s "asdsql" ]
		then
			echo "Name,Population,Capital Name,Capital Population"
			sed -i -e 's/\t/,/g' asdsql
			cat asdsql|tail -n +2
		fi
	fi

	if [ "$1" == "--languages" ]
	then
	echo "SELECT Country.Name, CountryLanguage.Language FROM Country,CountryLanguage  WHERE Country.Code=CountryLanguage.CountryCode  ;" | mysql -uroot -proot world >asdsql
		if [  -s "asdsql" ]
		then
			echo "Country,Language"
			sed -i -e 's/\t/,/g' asdsql
			cat asdsql|tail -n +2
		fi
	fi

fi

if [ $# -eq 2 ]
then
	if [ "$1" == "--population" ]
	then
		if [ "$2" != "--country" ]
		then
			if [ "$2" != "--capital" ]
			then
				echo "Wrong argument: $2"
				exit 0
			fi
		fi
	fi
fi


if [ $# -eq 2 ]
then
	if [ "$1" == "--languages" ]
	then
		if [ "$2" != "--language" ]
		then
			if [ "$2" != "--country" ]
			then
				echo "Wrong argument: $2"
				exit 0
			fi
		fi
	fi
fi


if [ $# -eq 2 ]
then
	if [ "$1" == "--speakers" ]
	then
		if [ "$2" != "--language" ]
		then
			echo "Wrong argument: $2"
			exit 0
		fi
	fi
fi

if [ $# -eq 1 ]
then
	if [ "$1" == "--speakers" ]
	then
		echo "Missing argument --language"
		exit
	fi
fi




if [ "$1" != "--population" ]
then
	if [ "$1" != "--languages" ]
	then
		if [ "$1" != "--speakers" ]
		then
			echo "First argument must be one of [--population|--languages|--speakers]"
		fi
	fi
fi


if [ $# -ge 2 ]
then
	if [ "$1" == "--population" ]
	then
		ARGS=$(getopt -s bash --longoptions "population:,capital:,country:" -n "query_world.sh" -- "$@");
		eval set -- "$ARGS";

		while true;do
		case "$1" in
			--country)
				countryc=$((countryc+1))
				nrcom=$((nrcom+1))
				shift 1;
				country=$1
			;;

			--capital)
				capitalc=$((capitalc+1))
				nrcom=$((nrcom+1))
				shift 1;
				capital=$1
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


		if [ "$nrcom" == "1" ]
		then
			if [ "$countryc" == "1" ]
			then

			echo "SELECT Country.Name, Country.Population, City.Name, City.Population FROM City,Country WHERE Country.Capital=City.ID AND Country.Name='$country' ;" | mysql -uroot -proot world >asdsql
				if [  -s "asdsql" ]
				then
					echo "Name,Population,Capital Name,Capital Population"
					sed -i -e 's/\t/,/g' asdsql
					cat asdsql|tail -n +2
				fi

			fi

			if [ "$capitalc" == "1" ]
			then

			echo "SELECT Country.Name, Country.Population, City.Name, City.Population FROM City,Country WHERE Country.Capital=City.ID AND City.Name='$capital' ;" | mysql -uroot -proot world >asdsql
				if [  -s "asdsql" ]
				then
					echo "Name,Population,Capital Name,Capital Population"
					sed -i -e 's/\t/,/g' asdsql
					cat asdsql|tail -n +2
				fi

			fi

		fi

		if [ "$nrcom" == "2" ]
		then
			if [ "$countryc" == "1" ]
			then
				if [ "$capitalc" == "1" ]
				then
						echo "SELECT Country.Name, Country.Population, City.Name, City.Population FROM City,Country WHERE Country.Capital=City.ID AND City.Name='$capital' AND Country.Name='$country' ;" | mysql -uroot -proot world >asdsql
					if [  -s "asdsql" ]
					then
						echo "Name,Population,Capital Name,Capital Population"
						sed -i -e 's/\t/,/g' asdsql
						cat asdsql|tail -n +2
					fi

				fi
			fi
		fi
	fi


#populationen

if [ "$1" == "--languages" ]
then
	ARGS=$(getopt -s bash --longoptions "languages:,language:,country:" -n "query_world.sh" -- "$@");
	eval set -- "$ARGS";
	while true;do
		case "$1" in
			--country)
				countryc=$((countryc+1))
				nrcom=$((nrcom+1))
				shift 1;
				country=$1
			;;

			--language)
				languagec=$((languagec+1))
				nrcom=$((nrcom+1))
				shift 1;
				language=$1
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

	if [ "$nrcom" == "1" ]
	then
		if [ "$languagec" == "1" ]
		then

			echo "SELECT Country.Name, CountryLanguage.Language FROM Country,CountryLanguage  WHERE Country.Code=CountryLanguage.CountryCode AND CountryLanguage.Language='$language'  ;" | mysql -uroot -proot world >asdsql

			if [  -s "asdsql" ]
			then
				echo "Country,Language"
				sed -i -e 's/\t/,/g' asdsql
				cat asdsql|tail -n +2
			fi
		#language
		fi

		if [ "$countryc" == "1" ]
		then

			echo "SELECT Country.Name, CountryLanguage.Language FROM Country,CountryLanguage  WHERE Country.Code=CountryLanguage.CountryCode AND Country.Name='$country'  ;" | mysql -uroot -proot world >asdsql

			if [  -s "asdsql" ]
			then
				echo "Country,Language"
				sed -i -e 's/\t/,/g' asdsql
				cat asdsql|tail -n +2
			fi
		#country
		fi
	fi

#nrcom

	if [ "$nrcom" == "2" ]
	then
		if [ "$countryc" == "1" ]
		then
			if [ "$languagec" == "1" ]
			then

				echo "SELECT Country.Name, CountryLanguage.Language FROM Country,CountryLanguage  WHERE Country.Code=CountryLanguage.CountryCode AND Country.Name='$country' AND CountryLanguage.Language='$language'  ;" | mysql -uroot -proot world >asdsql

				if [  -s "asdsql" ]
				then
					echo "Country,Language"
					sed -i -e 's/\t/,/g' asdsql
					cat asdsql|tail -n +2
				fi

			fi
		fi
	fi

fi
fi

#languages
if [ "$1" == "--speakers" ]
then
	ARGS=$(getopt -s bash --longoptions "speakers:,language:,country:" -n "query_world.sh" -- "$@");
	eval set -- "$ARGS";
	while true;do
		case "$1" in
			--country)
				countryc=$((countryc+1))
				nrcom=$((nrcom+1))
				shift 1;
				country=$1
			;;

			--language)
				languagec=$((languagec+1))
				nrcom=$((nrcom+1))
				shift 1;
				language=$1
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


	if [ "$nrcom" == "1" ]
	then
		if [ "$languagec" == "1" ]
		then

			echo "SELECT CountryLanguage.Language,SUM(FLOOR(Country.Population * cast(CountryLanguage.Percentage as decimal(15,12))/100)) AS asd from CountryLanguage,Country WHERE Country.Code=CountryLanguage.CountryCode AND CountryLanguage.Language='$language' ;" | mysql -uroot -proot world >asdsql


			if [  -s "asdsql" ]
			then
				if [ "$( cat asdsql|tail -n1|cut -f1)" != "NULL" ]
				then
					echo "Language,Speakers"
					sed -i -e 's/\t/,/g' asdsql
					cat asdsql|tail -n +2
				fi
			fi

		fi

	#nrcom1
	fi

	if [ "$nrcom" -ge "2" ]
	then

		echo "SELECT CountryLanguage.Language,SUM(FLOOR(Country.Population * cast(CountryLanguage.Percentage as decimal(15,12))/100)) AS asd from CountryLanguage,Country WHERE Country.Code=CountryLanguage.CountryCode AND Country.Name='$country' AND CountryLanguage.Language='$language' ;" | mysql -uroot -proot world >asdsql


		if [  -s "asdsql" ]
		then
			echo "Language,Speakers"
			sed -i -e 's/\t/,/g' asdsql
			cat asdsql|tail -n +2
		fi

	fi

#speakers
fi

                                                       

