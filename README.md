how to produce an SDL2 app running on android API level 19
----------------------------------------------------------

first we clone SDL repo:

    cd ~
    git clone https://github.com/libsdl-org/SDL && cd SDL

checkout the commit that was on top of "main" branch at that time of this
writing:

    git checkout 8e1005f8b00c0ef7d015e20ae9e88eb6bef41242

we copy android-project-ant directory outside the SDL tree with a new name

    cp -r android-project-ant ~/android-hello
    cd ~/android-hello

inside the new source tree are 2 symlinks which now point into nirvana:

    AndroidManifest.xml -> ../android-project/app/src/main/AndroidManifest.xml

in case of AndroidManifest.xml, we remove the symlink and replace it with
the contents of that file in the SDL repo:

    rm -f AndroidManifest.xml
    cp ~/SDL/android-project/app/src/main/AndroidManifest.xml .

the second symlink is:

    src -> ../android-project/app/src/main/java

we remove it, and point it to the right path inside SDL dir.

    rm -f src
    ln -s ~/SDL/android-project/app/src/main/java src

additionally, the entire sourcecode of SDL is expected to live in jni/SDL.
we symlink the git repo there:

    cd jni
    ln -s ~/SDL SDL

next thing we need is a "hello world" application, find it in this repo,
it's main.c, also required is sdl2-bmp.h, put both files into jni/src.

additionally we need to patch some files we copied from SDL, get sdl2.patch
from this repo and run

    cd ~/android-hello
    patch -p1 < SDL2.patch

current SDL2 repo is utterly broken for any android API < 26, so we need
to cd into the SDL repo and check out the latest commit that wasn't broken:

    cd ~/SDL
    git checkout 03ff7dcf6~1


alright, the SDL source and repo is now ready to go, next we need to install
a toolchain.

run install-toolchain.sh from this repo. it assumes an ubuntu install.

    sh install-toolchain.sh

( i used it as regular user on an ubuntu 20.04 rootfs like this:
  https://github.com/sabotage-linux/sabotage/wiki/Running-a-minimal-ubuntu-rootfs-as-regular-user )

this sets up the toolchain in /opt.

go back to android-hello:

    cd ~/android-hello

whenever we need to compile something for android, we need to set up an
environment so the toolchain is found.

copy android-env.sh from this repo into your ~/android-hello directory and
source it into your shell before building:

    source android-env.sh

now you can build the C part of the code via:

    ndk-build V=1

and the java part like this:

    ant debug

or

    ant release

to create a debug or release apk respectively.


