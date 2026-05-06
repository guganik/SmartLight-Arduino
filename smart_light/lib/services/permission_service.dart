import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class PermissionService {
  static Future<bool> requestBluetoothPermissions() async {
    if (Platform.isAndroid) {
      var bluetoothConnectStatus = await Permission.bluetoothConnect.request();
      if (!bluetoothConnectStatus.isGranted) {
        return false;
      }

      var bluetoothScanStatus = await Permission.bluetoothScan.request();
      if (!bluetoothScanStatus.isGranted) {
        return false;
      }
    }

    return true;
  }

  static Future<bool> checkBluetoothPermissions() async {
    if (Platform.isAndroid) {
      var bluetoothConnectStatus = await Permission.bluetoothConnect.status;
      print(bluetoothConnectStatus);
      var bluetoothScanStatus = await Permission.bluetoothScan.status;
      print(bluetoothScanStatus);
      if (!bluetoothConnectStatus.isGranted || !bluetoothScanStatus.isGranted) {
        return false;
      }
    }

    return true;
  }
}
