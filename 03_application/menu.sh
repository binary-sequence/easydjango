#!/bin/bash
# =====================
# menu.sh bash script
# =====================
# Copyright (c) 2012 Sergio Lindo <sergiolindo.empresa@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# What does it do?
# ================
# It must show a console interface to user.
# It uses echo, printf, read, clear, sed comands.
# =====================
EASYDJANGO_VERSION='v0.2'
APACHE_CONF_DIR='/etc/apache2/'
DJANGO_PROJECTS_PATH='/usr/local/easydjango/'
EASY_DJANGO_DIR=`dirname $0`"/"
function showMenu {
	title=`echo $1 | tr '_' ' '` # First argument is title menu.
	clear
	echo ""
	echo "   EasyDjango $EASYDJANGO_VERSION - $title"
	echo ""
	index=0
	for option in $@; do
		if [ $index -ge 1 ]; then
			printf "   %3s " "$index."; echo "$option" | tr '_' ' '
		fi
		let index=$index+1
	done
	printf "   %3s " "q."; echo "Quit"
	echo ""
}
#APACHE MENU
function apache_listenMenu {
	quitListenMenu=0 # False
	listenMenuError=0 # False
	while [ $quitListenMenu = 0 ]; do
		showMenu "Apache_configuration/Listen_(port.conf)" "Add_port" "Remove_port"
		bash $EASY_DJANGO_DIR"apache/listen.sh" -s $APACHE_CONF_DIR"ports.conf" | sed -e 's/^/    /'
		echo ""
		if [ $listenMenuError = 0 ]; then
			read -p " Type option: " listenMenuOption
		else
			echo " Option '$listenMenuOption' is not valid."
			read -p " Type option again: " listenMenuOption
			listenMenuError=0 # False
		fi
		case $listenMenuOption in
			[12])
				echo ""
				read -p "    Type port number: " port
				if [ "$port" = "" ]; then
					echo "    Error: Port number is empty."
				else
					if [[ ! "$port" =~ ^[1-9][0-9]*$ ]]; then
						echo "    Port number is not a valid positive number: $port."
					else
						if [ $listenMenuOption = 1 ]; then # 1. Add_port
							sudo bash $EASY_DJANGO_DIR"apache/listen.sh" -a $port $APACHE_CONF_DIR"ports.conf" | sed -e 's/^/    /'
						else # 2. Remove_port
							sudo bash $EASY_DJANGO_DIR"apache/listen.sh" -r $port $APACHE_CONF_DIR"ports.conf" | sed -e 's/^/    /'
						fi
					fi
				fi
				read -p "Press enter to continue..." pause
			;;
			[qQ]*)
				quitListenMenu=1 # True
				# exit
			;;
			*)
				listenMenuError=1 # True
			;;
		esac
	done
}
function apache_virtualHostMenu {
	quitVirtualHostMenu=0 # False
	virtualHostMenuError=0 # False
	while [ $quitVirtualHostMenu = 0 ]; do
		showMenu "Apache_configuration/Virtual_hosts_(sites-available/)" "Add_vitual_host" "Remove_vitual_host" "Enable_vitual_host" "Disable_vitual_host"
		bash $EASY_DJANGO_DIR"apache/virtualHost.sh" -s $APACHE_CONF_DIR | sed -e 's/^/    /'
		echo ""
		if [ $virtualHostMenuError = 0 ]; then
			read -p " Type option: " virtualHostMenuOption
		else
			echo " Option '$virtualHostMenuOption' is not valid."
			read -p " Type option again: " virtualHostMenuOption
			virtualHostMenuError=0 # False
		fi
		case $virtualHostMenuOption in
			[1234])
				echo ""
				read -p "    Type server's name: " serverName
				if [ "$serverName" = "" ]; then
					echo "    Error: Server's name is empty"
				else
					if [ $virtualHostMenuOption = 1 ]; then # 1. Add_vitual_host
						read -p "    Type server's listen port: " serverListenPort
						if [ "$serverListenPort" = "" ]; then
							echo "    Error: Listen port is empty"
						else
							if [[ ! "$serverListenPort" =~ ^[1-9][0-9]*$ ]]; then
								echo "    Port number is not a valid positive number: $serverListenPort."
							else
								sudo bash $EASY_DJANGO_DIR"apache/virtualHost.sh" -a $serverName $serverListenPort $APACHE_CONF_DIR | sed -e 's/^/    /'
							fi
						fi
					fi
					if [ $virtualHostMenuOption = 2 ]; then # 2. Remove_vitual_host
						sudo bash $EASY_DJANGO_DIR"apache/virtualHost.sh" -r $serverName $APACHE_CONF_DIR | sed -e 's/^/    /'
					fi
					if [ $virtualHostMenuOption = 3 ]; then # 3. Enable_vitual_host
						sudo bash $EASY_DJANGO_DIR"apache/virtualHost.sh" -e $serverName | sed -e 's/^/    /'
					fi
					if [ $virtualHostMenuOption = 4 ]; then # 4. Disable_vitual_host
						sudo bash $EASY_DJANGO_DIR"apache/virtualHost.sh" -d $serverName | sed -e 's/^/    /'
					fi
				fi
				read -p "Press enter to continue..." pause
			;;
			[qQ]*)
				quitVirtualHostMenu=1 # True
				# exit
			;;
			*)
				virtualHostMenuError=1 # True
			;;
		esac
	done
}
function apache_menu {
	quitApacheMenu=0 # False
	apacheMenuError=0 # False
	while [ $quitApacheMenu = 0 ]; do
		showMenu "Apache_configuration" "Listen_(port.conf)" "Virtual_hosts_(sites-available/)" "Restart_apache"
		if [ $apacheMenuError = 0 ]; then
			read -p " Type option: " apacheMenuOption
		else
			echo " Option '$apacheMenuOption' is not valid."
			read -p " Type option again: " apacheMenuOption
			apacheMenuError=0 # False
		fi
		case $apacheMenuOption in
			1) # 1. Listen_(port.conf)
				apache_listenMenu
			;;
			2) # 2. Virtual_hosts_(sites-available/)
				apache_virtualHostMenu
			;;
			3) # 3 Restart_apache
				sudo /etc/init.d/apache2 restart | sed -e 's/^/    /'
				read -p "Press enter to continue..." pause
			;;
			[qQ]*)
				quitApacheMenu=1 # True
				# exit
			;;
			*)
				apacheMenuError=1 # True
			;;
		esac
	done
}
#DJANGO MENU
function django_menu {
	quitDjangoMenu=0 # False
	djangoMenuError=0 # False
	while [ $quitDjangoMenu = 0 ]; do
		showMenu "Django_configuration" "Add_project" "Remove_project" "Add_application" "Remove_application" "Change_debug_mode"
		bash $EASY_DJANGO_DIR"django/project.sh" -s $DJANGO_PROJECTS_PATH | sed -e 's/^/    /'
		echo ""
		if [ $djangoMenuError = 0 ]; then
			read -p " Type option: " djangoMenuOption
		else
			echo " Option '$djangoMenuOption' is not valid."
			read -p " Type option again: " djangoMenuOption
			djangoMenuError=0 # False
		fi
		case $djangoMenuOption in
			[12345])
				echo ""
				read -p "    Type project name: " projectName
				if [ "$projectName" = "" ]; then
					echo "    Error: Project name is empty."
				else
					if [ $djangoMenuOption = 1 ]; then # 1. Add_project
						bash $EASY_DJANGO_DIR"django/project.sh" -a $projectName $DJANGO_PROJECTS_PATH | sed -e 's/^/    /'
					fi
					if [ $djangoMenuOption = 2 ]; then # 2. Remove_project
						bash $EASY_DJANGO_DIR"django/project.sh" -r $projectName $DJANGO_PROJECTS_PATH | sed -e 's/^/    /'
					fi
					if [[ $djangoMenuOption =~ [34] ]]; then
						if [ ! -d $DJANGO_PROJECTS_PATH$projectName ]; then
							echo "    Error: Project '$DJANGO_PROJECTS_PATH$projectName' does not exist."
						else
							read -p "    Type application name: " appName
							if [ "$appName" = "" ]; then
								echo "    Error: Application name is empty."
							else
								if [ $djangoMenuOption = 3 ]; then # 3. Add_application
									if [ -d $DJANGO_PROJECTS_PATH$projectName"/"$appName ]; then
										echo "    '$projectName' already have '$appName' application."
									else
										bash $EASY_DJANGO_DIR"django/project.sh" -m $appName $DJANGO_PROJECTS_PATH$projectName | sed -e 's/^/    /'
									fi
								else # 4. Remove_application
									if [ ! -d $DJANGO_PROJECTS_PATH$projectName"/"$appName ]; then
										echo "    '$projectName' have not '$appName' application."
									else
										bash $EASY_DJANGO_DIR"django/project.sh" -m $appName $DJANGO_PROJECTS_PATH$projectName | sed -e 's/^/    /'
									fi
								fi
							fi
						fi
					fi
					if [ $djangoMenuOption = 5 ]; then # 5. Change_debug_mode
						read -p "    Type mode (on/off): " debugMode
						if [ ! "$debugMode" = "" ]; then
							if [[ "$debugMode" =~ ^[Oo][Nn]$ ]]; then
								sed -i -e 's/^DEBUG = .*$/DEBUG = True/' $DJANGO_PROJECTS_PATH$projectName"/"$projectName"/settings.py"
							fi
							if [[ "$debugMode" =~ ^[Oo][Ff][Ff]$ ]]; then
								sed -i -e 's/^DEBUG = .*$/DEBUG = False/' $DJANGO_PROJECTS_PATH$projectName"/"$projectName"/settings.py"
							fi
						fi
						grep "^DEBUG = " $DJANGO_PROJECTS_PATH$projectName"/"$projectName"/settings.py" | sed -e 's/^/    /'
					fi
				fi
				read -p "Press enter to continue..." pause
			;;
			[qQ]*)
				quitDjangoMenu=1 # True
				# exit
			;;
			*)
				djangoMenuError=1 # True
			;;
		esac
	done
}
#MAIN
quitMainMenu=0 # False
mainMenuError=0 # False
while [ $quitMainMenu = 0 ]; do
	showMenu "Main_menu" "Configure_Apache" "Manage_Django"
	if [ $mainMenuError = 0 ]; then
		read -p " Type option: " mainMenuOption
	else
		echo " Option '$mainMenuOption' is not valid."
		read -p " Type option again: " mainMenuOption
		mainMenuError=0 # False
	fi
	case $mainMenuOption in
		1) # 1. Configure Apache
			apache_menu
		;;
		2) # 2. Manage Django
			django_menu
		;;
		[qQ]*) # q. Quit
			quitMainMenu=1 # True
			# exit
		;;
		*)
			mainMenuError=1 # True
		;;
	esac
done
exit
