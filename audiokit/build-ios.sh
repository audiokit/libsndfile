#!/bin/bash
#
# Build a universal version of libsndfile for iOS suitable to use within AudioKit projects.
#
# (C) 2015 Stephane Peter 
#

if test $# -lt 1; then
	echo "Usage: $0 dynamic|static"
	exit 1
fi

# Default: AudioKit in the same parent directory as libsndfile
AK_ROOT=${AK_ROOT:-$PWD/../../AudioKit/AudioKit/Platforms/iOS}

BUILDCONF=${BUILDCONF:-Release}
if test "$1" == "static";
then
	EXT=.a
	TARGET=sndfile_static
else
	EXT=.dylib
	TARGET=sndfile
fi

echo "Building libsndfile$EXT for iOS, config $BUILDCONF ..."

# Get ready
cd ..
./autogen.sh
./autogen.sh cmake
./configure || exit 1

cmake . -G Xcode -DCMAKE_BUILD_TYPE=$BUILDCONF || exit 1

(xcodebuild -sdk iphonesimulator -xcconfig audiokit/simulator.xcconfig -target $TARGET -configuration $BUILDCONF | xcpretty -c) || exit 1
# In Travis CI, don't try to build the device library since we can't sign it
test "$NOCOPY" == 1 && exit

cp src/$BUILDCONF/lib$TARGET$EXT audiokit/libsndfile-sim$EXT || exit 2
(xcodebuild -sdk iphoneos -xcconfig audiokit/device.xcconfig -target $TARGET -configuration $BUILDCONF | xcpretty -c) || exit 1
cp src/$BUILDCONF/lib$TARGET$EXT audiokit/libsndfile-dev$EXT || exit 2


# Combine architectures into the final library
lipo -create audiokit/libsndfile-dev$EXT audiokit/libsndfile-sim$EXT -output audiokit/libsndfile$EXT || exit 3

# Copy the file to the AudioKit image
if test "$1" == "static";
then
	cp -v audiokit/libsndfile$EXT $AK_ROOT/libs/
else
	install_name_tool -id libsndfile audiokit/libsndfile$EXT
        cp -v audiokit/libsndfile$EXT $AK_ROOT/libsndfile.framework/libsndfile
fi

echo "Success!"

