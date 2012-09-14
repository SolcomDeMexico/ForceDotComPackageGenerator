#generatePackage.sh
echo "***************************************"
echo "***** Generacion de package.xml *******"
echo "***************************************"

echo "=== INICIO ==="

	echo "=== Removiendo metadata.txt ..."
	rm -f metadata.txt
	echo "=== Removiendo listMetadata.sh ..."
	rm -f listMetadata.sh
	echo "=== Removiendo package.xml ..."
	rm -f package.xml
	echo "=== Removiendo folder listMetadata ..."
	rm -rf listMetadata
	echo "=== Removiendo folder src ..."
	rm -rf src
	
	echo "=== Obteneniendo los tipos de metadato soportados en la ORG ..."
	ant describeMetadata
	echo "=== Obteniendo los folders de la ORG ..."
	ruby generatePackageUtility.rb 1
	echo "=== Creando la carpeta listMetadata ..."
	mkdir listMetadata
	echo "=== Obteniendo los metadatos de cada tipo soportado por la ORG ...."
	listMetadataScript.sh
	echo "=== Generando el archivo package.xml"
	ruby generatePackageUtility.rb 2
	echo "=== Creando la carpeta src ..."
	mkdir src
	echo "=== Obteniendo metadatos de la ORG ..."
	ant retrieve

echo "=== FIN ==="
	
	
	