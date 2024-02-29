import 'package:fix_cp/Pages/login.dart';
import 'package:fix_cp/Pages/register.dart';
import 'package:fix_cp/Widgets/Color.dart';
import 'package:fix_cp/Widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profilePage extends StatefulWidget {
  final token;

  const profilePage({super.key, this.token});

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  late String email;
  late String usertype;
  late String name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    usertype = jwtDecodedToken['usertype'];
    name = jwtDecodedToken['name'];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarmain(
        name: "โปรไฟล์",
        autoLeading: false,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  "assets/images/profile.png",
                  fit: BoxFit.cover,
                  width: MediaQuery.sizeOf(context).width * 0.5,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Profiles(input: name, statusname: "ชื่อ"),
            Profiles(input: email, statusname: "อีเมล"),
            Row(
              children: [
                Expanded(
                  child: Textmain(
                    name: "สถานะผู้ใช้งาน",
                    fontsize: 20,
                  ),
                  flex: 3,
                ),
                Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20, right: 15),
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Bluelogocolor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          filled: true,
                          enabled: false,
                          fillColor: Whitecolor,
                          hintText: usertype,
                          border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Bluelogocolor),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              )),
                          labelStyle: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ))
              ],
            ),
            Center(
                child: ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('token');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginUser()),
                );
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
                  "ออกจากระบบ",
                  style: TextStyle(
                      color: Whitecolor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class Profiles extends StatelessWidget {
  final statusname;
  final input;
  const Profiles({super.key, this.statusname, this.input});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Textmain(name: statusname),
          flex: 1,
        ),
        Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, right: 15),
              child: TextField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Bluelogocolor,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  filled: true,
                  enabled: false,
                  fillColor: Whitecolor,
                  hintText: input,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Bluelogocolor),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      )),
                  labelStyle: const TextStyle(fontSize: 20),
                ),
              ),
            ))
      ],
    );
  }
}
