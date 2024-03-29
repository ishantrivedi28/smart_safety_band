import 'dart:ffi';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:smart_safety_shoe/edit_details_screen.dart';
import 'package:smart_safety_shoe/helpers/back_service.dart';
import 'package:smart_safety_shoe/helpers/bluetooth_controller.dart';
import 'package:smart_safety_shoe/helpers/constants.dart';
import 'package:smart_safety_shoe/helpers/shared_preferences.dart';

class BluetoothPage extends StatefulWidget {
  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  BluetoothController bluetoothController = Get.put(BluetoothController());
  Rx<bool> isSafe = Rx<bool>(true);
  Future<void> init() async {
    if (await SharedPre.isSafeGet() != null) {
      isSafe.value = (await SharedPre.isSafeGet())!;
      return;
    }
    await SharedPre.isSafeSet(true);
  }

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constantss.colorTheme,
        foregroundColor: Colors.white,
        title: Text('Women Safety Shoes'),
        actions: [
          IconButton(
              onPressed: () => Get.to(EditDetailsScreen()),
              icon: Icon(Icons.edit))
        ],
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child:

                // StreamBuilder<Map<String, dynamic>?>(
                //     stream: FlutterBackgroundService().on('update'),
                //     builder: (context, snapshot) {
                //       print(snapshot);
                //       if (!snapshot.hasData) {
                //         return const Center(
                //           child: CircularProgressIndicator(),
                //         );
                //       }

                //   return
                Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Turn on/off safety features:",
                      style: TextStyle(fontSize: 22),
                    ),
                    Obx(
                      () => Transform.scale(
                        scale: 0.7,
                        child: Switch(
                            value: isSafe.value,
                            onChanged: (val) async {
                              isSafe.value = val;
                              SharedPre.isSafeSet(isSafe.value);
                              if (isSafe.value) {
                                // FlutterBackgroundService().invoke("isSafeOn", {  "isSafee": isSafee,});

                                FlutterBackgroundService().startService();

                                // FlutterBackgroundService().
                              } else {
                                // Workmanager().cancelByUniqueName("taskOne");
                                // backGroundServicesController.startBgService();
                                FlutterBackgroundService()
                                    .invoke("stopService");
                              }
                            }),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Obx(
                  () => AbsorbPointer(
                    absorbing: !isSafe.value,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Bluetooth:",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: isSafe.value
                                      ? Colors.black
                                      : Colors.grey),
                            ),
                            Obx(() => bluetoothController.isBlueOn.value
                                ? Icon(Icons.check_circle,
                                    color: isSafe.value
                                        ? Colors.green
                                        : Colors.grey)
                                : Icon(Icons.error,
                                    color: isSafe.value
                                        ? Colors.red
                                        : Colors.grey))
                          ],
                        ),
                        Obx(
                          () => bluetoothController.isBlueOn.value
                              ? Container()
                              : Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          AppSettings.openAppSettings(
                                              type: AppSettingsType.bluetooth);
                                          // if (await bluetoothController.flutterBlue.isOn) {
                                          //   bluetoothController.initialization();
                                          // }
                                        },
                                        child: Text(
                                          "Open Settings",
                                          style: TextStyle(
                                              color: isSafe.value
                                                  ? Colors.black
                                                  : Colors.grey),
                                        )),
                                  ],
                                ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Connection Status:",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: isSafe.value
                                      ? Colors.black
                                      : Colors.grey),
                            ),
                            Obx(() => bluetoothController.isConnected.value
                                ? Icon(Icons.check_circle,
                                    color: isSafe.value
                                        ? Colors.green
                                        : Colors.grey)
                                : Icon(Icons.error,
                                    color: isSafe.value
                                        ? Colors.red
                                        : Colors.grey)),
                          ],
                        ),
                        Obx(
                          () => bluetoothController.isBlueOn.value
                              ? bluetoothController.isConnected.value
                                  ? Container()
                                  : Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ElevatedButton(
                                            onPressed: () => bluetoothController
                                                .connectToDevice(),
                                            child: Text(
                                              "Connect to Device",
                                              style: TextStyle(
                                                  color: isSafe.value
                                                      ? Colors.black
                                                      : Colors.grey),
                                            )),
                                      ],
                                    )
                              : Container(),
                        ),
                        // SizedBox(
                        //   height: 50,
                        // ),
                        // Obx(() => Text(
                        //       " ${bluetoothController.alertMessage.value}",
                        //       style: TextStyle(fontSize: 12),
                        //     )),
                        SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                            onPressed: () => bluetoothController.sendSMS(),
                            child: Text(
                              "Send ALert!",
                              style: TextStyle(
                                  color: isSafe.value
                                      ? Colors.black
                                      : Colors.grey),
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            )
            // }),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bluetoothController.sendMessage(
            'Hello, Bluetooth!',
          );
        },
        child: Icon(
          Icons.send,
        ),
      ),
    );
  }
}

// @override
  // void initState() {
  //   super.initState();
  //   _initialization();
  // }

  // Future<void> _requestPermissions() async {
  //   var bluetoothStatus = await Permission.bluetooth.status;
  //   var locationStatus = await Permission.location.status;
  //   await Permission.camera.request();
  //   print("lets seeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
  //   print(bluetoothStatus.isGranted);

  //   await Permission.bluetooth.request();

  //   await Permission.bluetoothScan.request();
  //   await Permission.sms.request();
  //   await Permission.bluetoothConnect.request();
  //   if (!locationStatus.isGranted) {
  //     await Permission.location.request();
  //   }
  //   print(
  //       "permissions done here11111111111111111111111111111111111111111111111111111111111111111111111111111");
  // }

  // Future<void> _getPairedDevices() async {
  //   List<BluetoothDevice> devices =
  //       await FlutterBluetoothSerial.instance.getBondedDevices();
  //   setState(() {
  //     _devices = devices;
  //   });
  // }

  // Future<void> _initialization() async {
  //   await _requestPermissions();
  //   await _getPairedDevices();
  // }

  // Future<void> _connectToDevice(BluetoothDevice device) async {
  //   BluetoothConnection connection =
  //       await BluetoothConnection.toAddress(device.address);
  //   setState(() {
  //     _connection = connection;
  //   });
  //   _listenForMessages();
  // }

  // void _listenForMessages() {
  //   _connection!.input!.listen((data) {
  //     // Handle received data

  //     String? msg = utf8.decode(data);
  //     setState(() {
  //       alertMessage = alertMessage + msg;
  //     });
  //     print('Received: $data');
  //     sendSMS();
  //   }).onDone(() {
  //     // Connection closed
  //     print('Connection closed');
  //   });
  // }

  // Future<void> _sendMessage(String message) async {
  //   if (_connection != null && _connection!.isConnected) {
  //     _connection!.output.add(utf8.encode(message));
  //     await _connection!.output.allSent;
  //   }
  // }