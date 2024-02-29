import 'package:fix_cp/Pages/devices/devicepage.dart';
import 'package:fix_cp/Pages/location/locationpage.dart';
import 'package:fix_cp/Pages/login.dart';
import 'package:fix_cp/Pages/profile.dart';
import 'package:fix_cp/Pages/reportrepair/allreportreair.dart';
import 'package:fix_cp/Pages/reportrepair/historyreportuser.dart';
import 'package:fix_cp/Pages/staffhome.dart';
import 'package:fix_cp/Pages/userhome.dart';
import 'package:fix_cp/Widgets/bottomNav.dart';
import 'package:flutter/material.dart';
import "package:jwt_decoder/jwt_decoder.dart";
import 'package:shared_preferences/shared_preferences.dart';

class basePages extends StatefulWidget {
  final token;
  final selectedIndexs;
  const basePages({super.key, this.token, this.selectedIndexs});

  @override
  State<basePages> createState() => _basePagesState();
}

class _basePagesState extends State<basePages> {
  late List<Widget> _widgetOption;
  bool checkbotbar = false;
  int selectedIndex = 0;
  late String email;
  late String usertype;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndexs ?? 0;
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    usertype = jwtDecodedToken['usertype'];
    if (usertype == "Student" || usertype == "TA" || usertype == "Professor") {
      checkbotbar = true;
    } else {
      checkbotbar = false;
    }

    _widgetOption = [
      usertype == "Student" || usertype == "TA" || usertype == "Professor"
          ? userHome(
              token: widget.token,
            )
          : AllreportPages(token: widget.token),
      usertype == "Student" || usertype == "TA" || usertype == "Professor"
          ? HistoryreportPages(token: widget.token)
          : loactionPage(
              token: widget.token,
            ),
      usertype == "Student" || usertype == "TA" || usertype == "Professor"
          ? profilePage(token: widget.token)
          : devicePage(token: widget.token),
      profilePage(token: widget.token),
    ];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: checkbotbar
          ? BottomNavBarUser(
              selectedIndex:
                  selectedIndex, // Pass selectedIndex to BottomNavBar
              onItemTapped: (int index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            )
          : BottomNavBarAdmin(
              selectedIndex:
                  selectedIndex, // Pass selectedIndex to BottomNavBar
              onItemTapped: (int index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
      body: Center(
        child: _widgetOption.elementAt(selectedIndex),
      ),
    );
  }
}
