# private-freebsd-ports
Original or modified FreeBSD ports by a novice porter.  
Only meant for private use.

## Original ports
### deskutils/joplin-desktop
[Joplin Desktop Application](https://joplinapp.org) - an open source note taking and to-do application with synchronization capabilities.  
This private port was manually imported from [tagattie/freebsd-ports](https://github.com/tagattie/freebsd-ports/tree/master/deskutils/joplin-desktop) and it's one of the sample ports for the [article on how to port Electron-based app to FreeBSD](https://blog.c6h12o6.org/post/freebsd-electron-app/) by the same author.  
This port requires the [helper makefiles](https://github.com/tagattie/FreeBSD-Electron/tree/master/Mk/Uses) also by the same author.

I've been trying to update it for learning purposes.

### deskutils/joplin-terminal
A terminal (TUI/CLI) version of the above mentioned Joplin - a note taking application.  

This port also requires the [helper makefiles](https://github.com/genneko/FreeBSD-Electron/tree/helpers_for_nodeapps/Mk/Uses), but this time they are my modified versions for supporting node-only apps.

### editors/omegaT4
An easy port of [OmegaT](https://omegat.org/) - a free translation memory tool (version 4.x).  
Unlike the official port, this port just installs the cross-platform JAR instead of building the program from its source.  
The JAR itself should be manually downloaded and put in DISTDIR.

### editors/omegaT5
OmegaT Version 5.x. The same as above except the version.

### sysutils/vtop
An activity monitor for the command line.  
This is my first complete port using the modified [helper makefiles](https://github.com/genneko/FreeBSD-Electron/tree/helpers_for_nodeapps/Mk/Uses) for node applications.

## Modified Ports
Private patches for the official ports.

### devel/gettext-tools
This port has been patched to handle JavaScript template strings correctly.  
Just imported the upstream patch for [bug 56678](https://savannah.gnu.org/bugs/?56678).  
It is required to update translations for Joplin.

### net/onedrive
This port has been patched to upgrade the version from 2.3.3_1 to [2.3.10](https://github.com/abraunegg/onedrive/releases/tag/v2.3.10).  
With the patch, the upstream repository has been also changed.

### net/p5-Net-Proxy
This port has been added an option LIBWRAP, which enables libwrap and IPv6 support on tcp connector.  

