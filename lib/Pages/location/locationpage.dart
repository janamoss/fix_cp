import 'dart:convert';

import 'package:fix_cp/Pages/location/addlocation.dart';
import 'package:fix_cp/Pages/register.dart';
import 'package:fix_cp/Widgets/Color.dart';
import 'package:fix_cp/Widgets/appbar.dart';
import 'package:fix_cp/Widgets/deletedialog.dart';
import 'package:fix_cp/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';

class loactionPage extends StatefulWidget {
  final token;
  const loactionPage({super.key, this.token});

  @override
  State<loactionPage> createState() => _loactionPageState();
}

class _loactionPageState extends State<loactionPage> {
  List<bool> _showDropdown = [];
  late String email;
  late String usertype;
  late List? itemdevices;
  late List? items;

  String? _selectedDevice;

  Map<String, IconData> icons = {
    "หมวดหมู่เครื่องใช้ไฟฟ้า": Icons.monitor_rounded,
    "หมวดหมู่คอมพิวเตอร์": Icons.memory_rounded,
    "หมวดหมู่ประปา": Icons.water_damage_rounded,
    "หมวดหมู่ไฟฟ้า": Icons.electric_bolt_rounded,
    "หมวดหมู่อื่นๆ": Icons.devices_other_rounded,
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = [];
    itemdevices = [];
    getAllLoactions();
    getAllDevices();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    usertype = jwtDecodedToken['usertype'];
  }

  void addlistDevices(locationid) async {
    var reqBody = {
      "locationId": locationid,
      "device": _selectedDevice,
    };

    var response = await http.post(Uri.parse(addlistdevices),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));
    var jsonresponse = jsonDecode(response.body);
    if (jsonresponse["status"]) {
      Navigator.pop(context);
    } else {}
    items = [];
    getAllLoactions();
  }

  void getAllDevices() async {
    var response = await http.get(Uri.parse(getdevices),
        headers: {"Content-Type": "application/json"});
    var jsonresponse = jsonDecode(response.body);
    setState(() {
      itemdevices = jsonresponse['success'];
    });
  }

  void getAllLoactions() async {
    var response = await http.get(Uri.parse(getlocation),
        headers: {"Content-Type": "application/json"});
    var jsonresponse = jsonDecode(response.body);
    setState(() {
      items = jsonresponse['success'];
      _showDropdown = List.filled(items!.length, false);
    });
  }

  void deleteLocation(id) async {
    var reqBody = {
      "id": id,
    };
    var response = await http.post(Uri.parse(deletelocation),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));
    var jsonresponse = jsonDecode(response.body);
    MotionToast(
        primaryColor: Colors.green.shade400,
        height: 80,
        width: double.maxFinite,
        description: Text(
          "ลบห้องสำเร็จ",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.green.shade400),
        ),
        icon: Icons.delete,
        iconSize: 30,
      ).show(context);
    items = [];
    getAllLoactions();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Whitecolor,
      appBar: Appbarmain(
        name: "ห้อง",
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
                            builder: (context) => addLocationPage(
                                  token: widget.token,
                                )),
                      );
                    },
                    label: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "เพิ่มห้อง",
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
                    leading: Icon(
                      Icons.business_rounded,
                      color: Whitecolor,
                      size: 40,
                    ),
                    title: Text(
                      '${items![index]["name"]}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, color: Whitecolor),
                    ),
                    subtitle: Column(
                      children: [
                        Text(
                          'ชั้น : ${items![index]["floor"]} อาคาร : ${items![index]["building"]}',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 20, color: DarkBluelogocolor),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'จำนวนอุปกรณ์ : ${items![index]["listDevices"].length}',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 20, color: DarkBluelogocolor),
                        ),
                      ],
                    ),
                    trailing: RotatedBox(
                      quarterTurns: 1,
                      child: Icon(
                        _showDropdown[index]
                            ? Icons.keyboard_arrow_left_rounded
                            : Icons.keyboard_arrow_right_rounded,
                        color: Whitecolor,
                      ),
                    )),
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
                                      dialogadddevice(
                                          context, '${items![index]["_id"]}');
                                    },
                                    label: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "เพิ่มอุปกรณ์",
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
                                        child: SizedBox(
                                  width: double.maxFinite,
                                  height: 50,
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    label: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "แก้ไขห้อง",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Whitecolor, fontSize: 13),
                                      ),
                                    ),
                                    style: ButtonStyle(
                                        shape: MaterialStatePropertyAll(
                                            ContinuousRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.zero)),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.orange.shade300)),
                                    icon: Icon(Icons.edit_note_rounded,
                                        color: Whitecolor, size: 20),
                                  ),
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
                                          message: 'คุณต้องการลบห้องนี้หรือไม่',
                                          onConfirm: () {
                                            deleteLocation(
                                                '${items![index]["_id"]}');
                                          },
                                        ),
                                      );
                                      // deleteLocation('${items![index]["_id"]}');
                                    },
                                    label: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "ลบห้อง",
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

  Future<void> dialogadddevice(BuildContext context, String input) async {
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
              'เพิ่มอุปกรณ์',
            ),
            content: Container(
              width: MediaQuery.sizeOf(context).width * 0.8,
              height: MediaQuery.sizeOf(context).width * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Textmain(name: "อุปกรณ์"),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: StatefulBuilder(
                            builder: (context, setState) => DropdownButton(
                              items: itemdevices!
                                  .map<DropdownMenuItem<String>>((item) {
                                return DropdownMenuItem<String>(
                                  value: item['name'],
                                  child: Row(
                                    children: [
                                      icons[item['iconname']] != null
                                          ? Icon(
                                              icons[item['iconname']]!,
                                              color: Bluelogocolor,
                                            )
                                          : SizedBox(),
                                      SizedBox(width: 15),
                                      Text(
                                        item['name'],
                                        style: TextStyle(color: Bluelogocolor),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedDevice = value;
                                });
                              },
                              hint: Text(
                                "กรุณาเลือกอุปกรณ์",
                                style: TextStyle(
                                    color: Bluelogocolor, fontSize: 17),
                              ),
                              value: _selectedDevice,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton.icon(
                onPressed: () {
                  addlistDevices(input);
                  setState(() {
                    _selectedDevice = null;
                  });
                },
                label: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "เพิ่มอุปกรณ์",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Whitecolor, fontSize: 20),
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
