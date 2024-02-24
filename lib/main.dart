import 'package:fix_cp/Pages/basepages.dart';
import 'package:fix_cp/Pages/login.dart';
import 'package:fix_cp/Pages/register.dart';
import 'package:fix_cp/Widgets/Color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Bluelogocolor,
        fontFamily: GoogleFonts.ibmPlexSansThai().fontFamily,
      ),
      home: LoginUser(),
    );
  }
}