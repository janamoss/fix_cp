import 'package:fix_cp/Pages/basepages.dart';
import 'package:fix_cp/Pages/login.dart';
import 'package:fix_cp/Pages/register.dart';
import 'package:fix_cp/Widgets/Color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  runApp(Myapp(token: token));
}

class Myapp extends StatelessWidget {
  final token;
  const Myapp({super.key, @required this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Bluelogocolor,
        fontFamily: GoogleFonts.ibmPlexSansThai().fontFamily,
      ),
      home: (token == null)
          ? LoginUser()
          : (JwtDecoder.isExpired(token) == false)
              ? basePages(token: token)
              : LoginUser(),
    );
  }
}
// (JwtDecoder.isExpired(token) == false)
//           ? basePages(token: token)
//           : 