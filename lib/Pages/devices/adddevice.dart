import 'dart:convert';

import 'package:fix_cp/Pages/basepages.dart';
import 'package:fix_cp/Pages/devices/devicepage.dart';
import 'package:fix_cp/Pages/register.dart';
import 'package:fix_cp/Widgets/Color.dart';
import 'package:fix_cp/Widgets/appbar.dart';
import 'package:fix_cp/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class addDevicePage extends StatefulWidget {
  final token;
  const addDevicePage({super.key, this.token});

  @override
  State<addDevicePage> createState() => _addDevicePageState();
}

class _addDevicePageState extends State<addDevicePage> {
  TextEditingController nameController = TextEditingController();
  String? _selectedValue;
  bool _isNotValidate = false;

  Map<String, IconData> icons = {
    "หมวดหมู่เครื่องใช้ไฟฟ้า": Icons.monitor_rounded,
    "หมวดหมู่คอมพิวเตอร์": Icons.memory_rounded,
    "หมวดหมู่ประปา": Icons.water_damage_rounded,
    "หมวดหมู่ไฟฟ้า": Icons.electric_bolt_rounded,
    "หมวดหมู่อื่นๆ": Icons.devices_other_rounded,
  };

  void addDevices() async {
    if (nameController.text.isNotEmpty && _selectedValue!.isNotEmpty) {
      var reqBody = {
        "name": nameController.text,
        "iconname": _selectedValue,
      };

      var response = await http.post(Uri.parse(adddevice),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonresponse = jsonDecode(response.body);
      print(jsonresponse['status']);
      MotionToast(
        primaryColor: Colors.green.shade300,
        height: 80,
        width: double.maxFinite,
        description: Text(
          "เพิ่มหมวดหมู่อุปกรณ์สำเร็จ",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.green.shade500),
        ),
        icon: Icons.check_circle_outline_rounded,
        iconSize: 30,
      ).show(context);
      Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => basePages(
                  token: widget.token,
                  selectedIndexs: 2
                )),
      );
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Whitecolor,
        appBar: Appbarmain(
          name: "เพิ่มหมวดหมู่อุปกรณ์",
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Textmain(name: "ไอคอนหมวดหมู่อุปกรณ์", colors: Bluelogocolor),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownButton(
                        items: <String>[
                          'หมวดหมู่เครื่องใช้ไฟฟ้า',
                          'หมวดหมู่คอมพิวเตอร์',
                          'หมวดหมู่ประปา',
                          'หมวดหมู่ไฟฟ้า',
                          'หมวดหมู่อื่นๆ',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                icons[value] != null
                                    ? Icon(
                                        icons[value]!,
                                        color: Bluelogocolor,
                                      )
                                    : SizedBox(),
                                SizedBox(width: 15),
                                Text(
                                  value,
                                  style: TextStyle(color: Bluelogocolor),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value;
                          });
                        },
                        hint: Text(
                          "กรุณาเลือกไอคอนของ หมวดหมู่อุปกรณ์",
                          style: TextStyle(color: Bluelogocolor, fontSize: 17),
                        ),
                        value: _selectedValue,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Textmain(name: "ชื่อหมวดหมู่อุปกรณ์", colors: Bluelogocolor),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: nameController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Bluelogocolor,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        filled: true,
                        fillColor: Whitecolor,
                        errorStyle: TextStyle(color: Colors.red.shade400),
                        errorText:
                            _isNotValidate ? "กรุณากรอกข้อมูลให้ครบถ้วน" : null,
                        hintText: "ชื่อหมวดหมู่อุปกรณ์",
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        labelStyle: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  addDevices();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 50,
                  child: const Center(
                      child: Text(
                    "เพิ่มหมวดหมู่อุปกรณ์",
                    style: TextStyle(
                        color: Whitecolor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              )
            ],
          ),
        ));
  }
}
