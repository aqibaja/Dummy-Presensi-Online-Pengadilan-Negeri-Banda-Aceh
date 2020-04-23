import 'package:flutter/material.dart';

class DetailHistory extends StatefulWidget {
  final String nipUser;
  final String namaUser;
  final String tanggal;
  final String jamMasuk;
  final String jamKeluar;
  final String statusMasuk;
  final String statusKeluar;
  final String image;
  final String lokasiMasuk;
  final String lokasiPulang;
  DetailHistory(
      {this.nipUser,
      this.namaUser,
      this.tanggal,
      this.jamMasuk,
      this.jamKeluar,
      this.statusMasuk,
      this.statusKeluar,
      this.image,
      this.lokasiMasuk,
      this.lokasiPulang
      });

  @override
  _DetailHistoryState createState() => _DetailHistoryState();
}

class _DetailHistoryState extends State<DetailHistory> {
  EdgeInsets marginText = EdgeInsets.only(top: 20, right: 30, left: 30);

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      child: Icon(
        Icons.image,
        size: 200,
      ),
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF00853C),
          title: Text("Detail Absen"),
        ),
        body: Container(
            child: ListView(
                          children: <Widget>[
          Column(children: <Widget>[
            Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 20, right: 0, bottom: 20),
                        width: 150,
                        height: 150,
                        child: (widget.image == "")
                                ? placeholder
                                : Image.network(
                                    'http://absensipengadilan.000webhostapp.com/absensi-online/upload/' +
                                        widget.image,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover)
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
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                    Container(
                      child: Text(":",
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            widget.namaUser,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
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
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                    Container(
                      child: Text(":",
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            widget.nipUser,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
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
                          "Jam Masuk",
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                    Container(
                      child: Text(":",
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            widget.jamMasuk,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
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
                          "Jam Pulang",
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                    Container(
                      child: Text(":",
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            widget.jamKeluar,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
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
                          "Status Masuk",
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                    Container(
                      child: Text(":",
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            widget.statusMasuk,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
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
                          "Status Pulang",
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                    Container(
                      child: Text(":",
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            widget.statusKeluar,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
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
                          "Lokasi Masuk",
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                    Container(
                      child: Text(":",
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            widget.lokasiMasuk,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
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
                          "Lokasi Pulang",
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                    Container(
                      child: Text(":",
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            "",//widget.lokasiPulang,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          )),
                    )
                  ],
                ),
            ),
          ]
          ),
        ],
            )
      )
    );
  }
}
