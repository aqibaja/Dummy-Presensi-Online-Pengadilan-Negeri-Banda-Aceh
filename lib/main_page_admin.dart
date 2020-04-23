//import 'package:absensi_online_pengadilan/login_page.dart';
import 'package:absensi_online_pengadilan/history_admin.dart';
import 'package:absensi_online_pengadilan/page_member.dart';
import 'package:absensi_online_pengadilan/page_user_admin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class MainPageAdmin extends StatefulWidget {
  @override
  _MainPageAdminState createState() => _MainPageAdminState();
}

class _MainPageAdminState extends State<MainPageAdmin> {
  removePref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('nip', null);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
          length: 3,
          child: Scaffold(
          appBar: AppBar(
          backgroundColor: Color(0xFF00853C),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.exit_to_app), onPressed: () => removePref())
          ],
          title: Center(child: Text("Admin Page")),
          bottom: TabBar(
            indicatorColor: Color(0xFFFFF500),
            indicatorWeight: 3,
            tabs: <Widget>[
            Tab(icon: Icon(Icons.person),text: "Member",),
            Tab(icon: Icon(Icons.assignment_ind),text: "Admin",),
            Tab(icon: Icon(Icons.history),text: "history",)
          ],
          ),
        ),
          body: TabBarView(
          children: <Widget>[
            MemberPage(),
            AdminPage(),
            HistoryAdmin(),
          ]
        ),
      ),
    );
  }
}