#!/bin/bash
# =====================
# virtualHost.sh bash script
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
# It must add or remove virtual host directives from sites-available/ and sites-enabled/.
# It uses echo, printf, grep, a2dissite and a2ensite comands.
# =====================
function addVirtualHost {
	virtualHostName=$1 # First argument is virtual host name.
	port=$2 # Second argument is virtual host port.
	apacheConfigurationDirectory=$3 # Third argument is apache configuration directory.
	directoryRoot="/usr/local/www/"$virtualHostName"/" | tr '.' '_'
	if [[ $apacheConfigurationDirectory =~ .*/$ ]]; then
		virtualHostFile=$apacheConfigurationDirectory"sites-available/"$virtualHostName
	else
		virtualHostFile=$apacheConfigurationDirectory"/sites-available/"$virtualHostName
	fi
	echo "#Host added by virtualHost.sh" > $virtualHostFile
	echo "<VirtualHost *:"$port">" >> $virtualHostFile
	echo "    ServerName "$virtualHostName >> $virtualHostFile
	echo "" >> $virtualHostFile
	echo "    DocumentRoot "$directoryRoot"documents" >> $virtualHostFile
	echo "    <Directory "$directoryRoot"documents/>" >> $virtualHostFile
	echo "        AllowOverride None" >> $virtualHostFile
	echo "        Order allow,deny" >> $virtualHostFile
	echo "        Allow from all" >> $virtualHostFile
	echo "    </Directory>" >> $virtualHostFile
	echo "" >> $virtualHostFile
	echo "    WSGIScriptAlias / "$directoryRoot`echo $virtualHostName | tr '.' '_'`"/wsgi.py" >> $virtualHostFile
	echo "    <Directory "$directoryRoot">" >> $virtualHostFile
	echo "        AllowOverride None" >> $virtualHostFile
	echo "        Order allow,deny" >> $virtualHostFile
	echo "        Allow from all" >> $virtualHostFile
	echo "    </Directory>" >> $virtualHostFile
	echo "" >> $virtualHostFile
	echo "    ErrorLog "$directoryRoot"logs/error.log" >> $virtualHostFile
	echo "    CustomLog "$directoryRoot"logs/access.log combined" >> $virtualHostFile
	echo "</VirtualHost>" >> $virtualHostFile
	echo "" >> $virtualHostFile
}
function removeVirtualHost {
	virtualHostName=$1 # First argument is virtual host name.
	apacheConfigurationDirectory=$2 # Second argument is apache configuration directory.
	if [[ $apacheConfigurationDirectory =~ .*/$ ]]; then
		virtualHostFile=$apacheConfigurationDirectory"sites-available/"$virtualHostName
	else
		virtualHostFile=$apacheConfigurationDirectory"/sites-available/"$virtualHostName
	fi
	rm $virtualHostFile
}
function showVirtualHosts {
	apacheConfigurationDirectory=$1 # First argument is apache configuration directory.
	if [[ $apacheConfigurationDirectory =~ .*/$ ]]; then
		hostsAvailable=$apacheConfigurationDirectory"sites-available/"
		hostsEnabled=$apacheConfigurationDirectory"sites-enabled/"
	else
		hostsAvailable=$apacheConfigurationDirectory"/sites-available/"
		hostsEnabled=$apacheConfigurationDirectory"/sites-enabled/"
	fi

	echo "Virtual host list:"
	printf "%23s    " "SERVER NAME"; printf "%6s    " PORT; printf "%-3s\n" STATUS
	for file in `ls $hostsAvailable`; do
		serverName=$file
		port=`grep "^<VirtualHost \*:" $hostsAvailable$serverName | cut -f2 -d: | cut -f1 -d\>`
		if [ -f $hostsEnabled$serverName ]; then
			status="ON"
		else
			status="OFF"
		fi
		printf "%23s    " $serverName; printf "%6s    " $port; printf "%-3s\n" $status
	done
}
function showHelp {
	# If somebody use virtualHost.sh in a wrong way, it will show this help.
	echo "Use: virtualHost.sh -option [virtualHostName] [port] [apache_config_file]"
	echo ""
	echo "  -a"
	echo "      Add virtual host directives in file apache_config_file."
	echo "  -d"
	echo "      Disable virtual host from apache_config_file."
	echo "  -e"
	echo "      Enable virtual host from apache_config_file."
	echo "  -r"
	echo "      Remove virtual host directives from apache_config_file."
	echo "  -s"
	echo "      Show available virtual host from apache_config_file."
	echo ""
	echo "  Example:"
	echo "      virtualHost.sh -a www.mysite.com 80 /etc/apache2/"
	echo "      virtualHost.sh -e www.mysite.com"
	echo "      virtualHost.sh -s /etc/apache2/"
	echo ""
}
# MAIN
if [ $# -eq 0 ]; then
	echo "Option argument is missing."
	showHelp
	exit
else
	case $1 in
		-a)
			expected_args=4
			if [ $# -ne $expected_args ]; then
				echo "Number of arguments is incorrect: "$#"."
				showHelp
				exit
			else
				if [ "$4" = "" ] || [ ! -d $4 ]; then
					echo "Fourth argument is not a valid directory: "$4"."
					showHelp
					exit
				else
					if [[ ! "$3" =~ ^[1-9][0-9]*$ ]]; then
						echo "Third argument is not a valid positive number: "$3"."
						showHelp
						exit
					else
						if [[ $4 =~ .*/$ ]]; then
							hostsAvailable=$4"sites-available/"
						else
							hostsAvailable=$4"/sites-available/"
						fi
						if [ -f $hostsAvailable$2 ]; then
							echo "Virtual host '"$2"' already exists."
						else
							addVirtualHost $2 $3 $4
							if [ -f $hostsAvailable$2 ]; then
								echo "Virtual host $2 has been added."
								echo "*WARNING*:Apache must be restarted before changes take effect."
							else
								echo "Error: virtual host $2 has not been added."
							fi
						fi
					fi
				fi
			fi
		;;
		-d)
			expected_args=2
			if [ $# -ne $expected_args ]; then
				echo "Number of arguments is incorrect: "$#"."
				showHelp
				exit
			else
				virtualHostName=$2 # Second argument is virtual host name.
				a2dissite $virtualHostName | sed -e '/^To activate/d' -e 's/^.*service.*$/*WARNING*:Apache must be restarted before changes take effect./'
			fi
		;;
		-e)
			expected_args=2
			if [ $# -ne $expected_args ]; then
				echo "Number of arguments is incorrect: "$#"."
				showHelp
				exit
			else
				virtualHostName=$2 # Second argument is virtual host name.
				a2ensite $virtualHostName | sed -e '/^To activate/d' -e 's/^.*service.*$/*WARNING*:Apache must be restarted before changes take effect./'
			fi
		;;
		-r)
			expected_args=3
			if [ $# -ne $expected_args ]; then
				echo "Number of arguments is incorrect: "$#"."
				showHelp
				exit
			else
				if [ "$3" = "" ] || [ ! -d $3 ]; then
					echo "Third argument is not a valid directory: "$3"."
					showHelp
					exit
				else
					if [[ $3 =~ .*/$ ]]; then
						hostsAvailable=$3"sites-available/"
						hostsEnabled=$3"sites-enabled/"
					else
						hostsAvailable=$3"/sites-available/"
						hostsEnabled=$3"/sites-enabled/"
					fi
					if [ ! -f $hostsAvailable$2 ]; then
						echo "Virtual host '"$2"' does not exist."
					else
						if [ -f $hostsEnabled$2 ]; then
							echo "Virtual host '"$2"' is enabled. You must disable it first."
						else
							removeVirtualHost $2 $3
							if [ ! -f $hostsAvailable$2 ]; then
								echo "Virtual host $2 has been removed."
								echo "*WARNING*:Apache must be restarted before changes take effect."
							else
								echo "Error: virtual host $2 has not been removed."
							fi
						fi
					fi
				fi
			fi
		;;
		-s)
			expected_args=2
			if [ $# -ne $expected_args ]; then
				echo "Number of arguments is incorrect: "$#"."
				showHelp
				exit
			else
				if [ "$2" = "" ] || [ ! -d $2 ]; then
					echo "Second argument is not a valid directory: "$2"."
					showHelp
					exit
				else
					showVirtualHosts $2
				fi
			fi
		;;
		*)
			echo "First argument is incorrect: "$1"."
			showHelp
			exit
		;;
	esac
fi
exit
