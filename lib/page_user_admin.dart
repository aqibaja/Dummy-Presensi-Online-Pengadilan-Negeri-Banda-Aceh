import 'dart:convert';
import 'package:absensi_online_pengadilan/detail_user_admin.dart';
import 'package:absensi_online_pengadilan/tambah_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model_profile_user.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool loading = true;
  final list = List<UserProfile>();
  String level = "1";

  getData() async {
    setState(() {
        loading = true;
      });
    print("Mencari Data");
    list.clear();
    if (!mounted) return;
    final response = await http.post(
        "http://absensipengadilan.000webhostapp.com/absensi-online/get-all-user.php",
        headers: {
          "Accept": "application/json"
        },
        body: {
          "level": level,
        });

    if (response.contentLength == 2) {
    } else {
      final data = json.decode(response.body);
      data.forEach((api) {
        final ab = UserProfile(
            namaUser: api['nama_user'],
            nipUser: api['nip_user'],
            jabatan: api['jabatan'],
            bidangUnitKerja: api['bidang_unit_kerja'],
            image: api['image']);
        list.add(ab);
        print("ada data");
      });
      if (!mounted) return;
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      child: Icon(
        Icons.image,
        size: 90,
      ),
    );
    return Scaffold(
      floatingActionButton: 
      GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TambahUser(level: level,reload: getData,)));
        },
              child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
                    color: Colors.amber[400],
          ),
          width: 70,
          height: 70,
          child: Icon(Icons.add),
        ),
      ),
          body: Container(
        margin: EdgeInsets.all(10),
        child: loading == true
            ? Center(
                child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Mohon Tunggu ...")
                    ],
                  ),
                ),
              )
            : Column(
                children: <Widget>[
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                    ),
                    itemCount: list == null ? 0 : list.length,
                    itemBuilder: (context, i) {
                      final x = list[i];
                      return GestureDetector(
                        onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DetailUserAdmin(nipUser: x.nipUser,))),
                                              child: Card(
                          elevation: 3,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(
                                        top: 10, right: 0, bottom: 0),
                                    child: (x.image == "")
                                        ? placeholder
                                        : Image.network(
                                            'http://absensipengadilan.000webhostapp.com/absensi-online/upload/' +
                                                x.image,
                                            height: 90,
                                            width: 90,
                                            fit: BoxFit.cover)),
                                Container(
                                  child: Text(
                                    x.namaUser,
                                    style: TextStyle(fontSize: 8),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    x.nipUser,
                                    style: TextStyle(fontSize: 8),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
