import 'package:fix_cp/Widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class profilePage extends StatefulWidget {
  final token;

  const profilePage({super.key, this.token});

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
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
      appBar: Appbarmain(
        name: "โปรไฟล์",
        autoLeading: false,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
        child: Column(
          children: [
            Image.asset("assets/images/profile.png")
          ],
        ),
      ),
    );
  }
}
