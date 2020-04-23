import 'package:absensi_online_pengadilan/detail_history_admin.dart';
import 'package:flutter/material.dart';

class HistoryList extends StatefulWidget {
  final List list;
  HistoryList({this.list});

  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.list == null ? 0 : widget.list.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => DetailHistory(
                  namaUser: widget.list[i]['nama_user'],
                  nipUser: widget.list[i]['nip_user'],
                  tanggal: widget.list[i]['tanggal'],
                  jamMasuk: widget.list[i]['jam_masuk'],
                  jamKeluar:  widget.list[i]['jam_pulang'],
                  statusMasuk: widget.list[i]['status_masuk'],
                  statusKeluar: widget.list[i]['status_pulang'],
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
                             widget.list[i]['nama_user'],
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            widget.list[i]['nip_user'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          leading: Icon(
                            Icons.image,
                            size: 50,
                          ),
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
                              Text(widget.list[i]['jam_masuk'],
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
                              Text(widget.list[i]['jam_pulang'],
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
        });
  }
}
