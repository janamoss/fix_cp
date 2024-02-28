import 'package:fix_cp/Pages/login.dart';
import 'package:fix_cp/Widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class userHome extends StatefulWidget {
  final token;

  const userHome({super.key, this.token});

  @override
  State<userHome> createState() => _userHomeState();
}

class _userHomeState extends State<userHome> {
  late String email;
  late String usertype;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    usertype = jwtDecodedToken['usertype'];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarmain(name: "หน้าหลัก",autoLeading: false),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text(email)),
          Center(
              child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('token');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginUser()),
                    );
                  },
                  child: Text("ออกจากระบบ")))
        ],
      ),
    );
  }
}
