#!/bin/bash -

# Var
DATE=$(date +%Y%m%d)
DIR='/data/scripts/monitoring/'
TIPE='icube-prod'
HTTP='https://'
CLIENT='www.blueprintfurniture.com'
RES='1920px'
ORI='blueprintfurniture-20180202.jpg'

# Exec
cd $DIR$TIPE
phantomjs ../js/rasterize.js $HTTP$CLIENT $CLIENT-$DATE.jpg $RES

# Dif
I=`wc -c $ORI | cut -d' ' -f1`
J=`wc -c $CLIENT-$DATE.jpg | cut -d' ' -f1`
if [ $I -eq $J ]; then
 rm $CLIENT &>/dev/null
 exit 1
elif [ -e $CLIENT ]; then
K=`find '$CLIENT' -mmin +60`
 if [ K ]
 then
  exit 2
 else
  echo '1' > $CLIENT
  echo 'Please check '$HTTP$CLIENT' , seems like the website is changed 1' | mutt -a $CLIENT-$DATE.jpg -s 'Please Check '$HTTP$CLIENT -- widyamedia@gmail.com
 fi
else
 echo '2' > $CLIENT
 echo 'Please check '$HTTP$CLIENT' , seems like the website is changed n' | mutt -a $CLIENT-$DATE.jpg -s 'Please Check '$HTTP$CLIENT -- widyamedia@gmail.com
# Clean Up
find . -type f -iname $CLIENT'.jpg' -mtime +6 -exec rm {} \;
fi
