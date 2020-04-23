import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TambahUser extends StatefulWidget {
  final String level;
  final VoidCallback reload;
  TambahUser({this.level, this.reload});
  @override
  _PageProfileUserState createState() => _PageProfileUserState();
}

class _PageProfileUserState extends State<TambahUser> {
  TextEditingController namaControl = TextEditingController();
  TextEditingController nipControl = TextEditingController();
  TextEditingController jabatanControl = TextEditingController();
  TextEditingController unitKerjaControl = TextEditingController();
  TextEditingController passwordControl =
      TextEditingController(text: "pengadilan");
  final _key = GlobalKey<FormState>(); //untuk melihat apakah form kosong atau tidak
  bool loading = true; 

  //mengecek form / text isian
  checkForm() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      print("tidak kosong!");
      if (!mounted) return;
      setState(() {
        loading = false;
      });
      submitData();
    }
  }

  EdgeInsets marginText = EdgeInsets.only(top: 20, right: 30, left: 30);

  submitData() async {
    try {
      var uri = Uri.parse(
          "http://absensipengadilan.000webhostapp.com/absensi-online/tambah-data-user.php");
      final request = http.MultipartRequest("POST", uri);
      request.fields['nip_user'] = nipControl.text;
      request.fields['nama_user'] = namaControl.text;
      request.fields['jabatan'] = jabatanControl.text;
      request.fields['bidang_unit_kerja'] = unitKerjaControl.text;
      request.fields['level'] = widget.level;
      request.fields['password'] = passwordControl.text;
      var response = await request.send();
      if (response.statusCode > 2) {
        print(response);
        print("Password Sukses Upload Data");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("User berhasil di input!"),
                actions: <Widget>[
                  RaisedButton(
                      onPressed: () {
                        widget.reload();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
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
      } else {
        print("Pasword Gagal Upload");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Member"),
        backgroundColor: Color(0xFF00853C),
      ),
      body: Container(
          child: ListView(
        children: <Widget>[
          Form(
            key: _key,
            child: Column(
              children: <Widget>[
                Container(
                  margin: marginText,
                  child: Row(
                    
                    children: <Widget>[
                      Container(
                          width: 100,
                          child: Text(
                            "Nama",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          )),
                      Container(
                        child: Text(":",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 70,
                        margin: EdgeInsets.only(left: 20),
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Nama Tidak Boleh Kosong!";
                            }
                            return null;
                          },
                          controller: namaControl,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Nama",
                              labelText: "Nama"),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: marginText,
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 100,
                          child: Text(
                            "NIP",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          )),
                      Container(
                        child: Text(":",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 70,
                        margin: EdgeInsets.only(left: 20),
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "NIP Tidak Boleh Kosong!";
                            }
                            return null;
                          },
                          controller: nipControl,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "NIP",
                              labelText: "NIP"),
                          keyboardType: TextInputType.number,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: marginText,
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 100,
                          child: Text(
                            "Jabatan",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          )),
                      Container(
                        child: Text(":",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 70,
                        margin: EdgeInsets.only(left: 20),
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Jabatan Tidak Boleh Kosong!";
                            }
                            return null;
                          },
                          controller: jabatanControl,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Jabatan",
                              labelText: "Jabatan"),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: marginText,
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 100,
                          child: Text(
                            "Unit Kerja",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          )),
                      Container(
                        child: Text(":",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 70,
                        margin: EdgeInsets.only(left: 20),
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Unit Kerja Tidak Boleh Kosong!";
                            }
                            return null;
                          },
                          controller: unitKerjaControl,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Unit Kerja",
                              labelText: "Unit Kerja"),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: marginText,
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 100,
                          child: Text(
                            "Password",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          )),
                      Container(
                        child: Text(":",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 70,
                        margin: EdgeInsets.only(left: 20),
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Password Tidak Boleh Kosong!";
                            }
                            return null;
                          },
                          controller: passwordControl,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Password",
                              labelText: "Password"),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: 20, right: 30, left: 30, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: RaisedButton(
                          color: Colors.red,
                          onPressed: () {
                            namaControl.clear();
                            nipControl.clear();
                            jabatanControl.clear();
                            unitKerjaControl.clear();
                          },
                          child: Text(
                            "Clear",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: RaisedButton(
                          color: Colors.green,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  child: AlertDialog(
                                    content: Container(
                                      width: 100,
                                      height: 100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(
                                            'Apakah anda yakin ingin menyimpan data baru ?',
                                            textAlign: TextAlign.center,
                                          ),
                                          RaisedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              checkForm();
                                            },
                                            child: Text("OK"),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Text(
                            "Simpan",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
