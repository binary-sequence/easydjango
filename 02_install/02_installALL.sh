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
sudo mkdir "/usr/local/www"
echo "###########################################"
echo "#"
echo "# 	/usr/local/www directory has been created."
echo "# 	Directorio /usr/local/www creado."
echo "#"
echo "###########################################"
sudo chgrp easydjango "/usr/local/www"
echo "###########################################"
echo "#"
echo "# 	Group of /usr/local/www directory has been changed to 'easydjango'."
echo "# 	Grupo del directorio /usr/local/www cambiado a 'easydjango'."
echo "#"
echo "###########################################"
sudo chmod 775 "/usr/local/www"
echo "###########################################"
echo "#"
echo "# 	Permissions of /usr/local/www directory has been changed to '775'."
echo "# 	Permisos de directorio /usr/local/www cambiados a '775'."
echo "#"
echo "###########################################"
echo ""
echo "###########################################"
echo "#"
echo "# 	End of program."
echo "# 	You must logout and login again before all changes take efect."
echo "# 	Fin del programa."
echo "# 	Debes cerrar sesión y volver a entrar para que todos los cambios funcionen."
echo "#"
echo "###########################################"
read pause
