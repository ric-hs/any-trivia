import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin;

  DeviceInfoService({DeviceInfoPlugin? deviceInfoPlugin})
      : _deviceInfoPlugin = deviceInfoPlugin ?? DeviceInfoPlugin();

  Future<String?> getHardwareId() async {
    if (kIsWeb) return null;

    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return androidInfo.id; // unique ID on Android
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return iosInfo.identifierForVendor; // unique ID on iOS
      }
    } catch (e) {
      debugPrint('Error getting hardware ID: $e');
    }

    return null;
  }
}
