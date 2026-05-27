import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smart_light/services/permission_service.dart';

class BleService {
  List<BluetoothDevice> devicesList = [];

  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? targetCharacteristic;

  StreamSubscription<BluetoothConnectionState>? connectionStateSubscription;

  bool isScanning = false;
  bool autoScanEnabled = true;
  Timer? autoScanTimer;

  bool isConnecting = false;

  bool? powerOn;
  int? hue;
  int? saturation;
  int? brightness;

  String? lastSendedCmd;

  Function? onDeviceDisconnected;

  final StreamController<void> _stateController = StreamController.broadcast();
  Stream<void> get stateStream => _stateController.stream;

  void _notify() {
    _stateController.add(null);
  }

  Future<BluetoothDevice?> startScan() async {
    if (isScanning) return null;

    isScanning = true;
    devicesList.clear();

    try {
      await FlutterBluePlus.stopScan();
      await Future.delayed(Duration(milliseconds: 300));

      FlutterBluePlus.scanResults.listen((results) async {
        for (ScanResult result in results) {
          final device = result.device;

          print("FOUND: ${device.platformName} | ${device.remoteId}");

          if (device.remoteId.toString() == "98:7B:F3:4E:CD:4C") {
            await FlutterBluePlus.stopScan();

            isScanning = false;

            connectToDevice(device);

            return;
          }
        }
      });

      await FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
      await Future.delayed(Duration(seconds: 4));

    } catch (e) {
      print(e);
    }

    isScanning = false;
    return connectedDevice;
  }

  BluetoothDevice? startAutoScan() {
    autoScanTimer?.cancel();
    autoScanTimer = Timer.periodic(Duration(seconds: 6), (timer) async {
      if (!autoScanEnabled) return;
      if (isScanning) return;
      if (connectedDevice != null) return;

      connectedDevice = await startScan();
    });

    return connectedDevice;
  }

  Future<BluetoothDevice?> connectToDevice(BluetoothDevice device) async {
    try {
      print("CONNECTING...");

      await device.connect(license: License.free);

      connectedDevice = device;

      listenConnectionState(device);

      print("CONNECTED");

      List<BluetoothService> services = await device.discoverServices();

      for (BluetoothService service in services) {
        for (BluetoothCharacteristic c in service.characteristics) {
          print("CHAR: ${c.uuid}");
          if (c.uuid.toString().toUpperCase().contains("FFE1")) {
            targetCharacteristic = c;

            print("UART FOUND");

            await enableNotifications(c);
          }
        }
      }
      sendCommand(device, 'get_status');
      return connectedDevice;

    } catch (e) {
      print("CONNECT ERROR:\n$e");
      return null;
    }
  }

  String _buffer = "";

  Future<void> enableNotifications(BluetoothCharacteristic c) async {
    await c.setNotifyValue(true);
    _buffer = "";
    c.lastValueStream.listen((value) {
      _buffer += utf8.decode(value);
      while (_buffer.contains('\n')) {
        final index = _buffer.indexOf('\n');
        final msg = _buffer.substring(0, index).trim();

        _buffer = _buffer.substring(index + 1);

        _handleMessage(msg);
      }
    });
  }

  void _handleMessage(String text) {
    print("RECEIVED: $text");

    if (text.startsWith('onPower:')) {
      powerOn = text.split(':').last == "1";
    }

    if (text.startsWith('bright:')) {
      brightness = int.tryParse(text.split(':').last);
    }

    if (text.startsWith('satur:')) {
      saturation = int.tryParse(text.split(':').last);
    }

    if (text.startsWith('hue:')) {
      hue = int.tryParse(text.split(':').last);
    }

    _notify();
  }

  Future<void> sendCommand(BluetoothDevice device, String command) async {
    if (targetCharacteristic == null) {
      await connectToDevice(device);
    }
    try {
      await targetCharacteristic!.write(
        utf8.encode("$command\n"),
        withoutResponse: true,
      );
      lastSendedCmd = command;
      print("SENT: $command");
    } catch (e) {
      print("SEND ERROR:\n$e");
    }
  }

  void listenConnectionState(BluetoothDevice device) {
    connectionStateSubscription = device.connectionState.listen((state) {
      print("STATE: $state");

      if (state == BluetoothConnectionState.connected) {
        connectedDevice = device;
      }

      else if (state == BluetoothConnectionState.disconnected) {
        print("DISCONNECTED");

        connectedDevice = null;
        targetCharacteristic = null;

        if (onDeviceDisconnected != null) {
          onDeviceDisconnected!();
        }

        startScan();
      }
    });
  }

  Future<void> checkPermissionsAndGetDevices() async {
    bool hasPermissions = await PermissionService.checkBluetoothPermissions();

    if (!hasPermissions) {
      await PermissionService.requestBluetoothPermissions();
    }
  }
}