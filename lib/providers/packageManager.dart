import 'package:flutter/services.dart';

class packageManager {
  static const platform = const MethodChannel('com.test/test');
  static const packageManagerPlatform =
      const MethodChannel('com.bitinfinity/packageManager');

  Future<dynamic> isInstall(String packageName) async {
    return await platform
        .invokeMethod("isInstall", {"packageName": packageName});
  }

  Future<dynamic> getPackageDetails(String packageName) async {
    return await platform
        .invokeMethod("getPackageDetail", {"packageName": packageName});
  }

  Future<dynamic> getPackagePermissions(String packageName) async {
    return await platform
        .invokeMethod("getPackagePermissions", {"packageName": packageName});
  }

  Future<dynamic> getAllPackages(bool systemApps) async {
    return await platform
        .invokeMethod("getInstalledList", {"systemApps": systemApps});
  }

  Future<dynamic> openApp(String packageName) async {
    return await platform.invokeMethod("openApp", {"packageName": packageName});
  }

  Future<dynamic> openAppSettings(String packageName) async {
    return await platform
        .invokeMethod("openAppSettings", {"packageName": packageName});
  }

  Future<dynamic> uninstallApp(String packageName) async {
    return await platform
        .invokeMethod("unInstall", {"packageName": packageName});
  }

  Future<dynamic> launchReview(String packageName) async {
    return await platform
        .invokeMethod("launchReview", {"packageName": packageName});
  }

  Future<dynamic> getBatteryLevel() async {
    return await platform.invokeMethod("batteryLevel");
  }

  Future<dynamic> share(String text, String subject) async {
    return await platform
        .invokeMethod("share", {"text": text, "subject": subject});
  }

  Future<dynamic> showToast(String text) async {
    return await platform.invokeMethod("toast", {"text": text});
  }

  Future<dynamic> moreApps() async {
    return await platform.invokeMethod("moreApps");
  }

  Future<dynamic> getInstalledPackages(bool systemApp) async {
    return await packageManagerPlatform
        .invokeMethod("getInstalledPackages", {"systemApp": systemApp});
  }
}
