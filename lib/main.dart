import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_safety_shoe/add_details_screen.dart';
import 'package:smart_safety_shoe/connection_screen.dart';
import 'package:smart_safety_shoe/helpers/back_service.dart';
import 'package:smart_safety_shoe/helpers/bluetooth_controller.dart';
import 'package:smart_safety_shoe/helpers/constants.dart';
import 'package:smart_safety_shoe/helpers/shared_preferences.dart';

// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) {
//     final bController = Get.put(BluetoothController());
//     bController.initialization();

//     print("Task executing :" + taskName);
//     return Future.value(true);
//   });
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Safety Shoes',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Constantss.colorTheme),
          useMaterial3: true,
        ),
        // home: BluetoothPage(),
        home: SpalshScreen());
  }
}

class SpalshScreen extends StatelessWidget {
  const SpalshScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkNumbers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          if (snapshot.data == true) {
            return BluetoothPage();
          } else {
            return AddDetailsScreen();
          }
        }
      },
    );
  }
}

Future<bool> checkNumbers() async {
  print("hi");
  List<String?> nums = await SharedPre.getNumbers();
  print(nums);
  return nums[0] != null && nums[1] != null && nums[2] != null;
}


// class AllBindings implements Bindings {
//   @override
//   void dependencies() {
//     Get.put(BluetoothController());
//   }
// }
