import 'dart:convert';
import 'dart:io';
import 'package:absensi_online_pengadilan/model_profile_user.dart';
import 'package:async/async.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

//melihat detail pada user member dan admin pada menu
class DetailUserAdmin extends StatefulWidget {
  final String nipUser;
  DetailUserAdmin({this.nipUser});
  @override
  _PageProfileUserState createState() => _PageProfileUserState();
}

class _PageProfileUserState extends State<DetailUserAdmin> {
  TextEditingController passwordControl = TextEditingController();
  String image;
  String namaUser;
  String nipUser;
  String jabatanUser;
  String unitKerjaUser;
  File _imageFile; // untuk nyimpan foto

  EdgeInsets marginText = EdgeInsets.only(top: 20, right: 30, left: 30);

  _pilihGalery() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1920.0,
      maxWidth: 1080,
    );
    setState(() {
      _imageFile = image;
    });
  }

  void verifikasi() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("apakah yakin foto ini?"),
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

  submit() async {
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse(
          "http://absensipengadilan.000webhostapp.com/absensi-online/update-data-user.php");
      final request = http.MultipartRequest("POST", uri);
      request.fields['nip_user'] = widget.nipUser;
      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path)));
      print(widget.nipUser);
      var response = await request.send();
      if (response.statusCode > 2) {
        print(response);
        print("Image Sukses Upload");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Container(
              child: AlertDialog(
                content: Container(
                  width: 100,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        'Perbarui data Berhasil!',
                        textAlign: TextAlign.center,
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
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
        _imageFile.delete();
      } else {
        print("Image Gagal Upload");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  submitPasword() async {
    try {
      var uri = Uri.parse(
          "http://absensipengadilan.000webhostapp.com/absensi-online/update-data-user.php");
      final request = http.MultipartRequest("POST", uri);
      request.fields['nip_user'] = widget.nipUser;
      request.fields['password'] = passwordControl.text;
      print(widget.nipUser);
      var response = await request.send();
      if (response.statusCode > 2) {
        print(response);
        print("Password Sukses Upload");
      } else {
        print("Pasword Gagal Upload");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  deleteUser() async {
    try {
      var uri = Uri.parse(
          "http://absensipengadilan.000webhostapp.com/absensi-online/delete-data-user.php");
      final request = http.MultipartRequest("POST", uri);
      request.fields['nip_user'] = widget.nipUser;
      print(widget.nipUser);
      var response = await request.send();
      if (response.statusCode > 2) {
        print(response);
        print("Sukses Hapus data");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("User berhasil di hapus!"),
                actions: <Widget>[
                  RaisedButton(
                      onPressed: () {
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
        print("Gagal Hapus data");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  bool loading = true;
  final list = List<UserProfile>();
  getData() async {
    list.clear();
    print(widget.nipUser);
    if (!mounted) return;
    final response = await http.post(
        "http://absensipengadilan.000webhostapp.com/absensi-online/get-profile-user.php",
        headers: {
          "Accept": "application/json"
        },
        body: {
          "nip_user": widget.nipUser,
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
    print(widget.nipUser);
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
        size: 200,
      ),
    );
    return Scaffold(
      appBar: AppBar(title: Text("Detail User"),backgroundColor: Color(0xFF00853C),),
      body: Container(
        child: Column(
          children: <Widget>[
            loading == true
                ? Center(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 3),
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
                : Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                          itemCount: list == null ? 0 : list.length,
                          itemBuilder: (context, i) {
                            final x = list[i];
                            return Column(
                              children: <Widget>[
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 20, right: 0, bottom: 20),
                                          width: 200,
                                          height: 200,
                                          child: (_imageFile == null)
                                              ? (x.image == "")
                                                  ? placeholder
                                                  : Image.network(
                                                      'http://absensipengadilan.000webhostapp.com/absensi-online/upload/' +
                                                          x.image,
                                                      width: 150,
                                                      height: 150,
                                                      fit: BoxFit.cover)
                                              : Image.file(
                                                  _imageFile,
                                                  fit: BoxFit.cover,
                                                )),
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: RaisedButton(
                                            child: Text("Gallery"),
                                            onPressed: () {
                                              print(widget.nipUser);
                                              _pilihGalery();
                                            }),
                                      ),
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
                                            "Nama",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          )),
                                      Container(
                                        child: Text(":",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      Expanded(
                                        child: Container(
                                            margin: EdgeInsets.only(left: 20),
                                            child: AutoSizeText(
                                              x.namaUser,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            )),
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
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          )),
                                      Container(
                                        child: Text(":",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      Expanded(
                                        child: Container(
                                            margin: EdgeInsets.only(left: 20),
                                            child: AutoSizeText(
                                              x.nipUser,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            )),
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
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          )),
                                      Container(
                                        child: Text(":",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      Expanded(
                                        child: Container(
                                            margin: EdgeInsets.only(left: 20),
                                            child: AutoSizeText(
                                              x.jabatan,
                                              maxLines: 2,
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            )),
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
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          )),
                                      Container(
                                        child: Text(":",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      Expanded(
                                        child: Container(
                                            margin: EdgeInsets.only(left: 20),
                                            child: AutoSizeText(
                                              x.bidangUnitKerja,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            )),
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
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          )),
                                      Container(
                                        child: Text(":",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        height: 50,
                                        margin: EdgeInsets.only(left: 20),
                                        child: TextField(
                                          controller: passwordControl,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: "Password",
                                              labelText: "Password"),
                                          keyboardType: TextInputType.number,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 20, right: 30, left: 30, bottom: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: RaisedButton(
                                          color: Colors.red,
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
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: <Widget>[
                                                          Text(
                                                            'Apakah anda yakin ingin hapus data user?',
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          RaisedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              deleteUser();
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
                                            "Hapus",
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
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: <Widget>[
                                                          Text(
                                                            'Apakah anda yakin ingin perbarui data ?',
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          RaisedButton(
                                                            onPressed: () {
                                                              if (passwordControl
                                                                      .text !=
                                                                  "") {
                                                                submitPasword();
                                                              } else if (passwordControl
                                                                      .text ==
                                                                  "") {
                                                                submit();
                                                              } else {
                                                                print(
                                                                    "tidak update apapun");
                                                              }
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
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
                                            "Perbarui",
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
                            );
                          }),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
