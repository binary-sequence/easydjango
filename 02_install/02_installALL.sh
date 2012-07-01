#!/bin/bash
sudo apt-get install sed
echo "###########################################"
echo "#"
echo "# 	Sed has been installed."
echo "# 	Sed instalado."
echo "#"
echo "###########################################"
sudo apt-get install grep
echo "###########################################"
echo "#"
echo "# 	Grep has been installed."
echo "# 	Grep instalado."
echo "#"
echo "###########################################"
sudo apt-get install python
echo "###########################################"
echo "#"
echo "# 	Python has been installed."
echo "# 	Python instalado."
echo "#"
echo "###########################################"
sudo apt-get install apache2 # It comes with a2dissite and a2ensite commands.
echo "###########################################"
echo "#"
echo "# 	Apache2 has been installed."
echo "# 	Apache2 instalado."
echo "#"
echo "###########################################"
sudo apt-get install libapache2-mod-wsgi
echo "###########################################"
echo "#"
echo "# 	libapache2-mod-wsgi has been installed."
echo "# 	libapache2-mod-wsgi instalado."
echo "#"
echo "###########################################"
sudo apt-get install mysql-server
echo "###########################################"
echo "#"
echo "# 	mysql-server has been installed."
echo "# 	mysql-server instalado."
echo "#"
echo "###########################################"
tar xzvf Django-1.4.tar.gz
cd "Django-1.4/"
sudo python setup.py install
echo "###########################################"
echo "#"
echo "# 	Django has been installed."
echo "# 	Django instalado."
echo "#"
echo "###########################################"
sudo apt-get install python-mysqldb
echo "###########################################"
echo "#"
echo "# 	python-mysqldb has been installed."
echo "# 	python-mysqldb instalado."
echo "#"
echo "###########################################"
sudo addgroup easydjango
echo "###########################################"
echo "#"
echo "# 	easydjango group has been created."
echo "# 	Grupo easydjango creado."
echo "#"
echo "###########################################"
djangoProjectsPath="/usr/local/easydjango"
sudo mkdir "$djangoProjectsPath"
echo "###########################################"
echo "#"
echo "# 	$djangoProjectsPath directory has been created."
echo "# 	Directorio $djangoProjectsPath creado."
echo "#"
echo "###########################################"
sudo chgrp easydjango "$djangoProjectsPath"
echo "###########################################"
echo "#"
echo "# 	Group of $djangoProjectsPath directory has been changed to 'easydjango'."
echo "# 	Grupo del directorio $djangoProjectsPath cambiado a 'easydjango'."
echo "#"
echo "###########################################"
sudo chmod 775 "$djangoProjectsPath"
echo "###########################################"
echo "#"
echo "# 	Permissions of $djangoProjectsPath directory has been changed to '775'."
echo "# 	Permisos de directorio $djangoProjectsPath cambiados a '775'."
echo "#"
echo "###########################################"
echo ""
echo "###########################################"
echo "#"
echo "# 	End of program."
echo "# 	Fin del programa."
echo "#"
echo "###########################################"
read pause
