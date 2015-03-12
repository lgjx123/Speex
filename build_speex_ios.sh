#!/bin/sh

VERSION="1.2rc1"
LIB="speex"
LIBS="libspeex.a libspeexdsp.a"

ARCHS="i386 x86_64 armv7 armv7s arm64"
CURRENTPATH=`pwd`
DESTDIR="$LIB-build/ios"
LD_OGG="--with-ogg-libraries=${CURRENTPATH}/libogg-build/ios/ --with-ogg-includes=${CURRENTPATH}/libogg-build/ios/include"

#if [ ! -e "libogg-$VERSION.zip" ]; then
#    curl -LO http://downloads.xiph.org/releases/ogg/libogg-$VERSION.zip
#fi

#unzip -oq libogg-$VERSION.zip
cd $LIB-$VERSION

for ARCH in ${ARCHS}
do
    PREFIX="${CURRENTPATH}/$DESTDIR/$ARCH"

    make distclean

    mkdir -p ${PREFIX}

    if [ "${ARCH}" == "i386" ] || [ "${ARCH}" == "x86_64" ];
    then
        ./configure --prefix=$PREFIX CC="gcc -arch ${ARCH}" $LD_OGG
    else
        HOST="arm-apple-darwin"
        PATH=`xcodebuild -version -sdk iphoneos PlatformPath`"/Developer/usr/bin:$PATH"
        SDK=`xcodebuild -version -sdk iphoneos Path`
        #use gcc --version command
        BUILD="x86_64-apple-darwin14.1.0"

        export CC="clang -arch ${ARCH} -isysroot ${SDK}"
        export CXXFLAGS="$CFLAGS"
        export LDFLAGS="$CFLAGS"
        export LD=$CC

        ./configure --prefix=$PREFIX --host=${HOST} -build=${BUILD} $LD_OGG
    fi

    make && make install

    #   echo "======== CHECK ARCH ========"
    #   lipo -info ${PREFIX}/${LIB}.a
    #   echo "======== CHECK DONE ========"

done

make distclean

cd ..
mkdir -p "${CURRENTPATH}/$DESTDIR"

#copy headers to lib folder from the last ARCH folder
cp -r ${CURRENTPATH}/$DESTDIR/$ARCH/include ${CURRENTPATH}/$DESTDIR

for i in $LIBS;
do
    INPUT=""
    for ARCH in $ARCHS;
    do
        INPUT="$INPUT ${CURRENTPATH}/$DESTDIR/$ARCH/lib/$i"
    done

    lipo -create $INPUT -output ${CURRENTPATH}/$DESTDIR/$i
done

#clear files
for ARCH in $ARCHS;
do
    rm -rf ${CURRENTPATH}/$DESTDIR/$ARCH
done

