#!/bin/bash
# =====================
# project.sh bash script
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
# It must create or remove django projects.
# It uses cd, printf, ls and echo comands.
# =====================
function createDjangoProject {
	projectName=$1 # First argument is project name.
	projectsDirectory=$2 # Second argument is projects directory.
	cd $projectsDirectory
	django-admin.py startproject $projectName
}
function removeDjangoProject {
	projectName=$1 # First argument is project name.
	projectsDirectory=$2 # Second argument is projects directory.
	cd $projectsDirectory
	rm -r $projectName
}
function showDjangoProjects {
	projectsDirectory=$1 # First argument is projects directory.
	if [[ ! $projectsDirectory =~ .*/$ ]]; then
		projectsDirectory=$projectsDirectory"/"
	fi
	printf "%23s    " "PROJECT NAME"; printf "%s\n" "APPLICATIONS";
	for project_directory in `ls $projectsDirectory`; do
		printf "%23s    " $project_directory
		i=0
		for project_app in `ls $projectsDirectory$project_directory`; do
			if [ ! $project_app = "manage.py" ] && [ ! $project_app = $project_directory ] && [ ! $project_app = "documents" ] && [ ! $project_app = "favicon.ico" ] && [ ! $project_app = "logs" ]; then
				if [ $i -ne 0 ]; then
					printf ", "
				fi
				printf "$project_app"
				let i=$i+1
			fi
		done
		printf "\n"
	done
}
function showHelp {
	# If somebody use project.sh in a wrong way, it will show this help.
	echo "Use: project.sh -option project_name projects_directory"
	echo ""
	echo "  -a"
	echo "      Create project_name in projects_directory."
	echo "  -r"
	echo "      Remove project_name from projects_directory."
	echo "  -s"
	echo "      Show projects from projects_directory."
	echo ""
	echo "  Example:"
	echo "      project.sh -a www_mysite_es /usr/local/www/"
	echo "      project.sh -s /usr/local/www/"
	echo ""
}
# MAIN
case $1 in
	-[ar])
		expected_args=3
		if [ $# -ne $expected_args ]; then
			echo "Number of arguments is incorrect: "$#"."
			showHelp
			exit
		else
			if [ ! -d $3 ]; then
				echo "Third argument is not a valid directory: "$3"."
				showHelp
				exit
			else
				if [ $1 = '-a' ]; then
					createDjangoProject $2 $3
					showDjangoProjects $3
				else #if [ $1 = '-r' ]; then
					removeDjangoProject $2 $3
					showDjangoProjects $3
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
			if [ ! -d $2 ]; then
				echo "Second argument is not a valid directory: "$2"."
				showHelp
				exit
			else
				showDjangoProjects $2
			fi
		fi
	;;
	*)
		echo "First argument is incorrect: "$1"."
		showHelp
		exit
	;;
esac
