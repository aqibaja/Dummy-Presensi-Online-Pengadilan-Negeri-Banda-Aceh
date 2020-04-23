import 'dart:convert';
import 'package:absensi_online_pengadilan/model_user.dart';
import 'package:flutter/material.dart';
//import 'package:barcode_scan/barcode_scan.dart';
//import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
//import 'package:intl/intl.dart';

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  String code = "Unknown";
  Color warna;
  User user;
  String getcode = "";
  String formatedDate = "";
  String formatedTimeIn = "";
  String formatedTimeOut = "";
  String statusIn = "";
  String statusOut = "";
  String hasil = "";

  //popup yg memberi tanda bahwa input data berhasil
  void sukses() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Absen berhasil di input!"),
            actions: <Widget>[
              RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  elevation: 5,
                  color: Colors.grey[600])
            ],
          );
        });
  }

  Future<User> getUser() async {
    await http
        .get(
            "http://absensipengadilan.000webhostapp.com/absensi-online/detail.php?nip_user=$getcode")
        .then((response) {
      if (jsonDecode(response.body) != null) {
        if (!mounted) return;
        setState(() {
          user = User.fromJson(jsonDecode(response.body));
        });
      }
    });
    print("coba!!!");
    return user;
  }

  sendData() async {
    String url =
        "http://absensipengadilan.000webhostapp.com/absensi-online/add-data-absen.php";
    var response = await http.post(Uri.encodeFull(url), headers: {
      "Accept": "application/json"
    }, body: {
      "nip_user": user.nipUser,
      "tanggal": formatedDate,
      "jam_masuk": formatedTimeIn,
      "jam_pulang": formatedTimeOut,
      "status_masuk": statusIn,
      "status_pulang": statusOut,
    });
    var datauser = json.decode(response.body);
    print(datauser);
    return datauser;
  }

  editData() async {
    String url =
        "http://absensipengadilan.000webhostapp.com/absensi-online/update-data-absen.php";
    var response = await http.post(Uri.encodeFull(url), headers: {
      "Accept": "application/json"
    }, body: {
      "nip_user": user.nipUser,
      "jam_pulang": formatedTimeOut,
      "status_pulang": statusOut,
    });
    var datauser = json.decode(response.body);
    print(datauser);
    return datauser;
  }
  //method untuk scan qr code menggunakan plugin barcode_scan.dart
  Future scan() async {
    /*
    try {
     // getcode = await BarcodeScanner.scan();
      if (!mounted) return;
      setState(() {
        code = "Success";
        warna = Colors.green;
        formatedDate =
                      DateFormat('yyyy-MM-dd').format(DateTime.now());
                  DateTime now = DateTime.now();
                  DateFormat dateFormat = new DateFormat.Hm();
                  DateTime open = dateFormat.parse("08:00");
                  open = DateTime(
                      now.year, now.month, now.day, open.hour, open.minute);
                  DateTime openLimit = dateFormat.parse("09:00");
                  openLimit = DateTime(
                      now.year, now.month, now.day, open.hour, open.minute);
                  DateTime openLate = dateFormat.parse("10:30");
                  openLate = DateTime(
                      now.year, now.month, now.day, open.hour, open.minute);
                  DateTime close = dateFormat.parse("16:30");
                  close = DateTime(
                      now.year, now.month, now.day, close.hour, close.minute);

                  if (now.isAfter(open) && now.isBefore(openLimit)) {
                    formatedTimeIn = DateFormat('kk:mm:a').format(DateTime.now());
                    statusIn = "Masuk";
                    formatedTimeOut = "";
                    statusOut = "";

                  } else if (now.isAfter(openLate) && now.isBefore(close)) {
                    formatedTimeIn = DateFormat('kk:mm:a').format(DateTime.now());
                    statusIn = "Telat";
                    formatedTimeOut = "";
                    statusOut = "";
                  } else if (now.isAfter(close)) {
                    formatedTimeOut = DateFormat('kk:mm:a').format(DateTime.now());
                    statusOut = "Pulang";
                    formatedTimeIn = "";
                    statusIn = "";
                  }
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        if (!mounted) return;
        setState(() {
          this.code = 'Kamera Belum Memiliki Izin!';
          warna = Colors.red;
        });
      } else {
        if (!mounted) return;
        setState(() {
          this.code = 'Unknown error: $e';
          warna = Colors.red;
        });
      }
    } on FormatException {
      if (!mounted) return;
      setState(() {
        this.code = 'Null!';
        warna = Colors.red;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        this.code = 'Unknown error: $e';
        warna = Colors.red;
      });
    }
    */
  }

  @override
  void dispose() {
    getUser();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  scan();
                },
                child: Text(
                  "Scan Qr Code",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Scan Result:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      code,
                      style: TextStyle(
                          color: warna,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              code == "Success"
                  ? Column(
                      children: <Widget>[
                        FutureBuilder<User>(
                          future: getUser(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);
                            return snapshot.hasData
                                ? Container(
                                    child: Column(
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              "${user.namaUser}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${user.nipUser}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Text(
                                              formatedDate,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            formatedTimeOut == ""
                                                ? Text(
                                                    formatedTimeIn,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  )
                                                : Text(
                                                    formatedTimeOut,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  );
                          },
                        ),
                      ],
                    )
                  : Container(),
              RaisedButton(
                onPressed: () {
                  if (formatedTimeIn != "" && formatedTimeOut == "") {
                    sendData();
                    sukses();
                  } else if (formatedTimeOut != "" && formatedTimeIn == "") {
                    editData();
                    sukses();
                  }
                },
                child: Text("OK"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
