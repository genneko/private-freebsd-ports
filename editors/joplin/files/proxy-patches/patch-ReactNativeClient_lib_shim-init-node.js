--- ReactNativeClient/lib/shim-init-node.js.orig	2019-12-30 14:11:34 UTC
+++ ReactNativeClient/lib/shim-init-node.js
@@ -6,9 +6,11 @@ const { setLocale, defaultLocale, closestSupportedLoca
 const { FsDriverNode } = require('lib/fs-driver-node.js');
 const mimeUtils = require('lib/mime-utils.js').mime;
 const Note = require('lib/models/Note.js');
+const Setting = require('lib/models/Setting.js');
 const Resource = require('lib/models/Resource.js');
 const urlValidator = require('valid-url');
 const { _ } = require('lib/locale.js');
+const HttpsProxyAgent = require('https-proxy-agent');
 
 function shimInit() {
 	shim.fsDriver = () => {
@@ -243,10 +245,27 @@ function shimInit() {
 		return new Buffer(data).toString('base64');
 	};
 
+	shim.addProxyAgent_ = (requestOptions) => {
+		if (requestOptions.agent) return requestOptions;
+
+		const proxy = Setting.value('net.proxy');
+		if (!proxy) return requestOptions;
+
+		requestOptions = Object.assign({}, requestOptions);
+		requestOptions.agent = new HttpsProxyAgent(proxy); // http://127.0.0.1:3128
+		return requestOptions;
+	};
+
 	shim.fetch = async function(url, options = null) {
 		const validatedUrl = urlValidator.isUri(url);
 		if (!validatedUrl) throw new Error(`Not a valid URL: ${url}`);
 
+		options = shim.addProxyAgent_(options);
+
+		if (shim.fetchTimeout()) options.timeout = shim.fetchTimeout();
+
+		console.info(options);
+
 		return shim.fetchWithRetry(() => {
 			return nodeFetch(url, options);
 		}, options);
@@ -280,7 +299,7 @@ function shimInit() {
 			};
 		}
 
-		const requestOptions = {
+		let requestOptions = {
 			protocol: url.protocol,
 			host: url.hostname,
 			port: url.port,
@@ -288,6 +307,8 @@ function shimInit() {
 			path: url.pathname + (url.query ? `?${url.query}` : ''),
 			headers: headers,
 		};
+
+		requestOptions = shim.addProxyAgent_(requestOptions);
 
 		const doFetchOperation = async () => {
 			return new Promise((resolve, reject) => {
