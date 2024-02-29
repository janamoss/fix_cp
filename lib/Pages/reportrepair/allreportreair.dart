import 'dart:convert';

import 'package:fix_cp/Pages/basepages.dart';
import 'package:fix_cp/Pages/profile.dart';
import 'package:fix_cp/Pages/register.dart';
import 'package:fix_cp/Widgets/Color.dart';
import 'package:fix_cp/Widgets/appbar.dart';
import 'package:fix_cp/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class AllreportPages extends StatefulWidget {
  final token;
  const AllreportPages({super.key, this.token});

  @override
  State<AllreportPages> createState() => _AllreportPagesState();
}

class _AllreportPagesState extends State<AllreportPages> {
  late String email;
  late String usertype;
  late String name;
  late String user_id;

  String _lastUserId = '';

  String? _seletedstatus;

  List? itemreport;
  List? itemuser;
  List<bool> _showDropdown = [];

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
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    usertype = jwtDecodedToken['usertype'];
    name = jwtDecodedToken['name'];
    user_id = jwtDecodedToken['_id'];
    itemreport = [];
    itemuser = [];
    getreort();
    getalluser();
  }

  void getreort() async {
    var response = await http.get(Uri.parse(getreportrepair),
        headers: {"Content-Type": "application/json"});

    var jsonresponse = jsonDecode(response.body);
    setState(() {
      itemreport = jsonresponse['success'];
      _showDropdown = List.filled(itemreport!.length, false);
    });
  }

  void editstatus(reportid) async {
    var reqBody = {
      "reportId": reportid,
      "newStatus": _seletedstatus,
    };

    var response = await http.post(Uri.parse(editstatusss),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));
    var jsonresponse = jsonDecode(response.body);
    if (jsonresponse["status"]) {
      print(jsonresponse["success"]);
      Navigator.pop(context);
      Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => basePages(
                  token: widget.token,
                  selectedIndexs: 0
                )),
      );
    } else {}
    itemreport = [];
    getreort();
  }

  void getalluser() async {
    var response = await http
        .get(Uri.parse(alluser), headers: {"Content-Type": "application/json"});

    var jsonresponse = jsonDecode(response.body);
    setState(() {
      itemuser = jsonresponse['success'];
      print(itemuser);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Whitecolor,
      appBar: Appbarmain(name: "การแจ้งซ่อมทั้งหมด", autoLeading: false),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: buildList(),
      ),
    );
  }

  Widget buildList() => ListView.builder(
        itemCount: itemreport!.length,
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
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: itemreport![index]["status"] == "รอการแก้ไข"
                          ? Colors.orangeAccent.shade400
                          : Colors.green.shade400,
                    ),
                    child: Icon(
                      itemreport![index]["status"] == "รอการแก้ไข"
                          ? Icons.timer_rounded
                          : Icons.done,
                      color: Whitecolor,
                      size: 35,
                    ),
                  ),
                  title: Text(
                    'รายการที่ ${index + 1}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Whitecolor),
                  ),
                  subtitle: Column(
                    children: [
                      for (var user in itemuser!)
                        if (user["_id"] == itemreport![index]["iduser"])
                          Text(
                            'ผู้ใช้งาน: ${user["name"]} \nเบอร์ติดต่อ: ${user["phonenumber"]}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15, color: DarkBluelogocolor),
                          ),
                      Text(
                        'อุปกรณ์: ${itemreport![index]["device"]} ห้อง ${itemreport![index]["location"]}',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 15, color: DarkBluelogocolor),
                      ),
                    ],
                  ),
                  trailing: itemreport! != null
                      ? RotatedBox(
                          quarterTurns: 1,
                          child: Icon(
                            _showDropdown[index]
                                ? Icons.keyboard_arrow_left_rounded
                                : Icons.keyboard_arrow_right_rounded,
                            color: Whitecolor,
                          ),
                        )
                      : SizedBox(),
                ),
                _showDropdown[index]
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(15)),
                          color: Whitecolor,
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  _seletedstatus = '${itemreport![index]["status"]}';
                                  dialogeditstatus(
                                      context, '${itemreport![index]["_id"]}');
                                },
                                label: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "เปลี่ยนสถานะการซ่อม",
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
                                    backgroundColor: MaterialStatePropertyAll(
                                        Color.fromARGB(255, 246, 186, 83))),
                                icon: Icon(Icons.edit,
                                    color: Whitecolor, size: 20),
                              ),
                              historys(
                                input: "${itemreport![index]["status"]}",
                                statusname: "สถานะ",
                              ),
                              historys(
                                input: "${itemreport![index]["equipmentNo"]}",
                                statusname: "หมายเลขครุภัณฑ์",
                              ),
                              historys(
                                input: "${itemreport![index]["symptom"]}",
                                statusname: "อาการ",
                              ),
                              itemreport![index]["imagesymptom"] != null
                                  ? Textmain(name: "ภาพอาการ")
                                  : SizedBox(),
                              itemreport![index]["imagesymptom"] != null
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      child: Image.memory(
                                        base64Decode(
                                            itemreport![index]["imagesymptom"]),
                                        fit: BoxFit.cover,
                                        width: 300,
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 20,
                              )
                            ]),
                      )
                    : SizedBox(),
              ],
            )),
      ),
    );
  }

  Future<void> dialogeditstatus(BuildContext context, String input) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            icon: Icon(
              Icons.edit,
              color: Bluelogocolor2,
              size: 30,
            ),
            backgroundColor: Whitecolor,
            title: Text(
              'แก้ไขสถานะการแจ้งซ่อม',
            ),
            content: Container(
              width: MediaQuery.sizeOf(context).width * 0.8,
              height: MediaQuery.sizeOf(context).width * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Textmain(name: "สถานะการแจ้งซ่อม"),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: StatefulBuilder(
                            builder: (context, setState) => DropdownButton(
                              items: <String>[
                                'รอการแก้ไข',
                                'แก้ไขเสร็จสิ้น',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    children: [
                                      Text(
                                        value,
                                        style: TextStyle(color: Bluelogocolor),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _seletedstatus = value;
                                });
                              },
                              hint: Text(
                                "กรุณาเลือกสถานะ",
                                style: TextStyle(
                                    color: Bluelogocolor, fontSize: 17),
                              ),
                              value: _seletedstatus,
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
                  editstatus(input);
                  setState(() {
                    _seletedstatus = null;
                  });
                },
                label: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "เสร็จสิ้น",
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

class historys extends StatelessWidget {
  final statusname;
  final input;
  const historys({super.key, this.statusname, this.input});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Textmain(name: statusname, fontsize: 12),
          flex: 1,
        ),
        Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, right: 15),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(input)),
            ))
      ],
    );
  }
}
