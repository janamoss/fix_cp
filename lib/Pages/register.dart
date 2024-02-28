import 'dart:convert';

import 'package:fix_cp/Pages/login.dart';
import 'package:fix_cp/Widgets/Color.dart';
import 'package:fix_cp/Widgets/appbar.dart';
import 'package:fix_cp/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';

enum radioType { Student, TA, Professor }

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController verpasswordController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool _isNotValidate = false;

  radioType? _radioType;

  bool _obscureText = true;
  bool _obscureText2 = true;

  void registeruser() async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        verpasswordController.text.isNotEmpty &&
        fNameController.text.isNotEmpty &&
        lNameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        _radioType?.name != null) {
      var reqBody = {
        "name": "${fNameController.text} ${lNameController.text}",
        "email": emailController.text,
        "password": passwordController.text,
        "phonenumber": phoneController.text,
        "usertype": _radioType?.name.toString()
      };

      var response = await http.post(Uri.parse(register),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonresponse = jsonDecode(response.body);
      print(jsonresponse['status']);
      MotionToast(
        primaryColor: Colors.green.shade300,
        height: 80,
        width: double.maxFinite,
        description: Text(
          "สมัครสมาชิกสำเร็จ",
          style: TextStyle(fontSize: 20, color: Colors.green.shade500),
        ),
        icon: Icons.check_circle_outline_rounded,
        iconSize: 30,
      ).show(context);
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => const LoginUser()),
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
      appBar: Appbarmain(
        name: 'สมัครสมาชิก',
      ),
      backgroundColor: Whitecolor,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(),
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Fix CP",
                style: TextStyle(color: Whitecolor, fontSize: 25),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        Textmain(name: "ชื่อ"),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20, right: 15),
                          child: TextField(
                            keyboardType: TextInputType.name,
                            controller: fNameController,
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
                              errorText: _isNotValidate
                                  ? "กรุณากรอกข้อมูลให้ครบถ้วน"
                                  : null,
                              hintText: "ขื่อ",
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0))),
                              labelStyle: const TextStyle(fontSize: 20),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        Align(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10, left: 15),
                              child: Text(
                                "นามสกุล",
                                style: TextStyle(
                                    color: Bluelogocolor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            alignment: Alignment.centerLeft),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20, left: 15),
                          child: TextField(
                            keyboardType: TextInputType.name,
                            controller: lNameController,
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
                              errorText: _isNotValidate
                                  ? "กรุณากรอกข้อมูลให้ครบถ้วน"
                                  : null,
                              hintText: "นามสกุล",
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0))),
                              labelStyle: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  child: Column(
                    children: [
                      Textmain(name: "สถานะผู้ใช้งาน"),
                      Row(
                        children: [
                          Expanded(
                              child: RadioListTile<radioType>(
                            contentPadding: EdgeInsets.all(0),
                            title: Text(
                              "นักศึกษา",
                              style: TextStyle(
                                color: Whitecolor,
                              ),
                            ),
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => Whitecolor),
                            dense: true,
                            activeColor: Whitecolor,
                            value: radioType.Student,
                            groupValue: _radioType,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            tileColor: Bluelogocolor.withOpacity(0.8),
                            onChanged: (value) {
                              setState(() {
                                _radioType = value;
                              });
                            },
                          )),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: RadioListTile<radioType>(
                            contentPadding: EdgeInsets.all(0.0),
                            title: Text(
                              "TA",
                              style: TextStyle(
                                color: Whitecolor,
                              ),
                            ),
                            dense: true,
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => Whitecolor),
                            activeColor: Whitecolor,
                            value: radioType.TA,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            tileColor: Bluelogocolor.withOpacity(0.8),
                            groupValue: _radioType,
                            onChanged: (value) {
                              setState(() {
                                _radioType = value;
                              });
                            },
                          )),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: RadioListTile<radioType>(
                            contentPadding: EdgeInsets.all(0.0),
                            title: Text(
                              "อาจารย์",
                              style: TextStyle(
                                color: Whitecolor,
                              ),
                            ),
                            dense: true,
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => Whitecolor),
                            activeColor: Whitecolor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            tileColor: Bluelogocolor.withOpacity(0.8),
                            value: radioType.Professor,
                            groupValue: _radioType,
                            onChanged: (value) {
                              setState(() {
                                _radioType = value;
                              });
                            },
                          )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Textmain(name: "อีเมล"),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
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
                        hintText: "อีเมล",
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
                  Textmain(name: "รหัสผ่าน"),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _obscureText,
                      controller: passwordController,
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
                        hintText: "รหัสผ่าน",
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        labelStyle: const TextStyle(fontSize: 20),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscureText2,
                  controller: verpasswordController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Bluelogocolor,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    filled: true,
                    fillColor: Whitecolor,
                    errorStyle: TextStyle(color: Colors.red.shade400),
                    errorText:
                        _isNotValidate ? "กรุณากรอกข้อมูลให้ครบถ้วน" : null,
                    hintText: "ยืนยันรหัสผ่าน",
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    labelStyle: const TextStyle(fontSize: 20),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText2 = !_obscureText2;
                        });
                      },
                      icon: Icon(
                        _obscureText2 ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Textmain(name: "เบอร์โทรศัพท์"),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
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
                        hintText: "เบอร์โทรศัพท์",
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
                  if (verpasswordController.text != passwordController.text) {
                    MotionToast(
                      primaryColor: Colors.red.shade300,
                      height: 90,
                      width: double.maxFinite,
                      description: Center(
                        child: Text(
                          "กรอกรหัสผ่านและยืนยันรหัสผ่านให้ตรงกัน",
                          style: TextStyle(
                              fontSize: 17, color: Colors.red.shade500),
                        ),
                      ),
                      icon: Icons.warning_rounded,
                      iconSize: 30,
                    ).show(context);
                  } else {
                    registeruser();
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Bluelogocolor,
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 50,
                  child: const Center(
                      child: Text(
                    "สมัครสมาชิก",
                    style: TextStyle(
                        color: Whitecolor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Textmain extends StatelessWidget {
  final String name;
  final colors;
  const Textmain({super.key, required this.name, this.colors});

  @override
  Widget build(BuildContext context) {
    return Align(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            name,
            style: TextStyle(
                color: colors ?? Bluelogocolor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        alignment: Alignment.centerLeft);
  }
}
