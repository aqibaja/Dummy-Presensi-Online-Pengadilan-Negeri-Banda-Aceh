import 'dart:convert';
import 'package:absensi_online_pengadilan/model_history_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HistoryUser extends StatefulWidget {
  final String nipUser;
  HistoryUser({
    this.nipUser,
  });
  @override
  _HistoryUserState createState() => _HistoryUserState();
}

class _HistoryUserState extends State<HistoryUser> {
  var loading = false;
  final list = List<ModelHistoryUser>();

  getData() async {
    list.clear();
    if (!mounted) return;
    setState(() {
      loading =true;
    });
    final response = await http.post("http://absensipengadilan.000webhostapp.com/absensi-online/get-absen-user.php", headers: {
      "Accept": "application/json"
    }, body: {
      "nip_user": widget.nipUser,
      "awal_bulan" : awalBulan,
      "akhir_bulan" : akhirBulan
    });
    if (response.contentLength == 2){
    }else{
      final data = json.decode(response.body);
      data.forEach((api){
        final ab = ModelHistoryUser(
          jamMasuk: api['jam_masuk'],
          jamPulang: api['jam_pulang'],
          tanggal: api['tanggal'],
        );
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
  }

  @override
  void dispose() {
    getData();
    super.dispose();
  }

  void cariBulan(){
    if(selectedBulan.bulan == "Januari"){
      print(selectedBulan.bulan);
      awalBulan = "2020-01-01";
      akhirBulan = "2020-01-32";
      getData();
    }
    else if(selectedBulan.bulan == "Februari"){
      print(selectedBulan.bulan);
      awalBulan = "2020-02-01";
      akhirBulan = "2020-02-32";
      getData();
    }
    else if(selectedBulan.bulan == "Maret"){
      print(selectedBulan.bulan);
      awalBulan = "2020-03-01";
      akhirBulan = "2020-03-32";
      getData();
    }
    else if(selectedBulan.bulan == "April"){
      print(selectedBulan.bulan);
      awalBulan = "2020-04-01";
      akhirBulan = "2020-04-32";
      getData();
    }
    else if(selectedBulan.bulan == "Mai"){
      print(selectedBulan.bulan);
      awalBulan = "2020-05-01";
      akhirBulan = "2020-05-32";
      getData();
    }
    else if(selectedBulan.bulan == "Juni"){
      print(selectedBulan.bulan);
      awalBulan = "2020-06-01";
      akhirBulan = "2020-06-32";
      getData();
    }
    else if(selectedBulan.bulan == "Juli"){
      print(selectedBulan.bulan);
      awalBulan = "2020-07-01";
      akhirBulan = "2020-07-32";
      getData();
    }
    else if(selectedBulan.bulan == "Agustus"){
      print(selectedBulan.bulan);
      awalBulan = "2020-08-01";
      akhirBulan = "2020-08-32";
      getData();
    }
    else if(selectedBulan.bulan == "September"){
      print(selectedBulan.bulan);
      awalBulan = "2020-09-01";
      akhirBulan = "2020-09-32";
      getData();
    }
    else if(selectedBulan.bulan == "Oktober"){
      print(selectedBulan.bulan);
      awalBulan = "2020-10-01";
      akhirBulan = "2020-10-32";
      getData();
    }
    else if(selectedBulan.bulan == "November"){
      print(selectedBulan.bulan);
      awalBulan = "2020-11-01";
      akhirBulan = "2020-11-32";
      getData();
    }
    else if(selectedBulan.bulan == "Desember"){
      print(selectedBulan.bulan);
      awalBulan = "2020-12-01";
      akhirBulan = "2020-12-32";
      getData();
    }
  }

  Bulan selectedBulan;
  String awalBulan;
  String akhirBulan;
  List<Bulan> bulans =[
    Bulan("Januari"),
    Bulan("Februari"),
    Bulan("Maret"),
    Bulan("April"),
    Bulan("Mai"),
    Bulan("Juni"),
    Bulan("Juli"),
    Bulan("Agustus"),
    Bulan("September"),
    Bulan("Oktober"),
    Bulan("November"),
    Bulan("Desember"),
  ];
  List<DropdownMenuItem> generateItems(List<Bulan> bulans){
    List<DropdownMenuItem> items =[];
    for (var item in bulans){
      items.add(DropdownMenuItem(child: Text(item.bulan), value: item,));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text("Pilih bulan untuk melihat riwayat", style: TextStyle(fontSize: 25),),
          Container(
            height: 60,
            width: 300,
            margin: EdgeInsets.all(20),
            child: DropdownButton(
              underline: Container(
                decoration: BoxDecoration(
               border: Border.all(
                 color: Colors.black,
                 width: 1
               )
            ),
              ),
              iconSize: 30,
              itemHeight: 100,
              elevation: 5,
              hint: Text("Bulan"),
              autofocus: true,
              icon: Icon(Icons.calendar_today),
              isExpanded: true,
              style: TextStyle(fontSize: 20, color: Colors.green[900]),
              value: selectedBulan,
              items: generateItems(bulans), 
              onChanged: (item){
                setState(() {
                  selectedBulan = item;
                  cariBulan();
                });
              }
              ),
          ),
          (awalBulan == null)? Container() :
          loading? Center(child: CircularProgressIndicator(),) :
          Expanded(
            child: SizedBox(
                          child: ListView.builder(
                itemCount: list == null ? 0 : list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return Container(
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
                          height: 70,
                          child: Column(
                            children: <Widget>[
                              Center(
                                child: Container(
                                  child: Text(x.tanggal, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                                )),
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
                    );
                }),
            ),
          ),
        ],
      )
      );
     
      
      
      
      
      /*
      FutureBuilder(
        future: getData(),
        builder: (context, snapshot){
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData ?
          RefreshIndicator(
            onRefresh: getData,
            key: _refresh,
            child: HistoryList(list: snapshot.data,))
          : Center(child: CircularProgressIndicator(),);
        }
        )*/
  }
}

class Bulan{
  String bulan;
  Bulan(this.bulan);
}