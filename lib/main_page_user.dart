//import 'package:absensi_online_pengadilan/login_page.dart';
import 'package:absensi_online_pengadilan/berita.dart';
import 'package:absensi_online_pengadilan/history_user.dart';
import 'package:absensi_online_pengadilan/login_page.dart';
import 'package:absensi_online_pengadilan/page_absen_user.dart';
import 'package:absensi_online_pengadilan/page_profile_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPageUser extends StatefulWidget {
  @override
  _MainPageUserState createState() => _MainPageUserState();
}

class _MainPageUserState extends State<MainPageUser> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  String nip="Kosong";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      nip = preferences.getString('nip');
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
    initializing();
    _showNotificationsIn();
    _showNotificationsOut();
  }

  //untuk menjalankan local notifications
  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  //untuk menampilkan notifikasi
  void _showNotificationsIn() async {
    await notification();
  }

  void _showNotificationsOut() async {
    await notificationOut();
  }

  Future<void> notification() async {
    var time = Time(07, 44, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Jangan Lupa Clock In',
        'Waktu clock in tingal 15 menit lgi',
        time,
        platformChannelSpecifics);
    /*
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'Channel ID', 'Channel title', 'Channel body', priority: Priority.High, importance: Importance.Max, ticker: 'test'
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    
    await flutterLocalNotificationsPlugin.show(0, "Coba pertama", "Berkah", notificationDetails);
    */
  }

  Future<void> notificationOut() async {
    var time = Time(16, 30, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        1,
        'Jangan Lupa Clock Out',
        'Sudah waktu untuk melakukan clock out!',
        time,
        platformChannelSpecifics);
    
  }

  Future onSelectNotification(String payload) {
    if (payload != null) {
      print(payload);
    }
    return null;
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }

  removePref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('nip', null);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          /*actions: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              child: RaisedButton(
                onPressed: () => removePref(),
                child: Text("Keluar"),
                color: Colors.red,
              ),
            )
          ],*/
          backgroundColor: Color(0xFF00853C),
          title: Center(child: Text("Presensi Online")),
          bottom: TabBar(
              indicatorColor: Color(0xFFFFF500),
              indicatorWeight: 3,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.web),
                  text: "Berita",
                ),
                Tab(
                  icon: Icon(Icons.person),
                  text: "Profile",
                ),
                Tab(
                  icon: Icon(Icons.check_box),
                  text: "Absen",
                ),
                Tab(
                  icon: Icon(Icons.history),
                  text: "History",
                )
              ]),
        ),
        body: TabBarView(children: <Widget>[
          Berita(),
          PageProfileUser(
            nipUser: nip,
          ),
          AbsenUser(
            nipUser: nip,
          ),
          HistoryUser(nipUser: nip,)
        ]),
      ),
    );
  }
}
