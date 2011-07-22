#/bin/bash 

PRODUCT="$1"
VERSION="$2"
OUTDIR="out/"

if ( [ $PRODUCT == "galaxys2" ] && [ ! $VERSION == "" ])
then

case $PRODUCT in
        galaxys2 )
            PRODUCTNAME="GalaxyS2"
            ;;
esac

	if [ -f radio/modems/$VERSION/modem.bin ]
	then
    		rm -rf temp/
		mkdir temp

		echo "Copying tools for radiopackage ..."
		cp -R radio/updater/* temp/

		echo "Copying radio image ..."
		cp -R radio/modems/$VERSION/modem.bin temp/

		echo "Removing .git files"
		find temp/ -name '.git' -exec rm -r {} \;

		echo "Compressing radiopackage ..."
		pushd temp
		zip -r ../$OUTDIR/radio-cm-7-$PRODUCTNAME-$VERSION-unsigned.zip ./
		popd

		echo "Signing radiopackage ..."
		java -jar SignApk/signapk.jar SignApk/certificate.pem SignApk/key.pk8 $OUTDIR/radio-cm-7-$PRODUCTNAME-$VERSION-unsigned.zip $OUTDIR/radio-cm-7-$PRODUCTNAME-$VERSION-signed.zip

		rm $OUTDIR/radio-cm-7-$PRODUCTNAME-$VERSION-unsigned.zip
		rm -rf temp/
		echo "radio-cm-7-$PRODUCTNAME-$VERSION-signed.zip is at $OUTDIR"
		echo "Done."
	else
		echo "Unsupported radio version: $VERSION"
		exit
	fi
else
	echo -e "\n";
	echo "USAGE: radio.sh DEVICE RADIO";
	echo "EXAMPLE: radio.sh galaxys2 KG2";
	echo "Supported Devices: galaxys2";
	echo "Supported Versions:";
	ls radio/modems/
	echo -e "\n";
fi

