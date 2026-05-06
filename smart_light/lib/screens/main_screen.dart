import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_light/screens/select_color.dart';
import 'package:smart_light/services/permission_service.dart';
import 'package:smart_light/services/colors.dart';
import 'package:flutter_bluetooth_serial_plus/flutter_bluetooth_serial_plus.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  String currentColorTheme;
  String currentPowerTheme;
  num hue;

  MainScreen({
    super.key,
    required this.currentColorTheme,
    required this.currentPowerTheme,
    required this.hue
  });

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String switchTheme = 'assets/icons/sun.svg';
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  List<BluetoothDevice> devicesList = [];

  StreamSubscription<BluetoothDiscoveryResult>? _discoveryStream;
  
  BluetoothDevice? connectedDevice;
  BluetoothDevice? tryConnectDevice;
  BluetoothConnection? connection;

  bool isConnecting = false;
  bool isDiscovering = false;

  bool lightOn = false;

  @override
  void initState() {
    super.initState();
    _initAll();
  }

  Future<void> _initAll() async {
    await _checkPermissionsAndGetDevices();
    await initBluetooth();
  }

  Future<void> initBluetooth() async {
    try {
      await bluetooth.requestEnable();
      bluetooth.onStateChanged().listen((state) {
        print('Состояние Bluetooth: $state');
        if (state == BluetoothState.STATE_ON) {
          startDiscovery();
        }
      });
      if (await bluetooth.isEnabled ?? false) {
        startDiscovery();
      }
    } catch (e) {
      print('Ошибка включения Bluetooth: $e');
    }
  }

  Future<void> startDiscovery() async {
    if (isDiscovering) {
      return;
    }

    isDiscovering = true;

    _discoveryStream?.cancel();

    setState(() => devicesList.clear());

    await Future.delayed(Duration(seconds: 1));

    _discoveryStream = bluetooth.startDiscovery().listen(
      (result) {
        setState(() {
          final existingIndex = devicesList.indexWhere((d) => d.address == result.device.address);
          if (existingIndex == -1) {
            devicesList.add(result.device);
          }
        });
      },
      onDone: () => setState(() {
        isDiscovering = false;
      })
    );
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    setState(() {
      isConnecting = true;
      tryConnectDevice = device;
    });
    try {
      await bluetooth.cancelDiscovery();
      if (!device.isBonded) {
        bool? bonded = await bluetooth.bondDeviceAtAddress(device.address);
        if (!bonded!) {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Не удалось подключиться к устройству ${device.name} | ${device.address}!', style: TextStyle(color: Colors.red),)));
            isConnecting = false;
          });
          return;
        }
      }
      await connection?.close();

      BluetoothConnection newConnection = await BluetoothConnection.toAddress(device.address);

      setState(() {
        connection = newConnection;
        connectedDevice = device;
        isConnecting = false;
        devicesList = [connectedDevice!];
      });
      setupDataListener(newConnection);
    } catch (e) {
      setState(() => isConnecting = false);
      print('Ошибка подключения: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка подключения к устройству ${device.name} | ${device.address}:\n$e')));
    }
  }

  void setupDataListener(BluetoothConnection conn) {
    conn.input!.listen((data) {
      String receivedString = ascii.decode(data);
      print('Получено от Arduino: $receivedString');
      if (receivedString.contains('OK')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Arduino: $receivedString')));
      }
    }).onDone(() {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Соединение с $connectedDevice закрыто!', style: TextStyle(color: Colors.red),)));
      print('Соединение закрыто');
      setState(() {
        connectedDevice = null;
        connection = null;
      });
    });
  }

  Future<void> sendCommand(String command) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('command: $command')));
    if (connection == null || !connection!.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Нет активного соединения!')));
      print('Нет активного соединения!');
      return;
    }
    try {
      connection!.output.add(utf8.encode('$command\n'));
      await connection!.output.allSent;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Отправлено на $connectedDevice: $command')));
      print('Отправлено: $command');
    } catch (e) {
      print('Ошибка отправки: $e');
    }
  }

  Future<void> _checkPermissionsAndGetDevices() async {
    bool hasPermissions = await PermissionService.checkBluetoothPermissions();

    if (!hasPermissions) {
      await PermissionService.requestBluetoothPermissions();
    }
  }

  @override
  void dispose() {
    _discoveryStream?.cancel();
    connection?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    String currentTheme = widget.currentColorTheme + widget.currentPowerTheme;
    
    return Scaffold(
      backgroundColor: SelectColor(hue: widget.hue).backgroundColors[currentTheme],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 32,),
          Row(
            children: [
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (widget.currentColorTheme == 'light') {
                      widget.currentColorTheme = 'dark';
                      switchTheme = 'assets/icons/sun.svg';
                    } else {
                      widget.currentColorTheme = 'light';
                      switchTheme = 'assets/icons/moon.svg';
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: SvgPicture.asset(
                    switchTheme,
                    width: 52,
                    height: 52,
                    color: SelectColor(hue: widget.hue).iconColors[currentTheme],
                  )
                )
              ),
            ],
          ),
          Row(
            children: [
              Spacer(),
              GestureDetector(
                onTap: () {
                  if (lightOn) {
                    sendCommand('LED_OFF');
                  } else {
                    sendCommand('LED_ON');
                  }
                  setState(() {
                    widget.currentPowerTheme = widget.currentPowerTheme == 'off' ? 'on' : 'off';
                    lightOn = !lightOn;
                  });
                },
                child: Stack(
                  alignment: AlignmentGeometry.center,
                  children: [
                    Container(
                      width: screenWidth < screenHeight ? screenWidth * 0.6 : screenHeight * 0.4,
                      height: screenWidth < screenHeight ? screenWidth * 0.6 : screenHeight * 0.4,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            SelectColor(hue: widget.hue).buttonColors[currentTheme]!,
                            SelectColor(hue: widget.hue).buttonColorsPlus[currentTheme]!,
                          ],
                          radius: 1.3,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(color: SelectColor(hue: widget.hue).buttonUIColors[currentTheme]!, width: 12),
                        boxShadow: [
                          BoxShadow(
                            color: SelectColor(hue: widget.hue).shadowColors[currentTheme]!,
                            blurRadius: 100,
                          )
                        ]
                      ),
                    ),
                    Icon(
                      Icons.power_settings_new_rounded,
                      size: screenWidth < screenHeight ? screenWidth * 0.3 : screenHeight * 0.2,
                      color: SelectColor(hue: widget.hue).buttonUIColors[currentTheme],
                    )
                  ],
                ),
              ),
              Spacer(),
            ]
          ),
          SizedBox(height: 35,),
          Row(
            children: [
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SelectColorScreen(
                      currentColorTheme: widget.currentColorTheme,
                      currentPowerTheme: widget.currentPowerTheme,
                      hue: widget.hue,
                    ))
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: SelectColor(hue: widget.hue).selectButtonColors[currentTheme],
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 95, 95, 95),
                        blurRadius: 15,
                        offset: Offset(0, 5)
                      )
                    ]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Поменять свет',
                        style: TextStyle(
                          fontSize: screenWidth < screenHeight ? screenWidth * 0.05 : screenHeight * 0.025,
                          color: SelectColor(hue: widget.hue).fontColors[currentTheme],
                        ),
                      ),
                      // SizedBox(width: 8,),
                      // Icon(
                      //   Icons.circle,
                      //   size: 32,
                      //   color: Colors.white,
                      // ),
                    ]
                  ),
                ),
              ),
              Spacer()
            ],
          ),
          SizedBox(height: 20,),
          Text(
            connectedDevice != null ? 'Подключено к ${connectedDevice!.name}' : isConnecting ? 'Подключение к устройству ${tryConnectDevice!.name}...' : 'Устройство не подключено',
            style: TextStyle(
              color: connectedDevice != null ? Colors.green : Colors.red,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: devicesList.length,
                    itemBuilder: (context, index) {
                      final device = devicesList[index];
                      return ListTile(
                        title: Text(device.name ?? 'Неизвестное устройство'),
                        subtitle: Text(device.address),
                        trailing: ElevatedButton(
                          onPressed: isConnecting
                            ? null
                            : () => connectToDevice(device),
                          child: Text(
                            isConnecting && devicesList.length == 1 && connectedDevice != null
                            ? 'Отключиться'
                            : 'Подключиться'
                          )
                        ),
                      );
                    },
                  )
                ),
                isDiscovering
                ? Text(
                  'Поиск устройств...',
                  style: TextStyle(
                    color: Colors.red
                  ),
                )
                : SizedBox()
              ]
            )
          ),
          SizedBox(height: 20,),
          isDiscovering
          ? SizedBox()
          : ElevatedButton(
            onPressed: () => startDiscovery(),
            child: Text('Сканировать заново')
          ),
          SizedBox(height: 20,)
        ]
      )
    );
  }
}