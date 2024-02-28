import 'package:fix_cp/Pages/login.dart';
import 'package:fix_cp/Widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class staffPage extends StatefulWidget {
  final token;
  const staffPage({super.key, this.token});

  @override
  State<staffPage> createState() => _staffPageState();
}

class _staffPageState extends State<staffPage> {
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
      appBar: Appbarmain(name: "การแจ้งซ่อมทั้งหมด",autoLeading: false),
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
