--- ElectronClient/app/electronRebuild.js.orig	2019-09-27 18:02:09 UTC
+++ ElectronClient/app/electronRebuild.js
@@ -22,6 +22,10 @@ const isWindows = () => {
 	return process && process.platform === 'win32';
 };
 
+const isFreeBSD = () => {
+	return process && process.platform === 'freebsd';
+};
+
 async function main() {
 	// electron-rebuild --arch ia32 && electron-rebuild --arch x64
 
@@ -31,6 +35,9 @@ async function main() {
 	if (isWindows()) {
 		console.info(await execCommand([`"${exePath}"`, '--arch ia32'].join(' ')));
 		console.info(await execCommand([`"${exePath}"`, '--arch x64'].join(' ')));
+	} else if (isFreeBSD()) {
+		console.info(await execCommand([`"${exePath}"`, '-e /usr/local/bin', '--version `cat /usr/local/share/electron/version`'].join(' ')));
+
 	} else {
 		console.info(await execCommand([`"${exePath}"`].join(' ')));
 	}
