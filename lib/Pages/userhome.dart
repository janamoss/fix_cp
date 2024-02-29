import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fix_cp/Pages/login.dart';
import 'package:fix_cp/Pages/register.dart';
import 'package:fix_cp/Widgets/Color.dart';
import 'package:fix_cp/Widgets/appbar.dart';
import 'package:fix_cp/Widgets/reportdialog.dart';
import 'package:fix_cp/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

import 'package:image/image.dart' as img;

class userHome extends StatefulWidget {
  final token;
  const userHome({super.key, this.token});

  @override
  State<userHome> createState() => _userHomeState();
}

class _userHomeState extends State<userHome> {
  TextEditingController symptomController = TextEditingController();
  TextEditingController equipmentNoController = TextEditingController();

  String? base64String;

  final ImagePicker picker = ImagePicker();

  File? _selectedImage;

  late String email;
  late String usertype;
  late String name;
  late String user_id;
  late List? itemdevice;
  List? _itemDevices;
  late List? itemlocation;
  String? _selectedLocations;
  String? _selectedDevices;
  bool _isNotValidate = false;

  late Uint8List? imageBytes;

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
    itemdevice = [];
    itemlocation = [];
    getAllDevices();
    getAllLoactions();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    usertype = jwtDecodedToken['usertype'];
    name = jwtDecodedToken['name'];
    user_id = jwtDecodedToken['_id'];
  }

  void getAllDevices() async {
    var response = await http.get(Uri.parse(getdevices),
        headers: {"Content-Type": "application/json"});
    var jsonresponse = jsonDecode(response.body);
    setState(() {
      itemdevice = jsonresponse['success'];
    });
  }

  void getAllLoactions() async {
    var response = await http.get(Uri.parse(getlocation),
        headers: {"Content-Type": "application/json"});
    var jsonresponse = jsonDecode(response.body);
    setState(() {
      itemlocation = jsonresponse['success'];
      print(itemlocation);
    });
  }

  void reportrepair() async {
    if (symptomController.text.isNotEmpty &&
        _selectedLocations!.isNotEmpty &&
        _selectedDevices!.isNotEmpty) {
      _selectedImage != null
          ? imageBytes = await _selectedImage!.readAsBytesSync()
          : null;

      final image = img.decodeImage(imageBytes!);

      // ลดขนาดรูปภาพ
      final resizedImage =
          img.copyResize(image as img.Image, width: 400, height: 400);
      final resizedImageBytes = img.encodeJpg(resizedImage);
      resizedImageBytes != null
          ? base64String = base64Encode(resizedImageBytes)
          : null;

      var reqBody = {
        "iduser": user_id,
        "device": _selectedDevices,
        "equipmentNo": equipmentNoController.text,
        "location": _selectedLocations,
        "symptom": symptomController.text,
        "imagesymptom": base64String ?? "",
      };

      var response = await http.post(Uri.parse(reportrepairs),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));
      // var jsonresponse = jsonDecode(response.body);
      var jsonresponse = await json.decode(json.encode(response.body));
      Navigator.of(context).pop();
    } else {}
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Whitecolor,
      appBar: Appbarmain(name: "หน้าหลัก", autoLeading: false),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Image.asset(
              "assets/images/wallpaper.jpeg",
              fit: BoxFit.cover,
              width: double.maxFinite,
            ),
          ),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "สวัสดีคุณ $name",
                      style: TextStyle(
                          color: Bluelogocolor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ยินดีต้อนรับสู่แอพพลิเคชัน FixIT",
                      style: TextStyle(color: Bluelogocolor, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      dialogreportrepair(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Bluelogocolor,
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      child: const Center(
                          child: Text(
                        "เริ่มต้นแจ้งซ่อม",
                        style: TextStyle(
                            color: Whitecolor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }

  Future<void> dialogreportrepair(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            elevation: 0,
            icon: Icon(
              Icons.room,
              color: Bluelogocolor2,
              size: 30,
            ),
            backgroundColor: Whitecolor,
            title: Text(
              'แจ้งซ่อมออนไลน์',
            ),
            content: Container(
              width: MediaQuery.sizeOf(context).width * 0.8,
              height: MediaQuery.sizeOf(context).width * 0.8,
              child: SingleChildScrollView(
                child: StatefulBuilder(
                  // You need this, notice the parameters below:
                  builder: (BuildContext context, StateSetter setState) =>
                      Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Textmain(name: "ห้อง"),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: StatefulBuilder(
                                builder: (context, setState) => DropdownButton(
                                  items: itemlocation!
                                      .map<DropdownMenuItem<String>>((item) {
                                    return DropdownMenuItem<String>(
                                      value: item['name'],
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.business_rounded,
                                            color: Bluelogocolor,
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            item['name'],
                                            style:
                                                TextStyle(color: Bluelogocolor),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedLocations = value;
                                      var filteredItems = itemlocation!
                                          .where(
                                              (item) => item['name'] == value)
                                          .toList();
                                      // แสดงเฉพาะอุปกรณ์
                                      _itemDevices =
                                          filteredItems[0]['listDevices'];
                                      Navigator.of(context).pop();
                                      dialogreportrepair(context);
                                    });
                                  },
                                  hint: Text(
                                    "กรุณาเลือกห้อง",
                                    style: TextStyle(
                                        color: Bluelogocolor, fontSize: 17),
                                  ),
                                  value: _selectedLocations,
                                ),
                              ),
                            ),
                          ),
                          _selectedLocations != null
                              ? Column(
                                  children: [
                                    Textmain(name: "อุปกรณ์"),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: StatefulBuilder(
                                          builder: (context, setState) =>
                                              DropdownButton(
                                            items: _itemDevices!
                                                .map<DropdownMenuItem<String>>(
                                                    (item) {
                                              return DropdownMenuItem<String>(
                                                enabled:
                                                    _selectedLocations != null
                                                        ? true
                                                        : false,
                                                value: item,
                                                child: Row(
                                                  children: [
                                                    icons[item] != null
                                                        ? Icon(
                                                            icons[item]!,
                                                            color:
                                                                Bluelogocolor,
                                                          )
                                                        : SizedBox(),
                                                    SizedBox(width: 15),
                                                    Text(
                                                      item,
                                                      style: TextStyle(
                                                          color: Bluelogocolor),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedDevices = value;
                                              });
                                            },
                                            hint: Text(
                                              "กรุณาเลือกอุปกรณ์",
                                              style: TextStyle(
                                                  color: Bluelogocolor,
                                                  fontSize: 17),
                                            ),
                                            value: _selectedDevices,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : SizedBox(),
                          Column(
                            children: [
                              Textmain(
                                  name: "หมายเลขครุภัณฑ์ หรือ เลขเครื่อง",
                                  colors: Bluelogocolor),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: equipmentNoController,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Bluelogocolor,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    filled: true,
                                    fillColor: Whitecolor,
                                    errorStyle:
                                        TextStyle(color: Colors.red.shade400),
                                    errorText: _isNotValidate
                                        ? "กรุณากรอกข้อมูลให้ครบถ้วน"
                                        : null,
                                    hintText: "หมายเลขครุภัณฑ์ หรือ เลขเครื่อง",
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0))),
                                    labelStyle: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Textmain(
                                  name: "อาการในเบื้องต้น",
                                  colors: Bluelogocolor),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: symptomController,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Bluelogocolor,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    filled: true,
                                    fillColor: Whitecolor,
                                    errorStyle:
                                        TextStyle(color: Colors.red.shade400),
                                    errorText: _isNotValidate
                                        ? "กรุณากรอกข้อมูลให้ครบถ้วน"
                                        : null,
                                    hintText: "อาการในเบื้องต้น",
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0))),
                                    labelStyle: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Textmain(
                                  name: "ภาพอาการในเบื้องต้น",
                                  colors: Bluelogocolor),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _pickimage();
                                },
                                label: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "เพิ่มรูปภาพ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Whitecolor, fontSize: 13),
                                  ),
                                ),
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        ContinuousRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30))),
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.green.shade400)),
                                icon: Icon(Icons.image_rounded,
                                    color: Whitecolor, size: 35),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          _selectedImage != null
                              ? Image.file(_selectedImage!)
                              : SizedBox()
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              ElevatedButton.icon(
                onPressed: () {
                  reportrepair();
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

  Future _pickimage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = File(image!.path);
      Navigator.of(context).pop();
      dialogreportrepair(context);
    });
  }
}
