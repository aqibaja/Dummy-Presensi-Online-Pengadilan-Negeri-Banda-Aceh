import 'dart:convert';
import 'package:absensi_online_pengadilan/detail_history_admin.dart';
import 'package:absensi_online_pengadilan/model_history_admin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HistoryAdmin extends StatefulWidget {
  @override
  _HistoryAdminState createState() => _HistoryAdminState();
}

class _HistoryAdminState extends State<HistoryAdmin> {
  var loading = true;
  String formatedDate = "";
  final list = List<ModelHistoryAdmin>();

  getData() async {
    list.clear();
    print("get data");
    formatedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final response = await http.post(
        "http://absensipengadilan.000webhostapp.com/absensi-online/get-all-history-2.php",
        headers: {
          "Accept": "application/json"
        },
        body: {
          "tanggal": formatedDate,
        });

    if (response.contentLength == 2) {
      print("tidak ada data");
    } else {
      final data = json.decode(response.body);
      data.forEach((api) {
        print("get data 2");
        final ab = ModelHistoryAdmin(
            namaUser: api['nama_user'],
            nipUser: api['nip_user'],
            jabatan: api['jabatan'],
            bidangUnitKerja: api['bidang_unit_kerja'],
            jamMasuk: api['jam_masuk'],
            jamPulang: api['jam_pulang'],
            statusMasuk: api['status_masuk'],
            statusPulang: api['status_pulang'],
            tanggal: api['tanggal'],
            image: api['image'],
            lokasiMasuk: api['lokasi_masuk'],
            lokasiPulang: api['lokasi_pulang']);
        list.add(ab);
      });
      if (!mounted) return;
      setState(() {
        loading = !loading;
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    //getData();
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
    return Container(
      child: loading
          ? Container(
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
            )
          : ListView.builder(
              itemCount: list == null ? 0 : list.length,
              itemBuilder: (context, i) {
                final x = list[i];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => DetailHistory(
                            namaUser: list[i].namaUser,
                            nipUser: list[i].nipUser,
                            tanggal: list[i].tanggal,
                            jamMasuk: list[i].jamMasuk,
                            jamKeluar: list[i].jamPulang,
                            statusMasuk: list[i].statusMasuk,
                            statusKeluar: list[i].statusPulang,
                            image: list[i].image,
                            lokasiMasuk: list[i].lokasiMasuk,
                            lokasiPulang: list[i].lokasiPulang,
                          ))),
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(9)),
                    child: Card(
                      color: Colors.transparent,
                      elevation: 7,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(9)),
                        height: 100,
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: ListTile(
                                title: Text(
                                  x.namaUser,
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  x.nipUser,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                leading: Container(
                                    margin: EdgeInsets.only(
                                        top: 0, right: 0, bottom: 0),
                                    width: 50,
                                    height: 50,
                                    child: (x.image == "")
                                        ? placeholder
                                        : Image.network(
                                            'http://absensipengadilan.000webhostapp.com/absensi-online/upload/' +
                                                x.image,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover)),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Masuk:",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(x.jamMasuk,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Pulang:",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(x.jamPulang,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
