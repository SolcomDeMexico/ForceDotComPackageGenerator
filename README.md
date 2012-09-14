Force.com Package Generator
===========================
Herramienta que sirve para generar archivo package.xml con los contenidos de una ORG.

Configuracion
==============
1. Modificar el archivo build.properties con las credenciales de la ORG de donde se desea obtener el archivo package.xml
2. En la ORG de donde se desea obtener el archivo package.xml crear un "Acceso Remoto" y obtener el client_id y client_secret (OAuth)
3. Modificar en la parte superior del archivo generatePackageUtility.rb con los atributos: client_id, client_secret, username y password.

Operacion
=========
1. Ejecutar el comando generatePackage.sh
2. Obtener el archivo package.xml de la carpeta "src"

