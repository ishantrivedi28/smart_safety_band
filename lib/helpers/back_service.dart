import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:background_sms/background_sms.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:smart_safety_shoe/helpers/bluetooth_controller.dart';
import 'package:smart_safety_shoe/helpers/shared_preferences.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'Women Safety Shoes', // id
    'Safety Enabled', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'Women Safety Shoes',
      initialNotificationTitle: 'Safety Enabled',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // final blueController = Get.put(BluetoothController());
  // service.on('isSafeOn').listen((event) {
  //   if(event!= null)
  //   blueController.isSafee = event["isSafee"];
  // });

  int numb = 0;
  BluetoothConnection? connect = null;
  Timer.periodic(Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        flutterLocalNotificationsPlugin.show(
            888,
            "women safety shoes",
            "safety enabled",
            NotificationDetails(
                android: AndroidNotificationDetails(
                    'Women Safety Shoes', // id
                    'Safety Enabled', // title
                    icon: 'ic_bg_service_small',
                    ongoing: true)));

        try {
          // connect = await BluetoothConnection.toAddress("D8:BC:38:E6:36:3A");
          connectToBluetoothDevice("D8:BC:38:E6:36:3A");
          // print(connect!.isConnected);
        } catch (e) {
          print("error occured connecting background bluetooth $e");
        }
      }
    }
    numb++;

    service.invoke('update', {
      "numb": numb,
      // "isConnected": blueController.isConnected.value,
      // "connectionStatus": blueController.connectionStatus.value,
      // "isBlueOn": blueController.isBlueOn.value
    });
  });
  try {
    // BluetoothConnection connect =
    //     // await BluetoothConnection.toAddress(device.address);
    // await BluetoothConnection.toAddress("D8:BC:38:E6:36:3A");
    BluetoothConnection? connection = connect;

    try {
      connection!.input!.listen((data) async {
        // Handle received data
        print("Danger Detected!!");

        var nums = await SharedPre.getNumbers();

        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        var locationLink =
            "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";

        print(locationLink);

        // var result = await BackgroundSms.sendMessage(
        //     phoneNumber: nums[0]!,
        //     message: "HELP ME!!! My Location:$locationLink");
        // await BackgroundSms.sendMessage(
        //     phoneNumber: nums[1]!,
        //     message: "HELP ME!!! My Location:$locationLink");
        // await BackgroundSms.sendMessage(
        //     phoneNumber: nums[2]!,
        //     message: "HELP ME!!! My Location:$locationLink");
      }).onDone(() {
        // Connection closed
      });
    } catch (e) {}
  } catch (e) {
    print(e);
  }
  // await blueController.initialization();
}

void connectToBluetoothDevice(String address) async {
  // Instantiate FlutterBlue
  FlutterBlue flutterBlue = FlutterBlue.instance;

  // Start scanning for devices
  flutterBlue.scanResults.listen((List<ScanResult> results) {
    // Iterate through the scan results
    for (ScanResult result in results) {
      // Check if the device address matches your target address
      if (result.device.id.toString() == address) {
        // Stop scanning
        flutterBlue.stopScan();

        // Connect to the device
        result.device.connect().then((value) {
          print('Connected to ${result.device.name}');

          // Once connected, you can perform further actions, such as reading or writing characteristics.
        }).catchError((error) {
          print('Connection failed: $error');
        });

        break; // Break the loop after finding the device
      }
    }
  });

  // Start scanning
  flutterBlue.startScan();
}
