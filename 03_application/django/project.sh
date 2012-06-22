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
# It uses cd, printf, ls, sed and echo comands.
# =====================
function createDjangoProject {
	projectName=$1 # First argument is project name.
	projectsDirectory=$2 # Second argument is directory of all projects.
	cd $projectsDirectory
	django-admin.py startproject $projectName
	stringPath='    os.path.join(os.path.dirname(__file__) , "documents").replace("\\\\","/").replace("'$projectName'/'$projectName'","'$projectName'"),'
	sed -i -e '1a\import os.path' -e '/^TEMPLATE_DIRS = ($/a\'"$stringPath" $projectName"/"$projectName"/settings.py"
}
function removeDjangoProject {
	projectName=$1 # First argument is project name.
	projectsDirectory=$2 # Second argument is directory of all projects.
	cd $projectsDirectory
	rm -r $projectName
}
function createApp {
	appName=$1 # First argument is app name.
	projectPath=$2 # Second argument is project path.
	if [[ ! $projectPath =~ .*/$ ]]; then
		projectPath=$projectPath"/"
	fi
	cd $projectPath
	python manage.py startapp $appName
	sed -i -e '/^INSTALLED_APPS = ($/a\    "'"$appName"'",' $projectPath"/"`basename $projectPath`"/settings.py"
}
function removeApp {
	appName=$1 # First argument is app name.
	projectPath=$2 # Second argument is project path.
	if [[ ! $projectPath =~ .*/$ ]]; then
		projectPath=$projectPath"/"
	fi
	cd $projectPath
	rm -r $appName
	sed -i -e '/^    "'"$appName"'",$/d' $projectPath"/"`basename $projectPath`"/settings.py"
}
function showDjangoProjects {
	projectsDirectory=$1 # First argument is directory of all projects.
	if [[ ! $projectsDirectory =~ .*/$ ]]; then
		projectsDirectory=$projectsDirectory"/"
	fi
	printf "%-23s    " "PROJECT NAME"; printf "%s\n" "APPLICATIONS";
	for element in `ls $projectsDirectory`; do
		if [ -f $projectsDirectory$element"/"$element"/__init__.py" ]; then
			printf "\n%-23s    " $element
			block=`sed -n -e '/^INSTALLED_APPS = ($/,/^)$/p' $projectsDirectory$element"/"$element"/settings.py" | sed -e '/^INSTALLED_APPS = ($/d' -e '/^)$/d' -e '/^    #/d'`
			i=0
			for project_app in $block; do
				if [ $i -ne 0 ]; then
					printf "\n%-23s    " " "
				fi
				printf "%s" "$project_app"
				let i=$i+1
			done
			printf "\n"
		fi
	done
}
function showHelp {
	# If somebody use project.sh in a wrong way, it will show this help.
	echo "Use: project.sh -option [project_name|app_name] [projects_directory|project_path]"
	echo ""
	echo "  -a"
	echo "      Create project_name in projects_directory."
	echo "  -m"
	echo "      Modify project in project_path. It adds or removes application app_name. If the application exits, it will be removed. If it does not exist, it will be created."
	echo "  -r"
	echo "      Remove project_name from projects_directory."
	echo "  -s"
	echo "      Show projects from projects_directory."
	echo ""
	echo "  Example:"
	echo "      project.sh -a www_mysite_es /usr/local/www/"
	echo "      project.sh -s /usr/local/www/"
	echo "      project.sh -m myapp /usr/local/www/www_mysite_es"
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
			if [ "$3" = "" ] || [ ! -d $3 ]; then
				echo "Third argument is not a valid directory: "$3"."
				showHelp
				exit
			else
				if [ $1 = '-a' ]; then
					if [[ ! $3 =~ .*/$ ]]; then
						directoryProject=$3"/"
					else
						directoryProject=$3
					fi
					if [ -d $directoryProject$2 ]; then
						echo "Error: Django project $2 already exists."
					else
						createDjangoProject $2 $3
						if [ -d $directoryProject$2 ]; then
							echo "Django project $2 has been created."
						else
							echo "Error: Django project $2 has not been created."
						fi
					fi
				else #if [ $1 = '-r' ]; then
					if [[ ! $3 =~ .*/$ ]]; then
						directoryProject=$3"/"
					else
						directoryProject=$3
					fi
					if [ "$directoryProject$2" = "" ] || [ ! -d $directoryProject$2 ]; then
						echo "Error: Django project $2 does not exist."
					else
						removeDjangoProject $2 $3
						if [ ! -d $directoryProject$2 ]; then
							echo "Django project $2 has been removed."
						else
							echo "Error: Django project $2 has not been removed."
						fi
					fi
				fi
			fi
		fi
	;;
	-m)
		if [ "$3" = "" ] || [ ! -d $3 ] || [ ! -f "$3/manage.py" ]; then
			echo "Third argument is not a valid project directory: "$3"."
			showHelp
			exit
		else
			if [ "$2" = "" ]; then
				echo "Second argument is not a valid application name: $2."
				showHelp
				exit
			else
				if [ ! -d $3"/"$2 ]; then
					createApp $2 $3
					if [ -d $3"/"$2 ]; then
						echo "The application '$2' has been added to '"`basename $3`"' project."
					else
						echo "Error: The application '$2' has not been added to '"`basename $3`"' project."
					fi
				else
					removeApp $2 $3
					if [ ! -d $3"/"$2 ]; then
						echo "The application '$2' has been removed from '"`basename $3`"' project."
					else
						echo "Error: The application '$2' has not been removed from '"`basename $3`"' project."
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
