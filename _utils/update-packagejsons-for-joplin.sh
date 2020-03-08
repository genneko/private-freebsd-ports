#!/bin/sh
# update-packagejsons-for-joplin.sh
#
prog=$(basename $0)
bindir=$(dirname $(readlink -f $0))

perr() {
	echo "$@" >&2
}

xerr() {
	perr "$@"
	exit 1
}

usage() {
	perr "usage: $prog <srcdir> <portdir>"
	xerr "$@"
}

if [ $# -lt 2 ]; then
	usage
fi

joplin_srcdir=$1
joplin_portdir=$2
targetdir="$joplin_portdir/files/packagejsons"

if [ -d "$joplin_srcdir" ]; then
	perr "[INFO] Okay. $joplin_srcdir exists."
else
	usage "[CRITICAL] $joplin_srcdir doesn't exist."
fi

if [ -d "$joplin_portdir" ]; then
	perr "[INFO] Okay. $joplin_portdir exists."
	if [ -d "$targetdir" ]; then
		perr "[INFO] Okay. $targetdir exists."
	else
		usage "[CRITICAL] $targetdir doesn't exist."
	fi
else
	usage "[CRITICAL] $joplin_portdir doesn't exist."
fi

for d in "" ElectronClient ReactNativeClient; do
	cd "$joplin_srcdir/$d"
	if [ ! -d "$targetdir/$d" ]; then
		mkdir "$targetdir/$d" && perr "[NOTICE] Created $targetdir/$d" || xerr "[CRITICAL] Cannot create $targetdir/$d"
	fi
	cp -v package.json package-lock.json "$targetdir/$d"
done

