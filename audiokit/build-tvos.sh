#!/bin/bash
#
# Build a universal version of libsndfile for tvOS suitable to use within AudioKit projects.
#
# (C) 2015 Stephane Peter 
#

# Default: AudioKit in the same parent directory as libsndfile
AK_ROOT=${AK_ROOT:-$PWD/../../AudioKit/AudioKit/Platforms/tvOS}

XCPRETTY="xcpretty -c"
#XCPRETTY=cat

BUILDCONF=${BUILDCONF:-Release}
EXT=.dylib
TARGET=sndfile

echo "Building libsndfile$EXT for tvOS, config $BUILDCONF ..."

# Get ready
cd ..
./autogen.sh
./autogen.sh cmake
./configure || exit 1

cmake . -G Xcode -DCMAKE_BUILD_TYPE=$BUILDCONF || exit 1

(xcodebuild -sdk appletvsimulator -xcconfig audiokit/tvsimulator.xcconfig -target $TARGET -configuration $BUILDCONF | $XCPRETTY) || exit 1
# In Travis CI, don't try to build the device library since we can't sign it
test "$NOCOPY" == 1 && exit

cp src/$BUILDCONF/lib$TARGET$EXT audiokit/libsndfile-tvsim$EXT || exit 2
(xcodebuild -sdk appletvos -xcconfig audiokit/tvdevice.xcconfig -target $TARGET -configuration $BUILDCONF | $XCPRETTY) || exit 1
cp src/$BUILDCONF/lib$TARGET$EXT audiokit/libsndfile-tvdev$EXT || exit 2


# Combine architectures into the final library
lipo -create audiokit/libsndfile-tvdev$EXT audiokit/libsndfile-tvsim$EXT -output audiokit/libsndfile-tv$EXT || exit 3

# Copy the file to the AudioKit image
install_name_tool -id libsndfile audiokit/libsndfile-tv$EXT
cp -v audiokit/libsndfile-tv$EXT $AK_ROOT/libsndfile.framework/libsndfile

echo "Success!"

