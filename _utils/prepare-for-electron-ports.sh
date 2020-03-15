#!/bin/sh
# prepare-for-electron-ports.sh
#
prog=$(basename $0)
bindir=$(dirname $(readlink -f $0))
basedir=$(readlink -f $bindir/..)
portsdir=${PORTSDIR:-/usr/ports}
sudo=""

perr() {
	echo "$@" >&2
}

euid=`id -u`
if [ "$euid" -ne 0 ]; then
	sudo="sudo"
fi

if [ -d "$portsdir" ]; then
	perr "[INFO] Okay. $portsdir exists."
else
	perr "[CRITICAL] $portsdir doesn't exist. Get it now."
	perr "portsnap fetch extract"
	exit 1
fi

if [ -d "$portsdir/devel/electron7" ]; then
	perr "[INFO] $portsdir/devel/electron7 already exists."
else
	perr "[CRITICAL] $portsdir/devel/electron7 doesn't exist. Get it now."
	perr "portsnap fetch update"
	exit 1
fi

cd "$basedir/Mk/Uses"
for mk in *.mk; do
	if [ -f "$portsdir/Mk/Uses/$mk" ]; then
		perr "[INFO] $portsdir/Mk/Uses/$mk already exists."
	else
		$sudo ln -s "$basedir/Mk/Uses/$mk" $portsdir/Mk/Uses \
		&& perr "[NOTICE] Created a link $portsdir/Mk/Uses/$mk" \
		|| perr "[ERROR] Failed to created $portsdir/Mk/Uses/$mk"
	fi
done
