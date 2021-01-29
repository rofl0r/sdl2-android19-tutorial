set -x
set -e

TARGET_API=14
TARGET_API=18
TARGET_API=19

apt-get -qq update
apt-get install -qqy --no-install-recommends \
  autoconf\
  build-essential \
  cmake \
  curl \
  git \
  jq \
  libncurses5 \
  libtool \
  pkg-config \
  python

# Android NDK, Revision 16b (December 2017) ndkVersion "16.1.4479499"
# https://developer.android.com/ndk/downloads/older_releases

NDK_VERSION=r16b
fn=android-ndk-${NDK_VERSION}-linux-x86_64.zip
test -e "$fn" || \
  wget "https://dl.google.com/android/repository/$fn"
unzip -o -d /opt "$fn" >/dev/null
# rm "$fn"

export NDK_HOME=/opt/android-ndk-${NDK_VERSION}
for arch in arm ; do
    echo Building toolchain for $arch
    $NDK_HOME/build/tools/make_standalone_toolchain.py --force --arch $arch --api $TARGET_API --install-dir $NDK_HOME/platforms/android-${TARGET_API}/$arch
done

# must have been released between android studio 3.0 beta 6 and 7, which have numbers 4333198 and 4365657, respectively
# i.e. between sep 15 and oct 3 2017
SDK_TOOLS_VERSION=4333796
fn=sdk-tools-linux-${SDK_TOOLS_VERSION}.zip
test -e "$fn"  || \
  wget "https://dl.google.com/android/repository/$fn"
mkdir -p /opt/android-sdk
unzip -o -d /opt/android-sdk "$fn" >/dev/null
# rm "$fn"

OPENJDK_VERSION=openjdk8
fn=$OPENJDK_VERSION.tar.gz
test -e "$fn" || \
curl -fLSs "$(curl -fLSs "https://api.adoptopenjdk.net/v2/info/releases/${OPENJDK_VERSION}?os=linux&arch=x64&release=latest&openjdk_impl=hotspot&type=jdk" | \
  jq -r .binaries[0].binary_link)" > $fn
tar -f $OPENJDK_VERSION.tar.gz -xzC /opt
# rm "$fn"

BUILD_TOOLS_VERSION=29.0.2
PLATFORM_VERSION=android-${TARGET_API}
echo y | JAVA_HOME=$(echo /opt/jdk*) /opt/android-sdk/tools/bin/sdkmanager \
"build-tools;${BUILD_TOOLS_VERSION}" \
"platforms;${PLATFORM_VERSION}" \
platform-tools

BUILD_TOOLS_ANT_VERSION=25.2.5
fn=tools_r${BUILD_TOOLS_ANT_VERSION}-linux.zip
test -e "$fn" || 
	wget "https://dl.google.com/android/repository/$fn"
unzip -o -d /opt/android-sdk "$fn" >/dev/null
rm "$fn"

ANT_VERSION=1.10.7
# fixme: download for 1.10.7 was deleted from server

ANT_VERSION=1.10.9
fn=apache-ant-${ANT_VERSION}-bin.tar.gz
test -e "$fn" || \
  wget https://www.apache.org/dist/ant/binaries/$fn
tar -f "$fn" -xzC /opt
# rm "$fn"



