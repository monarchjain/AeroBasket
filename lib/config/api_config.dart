import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class ApiConfig {
  static const String _laptopIp = '192.168.29.168';

  static const int _port = 3000;

  static String baseUrl = 'http://10.0.2.2:$_port'; // safe default until init() runs

  static Future<void> init() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      baseUrl = androidInfo.isPhysicalDevice
          ? 'http://$_laptopIp:$_port'
          : 'http://10.0.2.2:$_port';
    } else {
      baseUrl = 'http://localhost:$_port';
    }
  }
}