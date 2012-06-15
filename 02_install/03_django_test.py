#!/usr/bin/python
import sys, os, django, MySQLdb
# It gets installation directory.
installDir = str(sys.modules['django'])
startIndex = installDir.find("/")
endIndex = installDir.find("'>")
installDir = installDir[startIndex:endIndex]

# It gets database list to test MySQLdb.
print "Type MySQL's root password to test conection."
print "Introduce la password del usuario root de MySQL para probar la conexion."
password = raw_input("Password: ")
db = MySQLdb.connect(host="localhost",user="root", passwd=password)
db.query("""show databases;""")
cursor = db.use_result()

# Output
print "###########################################"
print "#"
print "# 	Django-" + django.get_version() + " has been installed."
print "# 	Django-" + django.get_version() + " instalado."
print "#	" + installDir
print "#	"
print "#	show databases;"
print "#	",
for i in range(4):
	print cursor.fetch_row()[0][0] + " -",
print "\n#"
print "###########################################"
db.close()
print "###########################################"
print "#"
print "# 	End of program."
print "# 	Fin del programa."
print "#"
print "###########################################"
pause = raw_input()
