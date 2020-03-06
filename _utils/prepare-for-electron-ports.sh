#!/bin/sh
# prepare-for-electron-ports.sh
#
portsdir=${PORTSDIR:-/usr/ports}
electron_portdir=${ELECTRON_PORTDIR:-$HOME/src/FreeBSD-Electron}
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

if [ -d "$electron_portdir" ]; then
	perr "[INFO] Okay. $electron_portdir exists."
else
	perr "[CRITICAL] $electron_portdir doesn't exist. Get it now."
	perr "git clone https://github.com/tagattie/FreeBSD-Electron.git"
	exit 1
fi

if [ -d "$portsdir/devel/electron7" ]; then
	perr "[INFO] $portsdir/devel/electron7 already exists."
else
	$sudo ln -s "$electron_portdir/devel/electron7" $portsdir/devel \
		&& perr "[NOTICE] Created a link $portsdir/devel/electron7" \
		|| perr "[ERROR] Failed to created $portsdir/devel/electron7" 
fi

cd "$electron_portdir/Mk/Uses"
for mk in *.mk; do
	if [ -f "$portsdir/Mk/Uses/$mk" ]; then
		perr "[INFO] $portsdir/Mk/Uses/$mk already exists."
	else
		$sudo ln -s "$electron_portdir/Mk/Uses/$mk" $portsdir/Mk/Uses \
		&& perr "[NOTICE] Created a link $portsdir/Mk/Uses/$mk" \
		|| perr "[ERROR] Failed to created $portsdir/Mk/Uses/$mk"
	fi
done
