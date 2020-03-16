# private-freebsd-ports
Original or modified FreeBSD ports by a novice porter.  
Only meant for private use.

## deskutils/joplin-desktop
[Joplin Desktop Application](https://joplinapp.org) - an open source note taking and to-do application with synchronization capabilities.  
This private port was manually imported from [tagattie/freebsd-ports](https://github.com/tagattie/freebsd-ports/tree/master/deskutils/joplin-desktop) and it's one of the sample ports for the [article on how to port Electron-based app to FreeBSD](https://blog.c6h12o6.org/post/freebsd-electron-app/) by the same author.  
I've been trying to update it for learning purposes.

This port requires the [helper makefiles](https://github.com/tagattie/FreeBSD-Electron/tree/master/Mk/Uses).

## deskutils/joplin-terminal
A terminal (TUI/CLI) version of the above mentioned Joplin - a note taking application.  

## editors/omegaT4
An easy port of [OmegaT](https://omegat.org/) - a free translation memory tool (version 4.x).  
Unlike the official port, this port just installs the cross-platform JAR instead of building the program from its source.  
The JAR itself should be manually downloaded and put in DISTDIR.

## editors/omegaT5
OmegaT Version 5.x. The same as above except the version.

## _patches
Private patches for the official ports.

### gettext-tools-x.x.x.diff
A patch for devel/gettext-tools to make it handle JavaScript template strings correctly.  
Just imported the upstream patch for [bug 56678](https://savannah.gnu.org/bugs/?56678).  
It is required to update translations for Joplin.

### omegaT-x.x.x.diff
A patch for editors/omegaT to upgrade the version from 3.6.0 to 4.3.0. This patch avoids gradle bulid by using distributed jars.

### onedrive-x.x.x.diff
A patch for net/onedrive to upgrade the version from 2.3.3_1 to [2.3.9](https://github.com/abraunegg/onedrive/releases/tag/v2.3.9).

### p5-Net-Proxy-x.x.x.diff
An experimental patch for net/p5-Net-Proxy to add IPv6 and libwrap support to tcp connector.  
With this patch, security/p5-Authen-Libwrap is added to build/run dependency.
