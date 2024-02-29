import 'package:fix_cp/Widgets/Color.dart';
import 'package:flutter/material.dart';

class BottomNavBarUser extends StatefulWidget {
  final int selectedIndex; // Receive selectedIndex from _BasePageState
  final Function(int) onItemTapped; // Receive callback function

  const BottomNavBarUser({
    required this.selectedIndex,
    required this.onItemTapped,
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavBarUser> createState() => _BottomNavBarUserState();
}

class _BottomNavBarUserState extends State<BottomNavBarUser> {
  final int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Bluelogocolor2,
      backgroundColor: DarkBluelogocolor,
      unselectedItemColor: Whitecolor,
      elevation: 0,
      items: [
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.home_rounded, color: Bluelogocolor2),
          icon: Icon(Icons.home_rounded, color: Whitecolor),
          label: 'หน้าหลัก',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.checklist_rounded, color: Bluelogocolor2),
          icon: Icon(Icons.checklist_rounded, color: Whitecolor),
          label: 'การแจ้งซ่อมของฉัน',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.person, color: Bluelogocolor2),
          icon: Icon(Icons.person, color: Whitecolor),
          label: 'โปรไฟล์',
        ),
      ],
      currentIndex:
          widget.selectedIndex, // Set currentIndex using received selectedIndex
      onTap: widget.onItemTapped, // Call the callback function on tap
    );
  }
}

class BottomNavBarAdmin extends StatefulWidget {
  final int selectedIndex; // Receive selectedIndex from _BasePageState
  final Function(int) onItemTapped; // Receive callback function

  const BottomNavBarAdmin({
    required this.selectedIndex,
    required this.onItemTapped,
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavBarAdmin> createState() => _BottomNavBarAdminState();
}

class _BottomNavBarAdminState extends State<BottomNavBarAdmin> {
  final int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Bluelogocolor2,
      backgroundColor: DarkBluelogocolor,
      unselectedItemColor: Whitecolor,
      elevation: 0,
      items: [
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.home_rounded, color: Bluelogocolor2),
          icon: Icon(Icons.home_rounded, color: Whitecolor),
          label: 'การแจ้งซ่อมทั้งหมด',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.room_rounded, color: Bluelogocolor2),
          icon: Icon(Icons.room_rounded, color: Whitecolor),
          label: 'ห้อง',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.devices, color: Bluelogocolor2),
          icon: Icon(Icons.devices, color: Whitecolor),
          label: 'อุปกรณ์',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.person, color: Bluelogocolor2),
          icon: Icon(Icons.person, color: Whitecolor),
          label: 'โปรไฟล์',
        ),
      ],
      currentIndex:
          widget.selectedIndex, // Set currentIndex using received selectedIndex
      onTap: widget.onItemTapped, // Call the callback function on tap
    );
  }
}
