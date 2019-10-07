--- ReactNativeClient/lib/shim.js.orig	2019-09-27 18:02:09 UTC
+++ ReactNativeClient/lib/shim.js
@@ -38,6 +38,7 @@ shim.platformName = function() {
 	if (shim.isWindows()) return 'win32';
 	if (shim.isLinux()) return 'linux';
 	if (shim.isFreeBSD()) return 'freebsd';
+	if (process && process.platform) return process.platform;
 	throw new Error('Cannot determine platform');
 };
 
@@ -145,6 +146,12 @@ shim.fetchWithRetry = async function(fetchFn, options 
 shim.fetch = () => {
 	throw new Error('Not implemented');
 };
+shim.setFetchTimeout = (v) => {
+	const previousTimeout = shim.fetchTimeout_ ? shim.fetchTimeout_ : null;
+	shim.fetchTimeout_ = v;
+	return previousTimeout;
+};
+shim.fetchTimeout = () => { return shim.fetchTimeout_; };
 shim.FormData = typeof FormData !== 'undefined' ? FormData : null;
 shim.fsDriver = () => {
 	throw new Error('Not implemented');
