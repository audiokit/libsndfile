#!/bin/bash
# Build a universal dylib version of libsndfile for iOS

if test $# -lt 1; then
	echo "Usage: $0 dynamic|static"
	exit 1
fi

# Get ready
cd ..
./autogen.sh
./autogen.sh cmake

BUILDCONF=${BUILDCONF:-Release}
if test "$1" == "static";
then
	EXT=a
	STYLE=staticlib
	./configure --disable-shared
else
	EXT=dylib
	STYLE=mh_dylib
	./configure --enable-shared
fi

FLAGS="MACH_O_TYPE=$STYLE"

echo "Building libsndfile.$EXT for iOS, config $BUILDCONF, style $STYLE ..."

cmake . -G Xcode -DCMAKE_BUILD_TYPE=$BUILDCONF || exit 1

(xcodebuild -sdk iphoneos -xcconfig audiokit/device.xcconfig -target sndfile -configuration $BUILDCONF $FLAGS | xcpretty -c) || exit 1
cp src/$BUILDCONF/libsndfile.1.$EXT audiokit/libsndfile-dev.$EXT
(xcodebuild -sdk iphonesimulator -xcconfig audiokit/simulator.xcconfig -target sndfile -configuration $BUILDCONF $FLAGS | xcpretty -c) || exit 1
cp src/$BUILDCONF/libsndfile.1.$EXT audiokit/libsndfile-sim.$EXT

# Combine architectures into the final library
lipo -create audiokit/libsndfile-dev.$EXT audiokit/libsndfile-sim.$EXT -output audiokit/libsndfile.1.$EXT

