import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_safety_shoe/connection_screen.dart';
import 'package:smart_safety_shoe/helpers/bluetooth_controller.dart';
import 'package:smart_safety_shoe/helpers/constants.dart';
import 'package:smart_safety_shoe/helpers/shared_preferences.dart';

class AddDetailsScreen extends StatefulWidget {
  @override
  State<AddDetailsScreen> createState() => _AddDetailsScreenState();
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  TextEditingController _controller1 = TextEditingController();

  TextEditingController _controller2 = TextEditingController();

  TextEditingController _controller3 = TextEditingController();

  final isSubmitEnable = Rx<bool>(false);

  void _isButtonEnabled(String s) {
    isSubmitEnable.value = _controller1.text.length == 10 &&
        _controller2.text.length == 10 &&
        _controller3.text.length == 10;
  }

  BluetoothController bluetoothController = Get.put(BluetoothController());
  @override
  void initState() {
    bluetoothController.requestPermissions();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constantss.colorTheme,
        foregroundColor: Colors.white,
        title: Text("ADD CONTACT DETAILS"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 60),
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Add Your Trusted Contacts",
                    style: TextStyle(fontSize: 20),
                  ),
                  // Container(
                  //   padding: EdgeInsets.only(bottom: 2),
                  //   height: 50,
                  //   width: 300,
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.black),
                  //     borderRadius: BorderRadius.circular(5.0),
                  //   ),
                  //   child: TextField(
                  //     controller: _controller1,
                  //     keyboardType: TextInputType.number,
                  //     maxLength: 10,
                  //     decoration: InputDecoration(
                  //       labelText: 'Enter 10-digit number',
                  //       border: InputBorder.none,
                  //       contentPadding: EdgeInsets.all(2.0),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      onChanged: _isButtonEnabled,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      controller: _controller1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contact 1',
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      onChanged: _isButtonEnabled,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      controller: _controller2,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contact 2',
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  SizedBox(
                    width: 250,
                    child: TextField(
                      onChanged: _isButtonEnabled,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      controller: _controller3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contact 3',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Obx(
                    () => ElevatedButton(
                      onPressed: isSubmitEnable.value
                          ? () async {
                              await SharedPre.saveNumbers(_controller1.text,
                                  _controller2.text, _controller3.text);
                              Get.offAll(BluetoothPage());
                              print('Submitted');
                            }
                          : null,
                      child: Text('Submit'),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
