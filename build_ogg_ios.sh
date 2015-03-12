#!/bin/sh

VERSION="1.3.2"
LIB="libogg"

ARCHS="i386 x86_64 armv7 armv7s arm64"
CURRENTPATH=`pwd`
DESTDIR="libogg-build/ios"

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
        ./configure --prefix=$PREFIX CC="gcc -arch ${ARCH}"
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

        ./configure --prefix=$PREFIX --host=${HOST} -build=${BUILD}
    fi

    make && make install

    #   echo "======== CHECK ARCH ========"
    #   lipo -info ${PREFIX}/${LIB}.a
    #   echo "======== CHECK DONE ========"

done

make distclean

cd ..
mkdir -p "${CURRENTPATH}/$DESTDIR"

#copy headers to lib folder from i386 folder
cp -r ${CURRENTPATH}/$DESTDIR/$ARCH/include ${CURRENTPATH}/$DESTDIR

INPUT=""
for ARCH in $ARCHS;
do
    INPUT="$INPUT ${CURRENTPATH}/$DESTDIR/$ARCH/lib/$LIB.a"
done

lipo -create $INPUT -output ${CURRENTPATH}/$DESTDIR/$LIB.a

#clear files
for ARCH in $ARCHS;
do
rm -rf ${CURRENTPATH}/$DESTDIR/$ARCH
done

