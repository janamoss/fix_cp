import 'package:fix_cp/Widgets/Color.dart';
import 'package:flutter/material.dart';

class Appbarmain extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final autoLeading;
  final widget;
  final colors;
  const Appbarmain(
      {required this.name, this.autoLeading, this.widget, this.colors});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: autoLeading ?? true,
      backgroundColor: Whitecolor,
      centerTitle: true,
      iconTheme: IconThemeData(color: colors ?? Bluelogocolor),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget != null
              ? Icon(widget, color: colors ?? Bluelogocolor)
              : SizedBox(),
          Text(
            name,
            style: TextStyle(color: colors ?? Bluelogocolor, fontSize: 30),
          ),
        ],
      ),
    );
  }
}
