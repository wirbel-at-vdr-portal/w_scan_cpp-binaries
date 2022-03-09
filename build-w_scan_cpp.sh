#! /bin/sh
start=$(date +%s)

echo "Raspberry Pi OS (32bit/64bit bullseye; January 28th 2022) install script for w_scan_cpp"

cd /usr/src



## /* require either PKG_CONFIG_PATH to be set, or, a working pkg-config */
HAVE_LIBJPEG=$(if pkg-config --exists libjpeg; then echo "1"; else echo "0"; fi )
HAVE_FREETYPE2=$(if pkg-config --exists freetype2; then echo "1"; else echo "0"; fi )
HAVE_FONTCONFIG=$(if pkg-config --exists fontconfig; then echo "1"; else echo "0"; fi )
HAVE_LIBPUGIXML=$(if pkg-config --exists pugixml; then echo "1"; else echo "0"; fi )
HAVE_CURL=$(if pkg-config --exists libcurl; then echo "1"; else echo "0"; fi )
HAVE_LIBCAP=$(if pkg-config --exists libcap; then echo "1"; else echo "0"; fi )
HAVE_LIBREPFUNC_MINVERSION=$(if pkg-config --atleast-version=1.1.0 librepfunc; then echo "1"; else echo "0"; fi )


echo "HAVE_LIBJPEG               = $HAVE_LIBJPEG"
echo "HAVE_FREETYPE2             = $HAVE_FREETYPE2"
echo "HAVE_FONTCONFIG            = $HAVE_FONTCONFIG"
echo "HAVE_LIBPUGIXML            = $HAVE_LIBPUGIXML"
echo "HAVE_CURL                  = $HAVE_CURL"
echo "HAVE_LIBCAP                = $HAVE_LIBCAP"
echo "HAVE_LIBREPFUNC_MINVERSION = $HAVE_LIBREPFUNC_MINVERSION"

echo "***** build time will be about 30 minutes. *****"
sleep 10

#-------------------------------------------------
if [ $HAVE_LIBJPEG = "0" ]; then
   echo "installing libjpeg62-turbo-dev"
   sleep 5
   sudo apt install libjpeg62-turbo-dev -y
fi
#-------------------------------------------------
if [ $HAVE_FREETYPE2 = "0" ]; then
   echo "installing libfreetype-dev"
   sleep 5
   sudo apt install libfreetype-dev -y
fi
#-------------------------------------------------
if [ $HAVE_FONTCONFIG = "0" ]; then
   echo "installing libfontconfig-dev"
   sleep 5
   sudo apt install libfontconfig-dev -y
fi
#-------------------------------------------------
if [ $HAVE_LIBPUGIXML = "0" ]; then
   echo "installing libpugixml-dev"
   sleep 5
   sudo apt install libpugixml-dev -y
fi
#-------------------------------------------------
if [ $HAVE_CURL = "0" ]; then
   echo "installing libcurl4-openssl-dev"
   sleep 5
   sudo apt install libcurl4-openssl-dev -y
fi
#-------------------------------------------------
if [ $HAVE_LIBCAP = "0" ]; then
   echo "installing libcap-dev"
   sleep 5
   sudo apt install libcap-dev -y
fi
#-------------------------------------------------
if [ $HAVE_LIBREPFUNC_MINVERSION = "0" ]; then
   echo "installing librepfunc-git"
   DATE=$(date +%Y%m%d)
   MACHINE=$(uname -m)
   sleep 5
   sudo git clone https://github.com/wirbel-at-vdr-portal/librepfunc.git
   cd librepfunc
   sudo make install
   sudo mkdir -p ./usr/lib/pkgconfig
   sudo mkdir -p ./usr/include
   sudo mkdir -p ./usr/
   sudo mkdir -p ./usr/doc
   sudo mkdir -p ./usr/man1
   sudo install -m 755 librepfunc.so* ./usr/lib
   sudo install -m 644 repfunc.h      ./usr/include
   sudo install -m 644 COPYING README ./usr/doc
   sudo install -m 644 librepfunc.pc  ./usr/lib/pkgconfig
   sudo tar -cjf librepfunc-$DATE-binary-$MACHINE.tar.bz2 ./usr
   sudo mv librepfunc-$DATE-binary-$MACHINE.tar.bz2 ..
   cd ..
   sudo rm -r librepfunc
fi
#-------------------------------------------------
echo "installing w_scan_cpp-git"
sleep 5
sudo git clone https://github.com/wirbel-at-vdr-portal/w_scan_cpp.git
cd w_scan_cpp
sudo make download
sudo make install
sudo make binary
sudo mv w_scan_cpp-20*-binary* ..
cd ..
sudo rm -r w_scan_cpp

stop=$(date +%s)
runtime=$((stop-start))

echo "***** END: script runtime was $runtime seconds. *****"
