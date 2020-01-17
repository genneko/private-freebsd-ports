--- ReactNativeClient/lib/models/Setting.js.orig	2019-12-30 14:11:34 UTC
+++ ReactNativeClient/lib/models/Setting.js
@@ -558,6 +558,7 @@ class Setting extends BaseModel {
 
 			'welcome.wasBuilt': { value: false, type: Setting.TYPE_BOOL, public: false },
 			'welcome.enabled': { value: true, type: Setting.TYPE_BOOL, public: false },
+			'net.proxy': { value: '', type: Setting.TYPE_STRING, public: true, appTypes: ['desktop', 'cli'], label: () => _('Proxy') },
 
 			'camera.type': { value: 0, type: Setting.TYPE_INT, public: false, appTypes: ['mobile'] },
 			'camera.ratio': { value: '4:3', type: Setting.TYPE_STRING, public: false, appTypes: ['mobile'] },
