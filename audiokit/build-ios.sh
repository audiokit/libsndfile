#!/bin/bash
# Build a universal dylib version of libsndfile for iOS

if test $# -lt 1; then
	echo "Usage: $0 dynamic|static"
	exit 1
fi


BUILDCONF=${BUILDCONF:-Release}
if test "$1" == "static";
then
	EXT=a
	TARGET=sndfile_static
else
	EXT=dylib
	TARGET=sndfile
fi

echo "Building libsndfile.$EXT for iOS, config $BUILDCONF ..."

# Get ready
cd ..
./autogen.sh
./autogen.sh cmake
./configure

cmake . -G Xcode -DCMAKE_BUILD_TYPE=$BUILDCONF || exit 1

(xcodebuild -sdk iphoneos -xcconfig audiokit/device.xcconfig -target $TARGET -configuration $BUILDCONF | xcpretty -c) || exit 1
cp src/$BUILDCONF/lib$TARGET.$EXT audiokit/libsndfile-dev.$EXT
(xcodebuild -sdk iphonesimulator -xcconfig audiokit/simulator.xcconfig -target $TARGET -configuration $BUILDCONF | xcpretty -c) || exit 1
cp src/$BUILDCONF/lib$TARGET.$EXT audiokit/libsndfile-sim.$EXT

# Combine architectures into the final library
lipo -create audiokit/libsndfile-dev.$EXT audiokit/libsndfile-sim.$EXT -output audiokit/libsndfile.1.$EXT

