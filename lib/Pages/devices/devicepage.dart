import 'dart:convert';

import 'package:fix_cp/Pages/basepages.dart';
import 'package:fix_cp/Pages/devices/adddevice.dart';
import 'package:fix_cp/Pages/register.dart';
import 'package:fix_cp/Widgets/Color.dart';
import 'package:fix_cp/Widgets/appbar.dart';
import 'package:fix_cp/Widgets/deletedialog.dart';
import 'package:fix_cp/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:motion_toast/motion_toast.dart';

class devicePage extends StatefulWidget {
  final token;
  const devicePage({super.key, this.token});

  @override
  State<devicePage> createState() => _devicePageState();
}

class _devicePageState extends State<devicePage> {
  TextEditingController eqNoController = TextEditingController();

  List<bool> _showDropdown = [];
  late String email;
  late String usertype;
  late List? items;

  bool _isNotValidate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = [];
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    usertype = jwtDecodedToken['usertype'];
    getAllDevices();
  }

  void getAllDevices() async {
    var response = await http.get(Uri.parse(getdevices),
        headers: {"Content-Type": "application/json"});
    var jsonresponse = jsonDecode(response.body);
    setState(() {
      items = jsonresponse['success'];
      _showDropdown = List.filled(items!.length, false);
    });
  }

  void addEqno(deviceid) async {
    if (eqNoController.text.isNotEmpty) {
      var reqBody = {
        "deviceid": deviceid,
        "equipment": eqNoController.text,
      };

      var response = await http.post(Uri.parse(addequipmentNo),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonresponse = jsonDecode(response.body);
      print(jsonresponse['status']);
      MotionToast(
        primaryColor: Colors.green.shade300,
        height: 80,
        width: double.maxFinite,
        description: Text(
          "เพิ่มหมายเลขครุภัณฑ์ภัสำเร็จ",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.green.shade500),
        ),
        icon: Icons.check_circle_outline_rounded,
        iconSize: 30,
      ).show(context);
      Navigator.pop(context);
      Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                basePages(token: widget.token, selectedIndexs: 2)),
      );
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  void deleteDevices(id) async {
    var reqBody = {
      "id": id,
    };
    var response = await http.post(Uri.parse(deleteDevice),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));
    var jsonresponse = jsonDecode(response.body);
    MotionToast(
      primaryColor: Colors.green.shade400,
      height: 80,
      width: double.maxFinite,
      description: Text(
        "ลบอุปกรณ์สำเร็จ",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: Colors.green.shade400),
      ),
      icon: Icons.delete,
      iconSize: 30,
    ).show(context);
    items = [];
    getAllDevices();
  }

  Map<String, IconData> icons = {
    "หมวดหมู่เครื่องใช้ไฟฟ้า": Icons.monitor_rounded,
    "หมวดหมู่คอมพิวเตอร์": Icons.memory_rounded,
    "หมวดหมู่ประปา": Icons.water_damage_rounded,
    "หมวดหมู่ไฟฟ้า": Icons.electric_bolt_rounded,
    "หมวดหมู่อื่นๆ": Icons.devices_other_rounded,
  };

  Widget build(BuildContext context) {
    bool _showDropdown = false;
    return Scaffold(
      backgroundColor: Whitecolor,
      appBar: Appbarmain(
        name: "หมวดหมู่อุปกรณ์",
        autoLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Align(
                  child: Text(
                    "รายชื่อ",
                    style: TextStyle(color: Bluelogocolor, fontSize: 20),
                  ),
                  alignment: Alignment.centerLeft,
                )),
                Expanded(
                    child: Align(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => addDevicePage(
                                  token: widget.token,
                                )),
                      );
                    },
                    label: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "เพิ่มหมวดหมู่\nอุปกรณ์",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Whitecolor, fontSize: 13),
                      ),
                    ),
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(
                            ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.green.shade400)),
                    icon: Icon(Icons.add, color: Whitecolor, size: 35),
                  ),
                  alignment: Alignment.centerRight,
                )),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: buildList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildList() => ListView.builder(
        itemCount: items!.length,
        itemBuilder: (context, index) {
          return buildListItem(index);
        },
      );

  Widget buildListItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showDropdown[index] = !_showDropdown[index];
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Card(
            margin: EdgeInsets.only(left: 0.0),
            color: Bluelogocolor2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 4,
            child: Column(
              children: [
                ListTile(
                    leading: icons['${items![index]["iconname"]}'] != null
                        ? Icon(
                            icons['${items![index]["iconname"]}']!,
                            color: Whitecolor,
                          )
                        : SizedBox(),
                    title: Text(
                      '${items![index]["name"]}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Whitecolor),
                    ),
                    subtitle: Text(
                      'จำนวนอุปกรณ์: ${items![index]["equipmentNo"].length}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: DarkBluelogocolor),
                    ),
                    trailing: items![index]["equipmentNo"].length >= 0
                        ? RotatedBox(
                            quarterTurns: 1,
                            child: Icon(
                              _showDropdown[index]
                                  ? Icons.keyboard_arrow_left_rounded
                                  : Icons.keyboard_arrow_right_rounded,
                              color: Whitecolor,
                            ),
                          )
                        : SizedBox()),
                _showDropdown[index]
                    ? Column(
                        children: [
                          Card(
                            margin: EdgeInsets.only(left: 0.0),
                            color: Bluelogocolor2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(15)),
                            ),
                            elevation: 6,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Center(
                                        child: SizedBox(
                                  width: double.maxFinite,
                                  height: 50,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      dialogaddEqNo(
                                          context, '${items![index]["_id"]}');
                                    },
                                    label: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "เพิ่มเลขครุภัณฑ์",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Whitecolor, fontSize: 13),
                                      ),
                                    ),
                                    style: ButtonStyle(
                                        shape: MaterialStatePropertyAll(
                                            ContinuousRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(15)))),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.green.shade400)),
                                    icon: Icon(Icons.add,
                                        color: Whitecolor, size: 20),
                                  ),
                                ))),
                                Expanded(
                                    child: Center(
                                        child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   CupertinoPageRoute(
                                    //       builder: (context) => addDevicePage(
                                    //             token: widget.token,
                                    //           )),
                                    // );
                                  },
                                  label: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      "แก้ไขอุปกรณ์",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Whitecolor, fontSize: 13),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                          ContinuousRectangleBorder(
                                              borderRadius: BorderRadius.zero)),
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.orange.shade300)),
                                  icon: Icon(Icons.edit_note_rounded,
                                      color: Whitecolor, size: 20),
                                ))),
                                Expanded(
                                    child: Center(
                                        child: SizedBox(
                                  width: double.maxFinite,
                                  height: 50,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => DeleteDialog(
                                          name: '${items![index]["name"]}',
                                          message:
                                              'คุณต้องการลบอุปกรณ์นี้หรือไม่',
                                          onConfirm: () {
                                            deleteDevices(
                                                '${items![index]["_id"]}');
                                          },
                                        ),
                                      );
                                    },
                                    label: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "ลบอุปกรณ์",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Whitecolor, fontSize: 13),
                                      ),
                                    ),
                                    style: ButtonStyle(
                                        shape: MaterialStatePropertyAll(
                                            ContinuousRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(15)))),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.red.shade400)),
                                    icon: Icon(Icons.delete_rounded,
                                        color: Whitecolor, size: 20),
                                  ),
                                ))),
                              ],
                            ),
                          )
                        ],
                      )
                    : SizedBox()
              ],
            )),
      ),
    );
  }

  Future<void> dialogaddEqNo(BuildContext context, String input) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            icon: Icon(
              Icons.add_box_rounded,
              color: Bluelogocolor2,
              size: 30,
            ),
            backgroundColor: Whitecolor,
            title: Text(
              'เพิ่มหมายเลขครุภัณฑ์',
            ),
            content: Container(
              width: MediaQuery.sizeOf(context).width * 0.8,
              height: MediaQuery.sizeOf(context).width * 0.25,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Textmain(name: "หมายเลขครุภัณฑ์"),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            controller: eqNoController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Bluelogocolor,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              filled: true,
                              fillColor: Whitecolor,
                              errorStyle: TextStyle(color: Colors.red.shade400),
                              errorText: _isNotValidate
                                  ? "กรุณากรอกข้อมูลให้ครบถ้วน"
                                  : null,
                              hintText: "หมายเลขครุภัณฑ์",
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0))),
                              labelStyle: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton.icon(
                onPressed: () {
                  addEqno(input);
                  setState(() {});
                },
                label: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "เพิ่มหมายเลขครุภัณฑ์",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Whitecolor, fontSize: 13),
                  ),
                ),
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15)))),
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.green.shade400)),
                icon: Icon(Icons.add, color: Whitecolor, size: 20),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('ยกเลิก',
                    style: TextStyle(
                        color: Colors.orangeAccent.shade400, fontSize: 20)),
              ),
            ],
          );
        });
  }
}
