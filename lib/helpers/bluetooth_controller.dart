import 'dart:convert';

import 'package:background_sms/background_sms.dart';
import 'package:flutter_blue/flutter_blue.dart' as myBlue;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_safety_shoe/helpers/shared_preferences.dart';

class BluetoothController extends GetxController {
  Rx<BluetoothConnection?> connection = Rx<BluetoothConnection?>(null);
  RxList<BluetoothDevice> devices = RxList<BluetoothDevice>([]);
  Rx<String> alertMessage = Rx<String>("");
  final myBlue.FlutterBlue flutterBlue = myBlue.FlutterBlue.instance;
  Rx<bool> isConnected = Rx<bool>(false);
  Rx<String> connectionStatus = Rx<String>("disconnected");
  Rx<bool> isBlueOn = Rx<bool>(false);
  String _locationLink = "";
  // Rx<bool> isSafe = Rx<bool>(true);

  Future<void> _bluetoothEnableStatus() async {
    print("checking bluetooth on/off status");
    flutterBlue.state.listen((state) {
      print(state);
      if (state == myBlue.BluetoothState.on) {
        isBlueOn.value = true;
      } else {
        isBlueOn.value = false;
      }
    });
  }

  Future<void> requestPermissions() async {
    await Permission.notification.isDenied.then((val) async {
      if (val) {
        await Permission.notification.request();
      }
    });
    await Permission.bluetoothConnect.request();
    await Permission.bluetooth.request();

    await Permission.bluetoothScan.request();
    await Permission.sms.request();

    var bluetoothStatus = await Permission.bluetooth.status;
    var locationStatus = await Permission.location.status;

    print("lets seeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    print(bluetoothStatus.isGranted);
    if (!locationStatus.isGranted) {
      await Permission.location.request();
    }
    print(
        "permissions done here11111111111111111111111111111111111111111111111111111111111111111111111111111");
  }

  Future<void> _getPairedDevices() async {
    List<BluetoothDevice> scannedDevices =
        await FlutterBluetoothSerial.instance.getBondedDevices();
    devices.value = scannedDevices;
  }

  Future<void> connectToDevice() async {
    try {
      BluetoothConnection connect =
          // await BluetoothConnection.toAddress(device.address);
          await BluetoothConnection.toAddress("D8:BC:38:E6:36:3A");

      connection.value = connect;
      Get.snackbar("Connected", "Connected to Women Safety Shoes",
          snackPosition: SnackPosition.BOTTOM);
      listenForMessages();
    } catch (e) {
      print(e);
      Get.snackbar("Error on Connecting with Device", "Unable to Connect",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void listenForMessages() {
    isConnected.value = true;
    connectionStatus.value = "Connected";
    try {
      connection.value!.input!.listen((data) {
        // Handle received data

        String? msg = utf8.decode(data);

        alertMessage.value = alertMessage.value + msg;

        print('Received: $data');
        sendSMS();
      }).onDone(() {
        // Connection closed
        Get.snackbar("Disconnected", "Women Safety Shoes Disconnected");
        isConnected.value = false;
        connectionStatus.value = "Disconnected";
        print('Connection closed');
      });
    } catch (e) {}
  }

  Future<void> sendMessage(String message) async {
    if (connection.value != null && connection.value!.isConnected) {
      connection.value!.output.add(utf8.encode(message));
      await connection.value!.output.allSent;
    }
  }

  void sendSMS() async {
    var nums = await SharedPre.getNumbers();
    await _getLocation();
    var result = await BackgroundSms.sendMessage(
        phoneNumber: nums[0]!,
        message: "HELP ME!!! My Location:$_locationLink");
    await BackgroundSms.sendMessage(
        phoneNumber: nums[1]!,
        message: "HELP ME!!! My Location:$_locationLink");
    await BackgroundSms.sendMessage(
        phoneNumber: nums[2]!,
        message: "HELP ME!!! My Location:$_locationLink");
    if (result == SmsStatus.sent) {
      print("Sent");
    } else {
      print("Failed");
    }
  }

  Future<void> initialization() async {
    print("reached hereeee!!");
    // await requestPermissions();
    print("reached theereeeeee");
    await _bluetoothEnableStatus();

    // await _getPairedDevices();
    // _checkConnectionState("D8:BC:38:E6:36:3A");
    await connectToDevice();
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      _locationLink =
          "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
    } catch (e) {
      Get.snackbar("Error getting location", e.toString().substring(0, 20));
      print(_locationLink);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit

    initialization();

    super.onInit();
  }
}
