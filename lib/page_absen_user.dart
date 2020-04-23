import 'dart:async';
import 'dart:convert';
import 'package:absensi_online_pengadilan/jam_absen_user.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'get_wordpress.dart';
import 'package:analog_clock/analog_clock.dart';

class AbsenUser extends StatefulWidget {
  final String nipUser;
  AbsenUser({this.nipUser});
  @override
  _AbsenUserState createState() => _AbsenUserState();
}

class _AbsenUserState extends State<AbsenUser> {
  String nip;
  String formatedDate = "";
  String formatedTimeIn = "";
  String formatedTimeOut = "";
  String statusIn = "";
  String statusOut = "";
  bool loading = true;
  bool isLocationEnabled = false;
  GeolocationStatus geolocationStatus;
  double distanceInMeters = 0;
  Position position;
  double lat;
  double long;
  double latKantor = 5.556509;
  double longKantor = 95.316909;
  List<Placemark> placemark;
  String realLocation = "";
  String suksesIn = "Terima kasih\nClock In Berhasil";
  String gagalIn = "Mohon Maaf\nClock In Gagal";
  String suksesOut = "Terima kasih\nClock Out Berhasil";
  String gagalOut = "Mohon Maaf\nClock Out Gagal";
  String hasilKirim;
  String statusKirim;
  String lokasiKosong;

  sendData() async {
    String url =
        "http://absensipengadilan.000webhostapp.com/absensi-online/absen-geofencing.php";
    var response = await http.post(Uri.encodeFull(url), headers: {
      "Accept": "application/json"
    }, body: {
      "nip_user": nip,
      "tanggal": formatedDate,
      "jam_masuk": formatedTimeIn,
      "jam_pulang": formatedTimeOut,
      "status_masuk": statusIn,
      "status_pulang": statusOut,
      "lokasi_masuk": realLocation,
      "lokasi_pulang": "",
    });
    var datauser = json.decode(response.body);
    print(datauser);
    if (!mounted) return;
    setState(() {
      hasilKirim = datauser;
    });
    (hasilKirim == "Success upload data!!!") ? suksesAbsen() : gagalAbsen();
    if (!mounted) return;
    setState(() {
      loading = false;
    });
    return datauser;
  }

  editData() async {
    String url =
        "http://absensipengadilan.000webhostapp.com/absensi-online/update-data-absen.php";
    var response = await http.post(Uri.encodeFull(url), headers: {
      "Accept": "application/json"
    }, body: {
      "nip_user": nip,
      "tanggal": formatedDate,
      "jam_pulang": formatedTimeOut,
      "status_pulang": statusOut,
      "lokasi_pulang": realLocation,
    });
    var datauser = json.decode(response.body);
    print(datauser);
    if (!mounted) return;
    setState(() {
      hasilKirim = datauser;
    });
    (hasilKirim == "Success Edit data!!!") ? suksesAbsen() : gagalAbsen();
    if (!mounted) return;
    setState(() {
      loading = false;
    });
    return datauser;
  }

  Future checkGps() async {
    isLocationEnabled = await Geolocator().isLocationServiceEnabled();
    print("check gps!");
    print(nip);
    print(widget.nipUser);
  }

  void suksesAbsen() {
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
    print(nip);
    setState(() {
      statusKirim = "Success upload data!!!";
    });
  }

