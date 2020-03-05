--- ReactNativeClient/lib/shim.js.orig	2020-03-04 16:53:57 UTC
+++ ReactNativeClient/lib/shim.js
@@ -147,6 +147,12 @@ shim.fetchWithRetry = async function(fetchFn, options 
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
