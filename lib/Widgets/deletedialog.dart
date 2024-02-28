import 'package:fix_cp/Widgets/Color.dart';
import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final String message;
  final String name;
  final Function onConfirm;

  const DeleteDialog({
    Key? key,
    required this.message,
    required this.onConfirm,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        Icons.delete_forever_rounded,
        color: Colors.red.shade400,
        size: 30,
      ),
      backgroundColor: Whitecolor,
      title: Text(
        'ยืนยันการลบ $name',
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('ยกเลิก',
              style: TextStyle(color: Colors.orangeAccent.shade400)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: Text('ใช่', style: TextStyle(color: Colors.red.shade400)),
        ),
      ],
    );
  }
}
