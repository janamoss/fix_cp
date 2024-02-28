import 'dart:convert';

import 'package:fix_cp/Pages/location/addlocation.dart';
import 'package:fix_cp/Widgets/Color.dart';
import 'package:fix_cp/Widgets/appbar.dart';
import 'package:fix_cp/Widgets/deletedialog.dart';
import 'package:fix_cp/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

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

  late List? items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = [];
    getAllLoactions();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    usertype = jwtDecodedToken['usertype'];
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
                    subtitle: Text(
                      'ชั้น : ${items![index]["floor"]} อาคาร : ${items![index]["building"]}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: DarkBluelogocolor),
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
}
