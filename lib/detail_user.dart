import 'dart:convert';
import 'package:absensi_online_pengadilan/model_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailUser extends StatefulWidget {
  final String nipUser;
  DetailUser(this.nipUser);
  @override
  _DetailUserState createState() => _DetailUserState();
}

class _DetailUserState extends State<DetailUser> {
  User user;

  Future<User> getUser() async{
    await http.get("http://absensipengadilan.000webhostapp.com/absensi-online/detail.php?nip_user=${widget.nipUser}")
    .then((response){
      if(jsonDecode(response.body) != null){
        setState(() {
          user = User.fromJson(jsonDecode(response.body));
        });
      }
    });
    return user;
  }

  //fungsi untuk memanggil langsung getUser diatas ketika detail_absen.dart dipanggil
  @override
  void initState() {
    getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Nama : ${user.namaUser}"),
              Text("NIP : ${user.nipUser}"),
              Text("Jabatan : ${user.jabatan}"),
              Text("Bidang/Unit Kerja : ${user.bidangUnitKerja}"),
            ],
          ),
        ),
      );
  }
}