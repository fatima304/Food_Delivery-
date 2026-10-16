import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:food_delivery/data/models/device_info_model.dart';

// Data source for device information integration using device_info_plus package
class DeviceInfoDataSource {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  // Integration with device_info_plus to retrieve platform-specific device information
  Future<DeviceInfoModel> getDeviceInfo() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      return DeviceInfoModel.fromAndroidDeviceInfo(androidInfo);
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      return DeviceInfoModel.fromIosDeviceInfo(iosInfo);
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }
}
