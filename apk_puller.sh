#!/bin/bash


apk_pull_all(){
    for package in $(adb shell pm list packages | tr -d '\r' | sed 's/package://g'); do
        apk=$(adb shell pm path $package | tr -d '\r' | head -n 1 | sed 's/package://g');
        echo "pulling $apk";
        adb pull -p "$apk" $package.apk;
    done    
}

apk_pull(){
    package=$1
	package_path=$(adb shell pm path "$package" | tr -d '\r' | head -n 1 | sed 's/package://g');

    if [ -z "$package_path" ]; then
		echo "package not found: $package";
		exit
	fi

    echo "pulling $package_path";
    adb pull -p "$package_path" $package.apk;

}

if [ ! -z $1 ]&&[ $1 == "pull" ]; then
    if [ -z "$2" ]; then
    	echo "package name not input"
    	echo "./apk_puller.sh pull <package_name>"
		exit
	fi
    package_name=$2
	apk_pull "$package_name"
elif [ ! -z $1 ]&&[ $1 == "all" ]; then
    apk_pull_all
else
    echo "error"
    echo "./apk_puller.sh pull <package_name>"
    echo "./apk_puller.sh all"
    exit
fi
