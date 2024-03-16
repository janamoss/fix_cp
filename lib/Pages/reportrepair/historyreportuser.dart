import 'dart:convert';

import 'package:fix_cp/Pages/profile.dart';
import 'package:fix_cp/Pages/register.dart';
import 'package:fix_cp/Widgets/Color.dart';
import 'package:fix_cp/Widgets/appbar.dart';
import 'package:fix_cp/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class HistoryreportPages extends StatefulWidget {
  final token;
  const HistoryreportPages({super.key, this.token});

  @override
  State<HistoryreportPages> createState() => _HistoryreportPagesState();
}

class _HistoryreportPagesState extends State<HistoryreportPages> {
  late String email;
  late String usertype;
  late String name;
  late String user_id;

  String? dateString;
  String? timeString;

  List? itemhistory;
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
    itemhistory = [];
    getHistory(user_id);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 224, 242, 250),
      appBar: Appbarmain(name: "ประวัติแจ้งซ่อม", autoLeading: false),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: buildList(),
      ),
    );
  }

  formatDateShort(timestamp) {
    initializeDateFormatting("th");
    DateTime date = DateTime.parse(timestamp);
    DateFormat dateFormat = DateFormat('dd MMM yyyy', 'th');
    return dateFormat.format(date);
  }

  formatTime(timestamp) {
    initializeDateFormatting("th");
    DateTime date = DateTime.parse(timestamp);
    DateFormat timeFormat = DateFormat('HH:mm', 'th');
    return timeFormat.format(date);
  }

  void getHistory(user_id) async {
    var reqBody = {
      "user_id": user_id,
    };

    var response = await http.post(Uri.parse(history),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));

    var jsonresponse = jsonDecode(response.body);
    setState(() {
      itemhistory = jsonresponse['success'];
      print(itemhistory);
      _showDropdown = List.filled(itemhistory!.length, false);
    });
  }

  Widget buildList() => ListView.builder(
        itemCount: itemhistory!.length,
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
                      color: itemhistory![index]["status"] == "รอการแก้ไข"
                          ? Colors.orangeAccent.shade400
                          : Colors.green.shade400,
                    ),
                    child: Icon(
                      itemhistory![index]["status"] == "รอการแก้ไข"
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
                  subtitle: Text(
                    'อุปกรณ์: ${itemhistory![index]["device"]} ห้อง ${itemhistory![index]["location"]}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: DarkBluelogocolor),
                  ),
                  trailing: itemhistory! != null
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
                              historys(
                                input: formatDateShort(
                                        '${itemhistory![index]["date"]}') +
                                    " " +
                                    formatTime(
                                        '${itemhistory![index]["date"]}'),
                                statusname: "วันที่",
                              ),
                              historys(
                                input: "${itemhistory![index]["status"]}",
                                statusname: "สถานะ",
                              ),
                              historys(
                                input: "${itemhistory![index]["equipmentNo"]}",
                                statusname: "หมายเลขครุภัณฑ์",
                              ),
                              historys(
                                input: "${itemhistory![index]["symptom"]}",
                                statusname: "อาการ",
                              ),
                              itemhistory![index]["imagesymptom"] != null
                                  ? Textmain(name: "ภาพอาการ")
                                  : SizedBox(),
                              itemhistory![index]["imagesymptom"] != null
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      child: Image.memory(
                                        base64Decode(itemhistory![index]
                                            ["imagesymptom"]),
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
