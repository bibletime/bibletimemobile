

VERSION=$1
INCREMENT=$2
INPATH=$3
OUTPATH=$4

echo VERSION: $VERSION
echo INCREMENT: $INCREMENT

VCODE=$(echo "$VERSION * 10 + $INCREMENT" |bc)
echo versionCode: $VCODE

VNAME=$(echo "scale=2;$VERSION/100" |bc)
echo versionName: $VNAME

[ -d $OUTPATH ] || mkdir $OUTPATH


sed -e "s/\$\$VCODE/$VCODE/" -e "s/\$\$VNAME/$VNAME/" < $INPATH/AndroidManifest.xml >$OUTPATH/AndroidManifest.xml

cp -r $INPATH/res $OUTPATH

