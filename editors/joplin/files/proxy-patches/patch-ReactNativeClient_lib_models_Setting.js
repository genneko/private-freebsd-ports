--- ReactNativeClient/lib/models/Setting.js.orig	2019-09-27 18:02:09 UTC
+++ ReactNativeClient/lib/models/Setting.js
@@ -455,6 +455,7 @@ class Setting extends BaseModel {
 
 			'welcome.wasBuilt': { value: false, type: Setting.TYPE_BOOL, public: false },
 			'welcome.enabled': { value: true, type: Setting.TYPE_BOOL, public: false },
+			'net.proxy': { value: '', type: Setting.TYPE_STRING, public: true, appTypes: ['desktop', 'cli'], label: () => _('Proxy') },
 		};
 
 		return this.metadata_;
