#!/bin/bash
# =====================
# listen.sh bash script
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
# It must add or remove listen ports directives from file ports.conf.
# It uses sed, tail, echo and grep comands.
# =====================
function addListenPort {
	port=$1 # First argument is port number.
	ports_file=$2 # Second argument is absolute path of ports apache config file.
	# It gets the position which will be used for append the new line.
	position=`sed -n -e "/^Listen .*$/=" $ports_file | tail -n1`
	# It add directives in the correct position.
	sed -i -e $position"a\Listen $port" $ports_file
}
function removeListenPort {
	port=$1 # First argument is port number.
	ports_file=$2 # Second argument is absolute path of ports apache config file.
	# It removes directives that match with the port given.
	sed -i -e "/^Listen $port$/d" $ports_file
}
function showHelp {
	# If somebody use listen.sh in a wrong way, it will show this help.
	echo "Use: listen.sh -option [port_number] apache_config_file"
	echo ""
	echo "  -a"
	echo "      Add directives to listen on [port_number] in file apache_config_file."
	echo "  -r"
	echo "      Remove directives to stop listening on [port_number] from apache_config_file."
	echo "  -s"
	echo "      Show active listen ports from apache_config_file."
	echo ""
	echo "  Example:"
	echo "      listen.sh -a 8080 /etc/apache2/ports.conf"
	echo "      listen.sh -s /etc/apache2/ports.conf"
	echo ""
}
# MAIN
min_expected_args=2
max_expected_args=3
if [ $# -lt $min_expected_args ] || [ $# -gt $max_expected_args ]; then
	echo "Number of arguments is incorrect: "$#"."
	showHelp
	exit
else
	case "$1" in
		-[ar])
			if [[ ! "$2" =~ ^[1-9][0-9]*$ ]]; then
				echo "Second argument is not a valid positive number: "$2"."
				showHelp
			else
				if [ ! -f $3 ]; then
					echo "Third argument is not a valid file: "$3"."
					showHelp
				else
					if [ $1 = '-a' ]; then
						if [ `grep -c "^Listen "$2"$" $3` -ne 0 ]; then
							echo "Apache was already listening on port "$2"."
						else
							addListenPort $2 $3
							if [ `grep -c "^Listen "$2"$" $3` -eq 1 ]; then
								echo "Port $2 has been added."
								echo "*WARNING*:Apache must be restarted before changes take effect."
							else
								echo "Error: port $2 has not been added."
							fi
						fi
					else # if [ $1 = '-r' ]; then
						if [ `grep -c "^Listen "$2"$" $3` -eq 0 ]; then
							echo "Apache is not listening on port "$2"."
						else
							if [ `grep -c "^Listen .*$" $3` -eq 1 ]; then
								echo "You cannot remove the last listen port. Add another listen port before."
							else
								removeListenPort $2 $3
								if [ `grep -c "^Listen "$2"$" $3` -eq 0 ]; then
									echo "Port $2 has been removed."
									echo "*WARNING*:Apache must be restarted before changes take effect."
								else
									echo "Error: port $2 has not been removed."
								fi
							fi
						fi
					fi
				fi
			fi
		exit;;
		-s)
			if [ ! -f $2 ]; then
				echo "Second argument is not a valid file: "$2"."
				showHelp
				exit
			else
				echo 'Apache is listening on ports:'
				sed -n -e '/^Listen /p' $2 | cut -f2 -d\ 
			fi
		exit;;
		*)
			echo "First argument is incorrect: "$1"."
			showHelp
		exit;;
	esac
fi
exit
