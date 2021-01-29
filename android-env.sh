export ROOTFS=/root/android-root-armeabi-v7

NDK_VERSION=r16b
PLATFORM=android-14
PLATFORM=android-18
PLATFORM=android-19


export NDK_HOME=/opt/android-ndk-r16b
export PATH="$PATH":/opt/android-ndk-r16b/platforms/${PLATFORM}/arm/bin/:/opt/android-ndk-r16b
# the latter is only for ndk-build which runs /opt/android-ndk-r16b/build/ndk-build
# which in turn sets a couple vars and runs `make -f $PROGDIR/core/build-local.mk "$@"`


export NDK_STANDALONE=$NDK_HOME/platforms/$PLATFORM

export NDK_PLATFORM_ROOT=$NDK_STANDALONE/arm
export NDK_PLATFORM_NAME=armeabi-v7a
export NDK_HOST_NAME=arm-linux-androideabi

#export NDK_ADDITIONAL_LIBRARY_PATH=$(get_abs_path "../../nativelibs/$NDK_PLATFORM_NAME")
#export PKG_CONFIG_PATH=$NDK_ADDITIONAL_LIBRARY_PATH/lib/pkgconfig
#export ACLOCAL_PATH=$NDK_ADDITIONAL_LIBRARY_PATH/share/aclocal
#export PATH=$NDK_PLATFORM_ROOT/bin:$PATH

export PKG_CONFIG_PATH=$ROOTFS/lib/pkgconfig                                                     
export ACLOCAL_PATH=$ROOTFS/share/aclocal                                                        
                                                                                                                       
export NDK_CFLAGS=" -mthumb -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -D__ANDROID_API__=\$API"
export NDK_LDFLAGS=" -march=armv7-a -Wl,--fix-cortex-a8"
export CC=$NDK_PLATFORM_ROOT/bin/arm-linux-androideabi-gcc
export CXX=$NDK_PLATFORM_ROOT/bin/arm-linux-androideabi-g++

export ANDROID_HOME=/opt/android-sdk
export JAVA_HOME=$(echo /opt/jdk*)
export PATH=$PATH:$JAVA_HOME/bin
# make ant binary available
export PATH=$PATH:$(echo /opt/apache-ant-*/bin)

