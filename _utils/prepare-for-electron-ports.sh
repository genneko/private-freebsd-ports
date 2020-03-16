#!/bin/sh
# prepare-for-electron-ports.sh
#
prog=$(basename $0)
bindir=$(dirname $(readlink -f $0))
portsdir=${PORTSDIR:-/usr/ports}
electrondir=${1:-$HOME/src/FreeBSD-Electron}
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
	perr "or"
	perr "svn checkout https://svn.freebsd.org/ports/head /usr/ports"
	exit 1
fi

if [ -d "$portsdir/devel/electron7" ]; then
	perr "[INFO] $portsdir/devel/electron7 already exists."
else
	perr "[CRITICAL] $portsdir/devel/electron7 doesn't exist. Get it now."
	perr "portsnap fetch update"
	perr "or"
	perr "svn update /usr/ports"
	exit 1
fi

cd "$electrondir/Mk/Uses"
for mk in *.mk; do
	if [ -f "$portsdir/Mk/Uses/$mk" ]; then
		perr "[INFO] $portsdir/Mk/Uses/$mk already exists."
	else
		$sudo ln -s "$electrondir/Mk/Uses/$mk" $portsdir/Mk/Uses \
		&& perr "[NOTICE] Created a link $portsdir/Mk/Uses/$mk" \
		|| perr "[ERROR] Failed to created $portsdir/Mk/Uses/$mk"
	fi
done
