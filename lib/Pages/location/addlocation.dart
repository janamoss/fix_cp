import 'dart:convert';

import 'package:fix_cp/Pages/basepages.dart';
import 'package:fix_cp/Pages/devices/devicepage.dart';
import 'package:fix_cp/Pages/location/locationpage.dart';
import 'package:fix_cp/Pages/register.dart';
import 'package:fix_cp/Widgets/Color.dart';
import 'package:fix_cp/Widgets/appbar.dart';
import 'package:fix_cp/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class addLocationPage extends StatefulWidget {
  final token;
  const addLocationPage({super.key, this.token});

  @override
  State<addLocationPage> createState() => _addLocationPageState();
}

class _addLocationPageState extends State<addLocationPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController buildingController = TextEditingController();

  int? _selectedValue;
  bool _isNotValidate = false;

  void addLocations() async {
    if (nameController.text.isNotEmpty && _selectedValue!.isFinite) {
      var reqBody = {
        "name": nameController.text,
        "floor": _selectedValue,
        "building": buildingController.text,
      };

      var response = await http.post(Uri.parse(addlocation),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonresponse = jsonDecode(response.body);
      print(jsonresponse['status']);
      MotionToast(
        primaryColor: Colors.green.shade300,
        height: 80,
        width: double.maxFinite,
        description: Text(
          "เพิ่มห้องสำเร็จ",
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
                  selectedIndexs: 1
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
          name: "เพิ่มห้อง",
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Textmain(name: "ชื่อห้อง", colors: Bluelogocolor),
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
                        hintText: "ชื่อห้อง",
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        labelStyle: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Textmain(name: "ชั้นห้อง", colors: Bluelogocolor),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownButton(
                        items: <int>[
                          1,
                          2,
                          3,
                          4,
                          5,
                        ].map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Row(
                              children: [
                                value != null
                                    ? Icon(
                                        Icons.business,
                                        color: Bluelogocolor,
                                      )
                                    : SizedBox(),
                                SizedBox(width: 15),
                                Text(
                                  "ชั้นที่ $value",
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
                          "กรุณาเลือกชั้นของห้อง",
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
                  Textmain(name: "ตึกของห้อง", colors: Bluelogocolor),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: buildingController,
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
                        hintText: "ตึกของห้อง (ค่าเริ่มต้น ตึกอาคาร 9)",
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
                  addLocations();
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
                    "เพิ่มห้อง",
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