  void gagalAbsen() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Absen gagal di input!"),
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
    print(nip);
    setState(() {
      statusKirim = "Success upload data!!!";
    });
  }

  void checkTime() {
    formatedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DateTime now = DateTime.now();
    DateFormat dateFormat = new DateFormat.Hm();
    DateTime open = dateFormat.parse("07:00");
    open = DateTime(now.year, now.month, now.day, open.hour, open.minute);
    DateTime openLimit = dateFormat.parse("08:00");
    openLimit = DateTime(now.year, now.month, now.day, open.hour, open.minute);
    DateTime close = dateFormat.parse("16:30");
    close = DateTime(now.year, now.month, now.day, close.hour, close.minute);

    if (now.isAfter(open) && now.isBefore(openLimit)) {
      formatedTimeIn = DateFormat('kk:mm:a').format(DateTime.now());
      statusIn = "Masuk";
      formatedTimeOut = "";
      statusOut = "";
    } else if (now.isAfter(openLimit) && now.isBefore(close)) {
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
    print(now);
    print(formatedTimeIn);
    print(formatedTimeOut);
  }

  Future checkLocation() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (!mounted) return;
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
    print("check location!");
    if (lat != null) {
      distanceInMeters =
          await Geolocator().distanceBetween(lat, long, latKantor, longKantor);
      print("check distance!");
      placemark = await Geolocator().placemarkFromCoordinates(lat, long);
      Placemark place = placemark[0];
      if (!mounted) return;
      setState(() {
        realLocation =
            "${place.subThoroughfare},${place.thoroughfare},${place.subLocality},${place.locality},${place.administrativeArea},${place.country}";
      });
      print("check location name!");
      if (distanceInMeters > 50) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(child: Text("Anda Berada Diluar Kantor!")),
              content: Container(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Apakah Anda WFH?\nAnda Berada di Sekitar:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "$realLocation",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.red,
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              "Tidak",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          RaisedButton(
                            color: Colors.green,
                            onPressed: () {
                              if (formatedTimeIn != "" &&
                                  formatedTimeOut == "") {
                                sendData();
                              } else if (formatedTimeOut != "" &&
                                  formatedTimeIn == "") {
                                editData();
                              }
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Ya, Lanjutkan",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      } else {
        if (!mounted) return;
      setState(() {
        realLocation =
            "Pengadilan Banda Aceh Kelas 1A";
      });
        if (formatedTimeIn != "" && formatedTimeOut == "") {
          sendData();
        } else if (formatedTimeOut != "" && formatedTimeIn == "") {
          editData();
        }

      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                height: 100,
                width: 100,
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Mohon Tunggu .....")
                      ]),
                ),
              ),
            );
          });
    }
  }

  Future checkPermission() async {
    geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
    print("check permission!");
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      nip = preferences.getString('nip');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getPref();
    checkTime();
  }

  //widget jam 
  Widget get simpleClock => AnalogClock(
        decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.black),
            color: Colors.transparent,
            shape: BoxShape.circle),
        width: 20.0,
        isLive: false,
        hourHandColor: Colors.black,
        minuteHandColor: Colors.black,
        showSecondHand: false,
        numberColor: Colors.black87,
        showNumbers: true,
        textScaleFactor: 1.4,
        showTicks: false,
        showDigitalClock: false,
        datetime: DateTime(2019, 1, 1, 9, 12, 15),
        key: GlobalObjectKey(3),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (formatedTimeIn != "" && formatedTimeOut == "")
          ? Stack(
                      children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Jam()
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Card(
                      elevation: 5,
                      margin: EdgeInsets.all(20),
                      child: Container(
                        margin: EdgeInsets.all(20),
                        color: Colors.transparent,
                        height: MediaQuery.of(context).size.height / 5,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              height: MediaQuery.of(context).size.height / 15,
                              child: RaisedButton(
                                color: Colors.blueGrey,
                                onPressed: () {
                                  checkTime();
                                  lat = null;
                                  long = null;
                                  checkGps();
                                  checkPermission();
                                  (isLocationEnabled == true)
                                      ? checkLocation()
                                      : showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  "Can't get gurrent location"),
                                              content: const Text(
                                                  'Please make sure you enable GPS and try again'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('Ok'),
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                },
                                child: Text(
                                  "CLOCK IN NOW!",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.all(20),
                                child: Column(
                                  children: <Widget>[
                                    (loading == true)
                                        ? Text(
                                            "Belum Clock In Hari ini!",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          )
                                        : Text(
                                            (statusKirim ==
                                                    "Success upload data!!!")
                                                ? suksesIn
                                                : gagalIn,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          )
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
          )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GetWordpress(),
                Card(
                  elevation: 5,
                  margin: EdgeInsets.all(20),
                  child: Container(
                    margin: EdgeInsets.all(20),
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height / 5,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          height: MediaQuery.of(context).size.height / 15,
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            onPressed: () {
                              checkTime();
                              lat = null;
                              long = null;
                              checkGps();
                              checkPermission();
                              (isLocationEnabled == true)
                                  ? checkLocation()
                                  : showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                              "Can't get gurrent location"),
                                          content: const Text(
                                              'Please make sure you enable GPS and try again'),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('Ok'),
                                              onPressed: () {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                            },
                            child: Text(
                              "CLOCK OUT NOW!",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              children: <Widget>[
                                (loading == true)
                                    ? Text(
                                        "Belum Clock Out Hari ini!",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      )
                                    : Text(
                                        (statusKirim ==
                                                "Success upload data!!!")
                                            ? suksesOut
                                            : gagalOut,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      )
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
