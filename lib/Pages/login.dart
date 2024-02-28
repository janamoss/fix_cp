import 'dart:convert';

import 'package:fix_cp/Pages/basepages.dart';
import 'package:fix_cp/Pages/register.dart';
import 'package:fix_cp/Widgets/Color.dart';
import 'package:fix_cp/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isNotValidate = false;
  bool _obscureText = true;

  late SharedPreferences prefs;

  void loginuser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      var response = await http.post(Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));
      var jsonresponse = jsonDecode(response.body);
      if (jsonresponse['status']) {
        var myToken = jsonresponse['token'];
        prefs.setString('token', myToken);
        MotionToast(
          primaryColor: Colors.green.shade300,
          description: Text(
            "เข้าสู่ระบบสำเร็จ",
            style: TextStyle(fontSize: 20, color: Colors.green.shade500),
          ),
          height: 80,
          width: double.maxFinite,
          icon: Icons.check_circle_outline_rounded,
          iconSize: 30,
        ).show(context);
        Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => basePages(
                    token: myToken,
                  )),
        );
      } else {}
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPre();
  }

  void initSharedPre() async {
    prefs = await SharedPreferences.getInstance();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Whitecolor,
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Image.asset(
                "assets/images/Login.jpeg",
                fit: BoxFit.cover,
                width: double.maxFinite,
              ),
            ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 35,
                  ),
                  decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(50))),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/FixCP2.png",
                        fit: BoxFit.cover,
                        height: 150,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          "แจ้งซ่อมออนไลน์ \nคณะวิทยาลัยการคอมพิวเตอร์",
                          style: TextStyle(
                              color: Bluelogocolor,
                              fontSize: 27,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "เข้าสู่ระบบ",
                            style: TextStyle(
                                color: Bluelogocolor,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
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
                            errorText: _isNotValidate
                                ? "กรุณากรอกข้อมูลให้ครบถ้วน"
                                : null,
                            hintText: "อีเมล",
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            labelStyle: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
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
                            errorText: _isNotValidate
                                ? "กรุณากรอกข้อมูลให้ครบถ้วน"
                                : null,
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
                      ElevatedButton(
                        onPressed: () {
                          loginuser();
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
                            "เข้าสู่ระบบ",
                            style: TextStyle(
                                color: Whitecolor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "ถ้าหากคุณยังไม่มีบัญชี",
                            style:
                                TextStyle(color: Bluelogocolor, fontSize: 17),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const RegisterUser()),
                                );
                              },
                              child: const Text(
                                "สมัครสมาชิก",
                                style: TextStyle(
                                    color: Bluelogocolor,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Bluelogocolor,
                                    fontSize: 17),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

// Column(
//           children: [
//             Image.asset("assets/images/Login.jpeg"),
//           ],
//         )

