#!/bin/sh
 
#get the bundle's MacOS directory full path
DIR=$(cd "$(dirname "$0")"; pwd)
 
#change these values to match your app
EXE_PATH="$DIR\nzbdrone.exe"
APPNAME="Sonarr"
 
#set up environment
MONO_FRAMEWORK_PATH=/Library/Frameworks/Mono.framework/Versions/Current
export DYLD_FALLBACK_LIBRARY_PATH="$DIR:$MONO_FRAMEWORK_PATH/lib:/lib:/usr/lib"
export PATH="$MONO_FRAMEWORK_PATH/bin:$PATH"
 
#mono version check
REQUIRED_MAJOR=3
REQUIRED_MINOR=10
 
VERSION_TITLE="Cannot launch $APPNAME"
VERSION_MSG="$APPNAME requires Mono Runtime Environment (MRE) $REQUIRED_MAJOR.$REQUIRED_MINOR or later."
DOWNLOAD_URL="http://www.mono-project.com/download/#download-mac"
 
MONO_VERSION="$(mono --version | grep 'Mono JIT compiler version ' |  cut -f5 -d\ )"
MONO_VERSION_MAJOR="$(echo $MONO_VERSION | cut -f1 -d.)"
MONO_VERSION_MINOR="$(echo $MONO_VERSION | cut -f2 -d.)"
if [ -z "$MONO_VERSION" ] \
    || [ $MONO_VERSION_MAJOR -lt $REQUIRED_MAJOR ] \
    || [ $MONO_VERSION_MAJOR -eq $REQUIRED_MAJOR -a $MONO_VERSION_MINOR -lt $REQUIRED_MINOR ] 
then
    osascript \
    -e "set question to display dialog \"$VERSION_MSG\" with title \"$VERSION_TITLE\" buttons {\"Cancel\", \"Download...\"} default button 2" \
    -e "if button returned of question is equal to \"Download...\" then open location \"$DOWNLOAD_URL\""
    echo "$VERSION_TITLE"
    echo "$VERSION_MSG"
    exit 1
fi
 
MONO_EXEC="exec mono --debug"
 
#run app using mono
$MONO_EXEC --debug "$EXE_PATH"