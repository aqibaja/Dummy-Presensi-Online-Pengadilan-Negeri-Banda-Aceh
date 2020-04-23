//import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final List<String> imgList = List();

// method future untuk mengambil data dari wordpress dengan WP Rest API
Future<List> fecthWpPosts() async {
  //response coba buka dengan postman dulu biar enak liat variabelnya
  final response = await http.get(
      'http://pn-bandaaceh.go.id/wp-json/wp/v2/posts?_embed&per_page=5',
      headers: {"Accept": "application/json"});
  var convertDatatoJson = jsonDecode(response.body);
  print(convertDatatoJson);
  return convertDatatoJson;
}

class GetWordpress extends StatefulWidget {
  @override
  _GetWordpressState createState() => _GetWordpressState();
}

class _GetWordpressState extends State<GetWordpress> {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: FutureBuilder(
        future: fecthWpPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Berita Terbaru",
                      style: TextStyle(
                          color: Colors.green[900],
                          fontSize: 30,
                          fontWeight: FontWeight.w600),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.5,
                    margin: EdgeInsets.all(5),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map wppost = snapshot.data[index];
                        // dapat dilihat dari tutorial youtube
                        //"fetch wordpress post & display on flutter app using wp rest API"
                        var imageurl = wppost["_embedded"]["wp:featuredmedia"]
                            [0]["source_url"];
                        print("coba $index");
                        String link = wppost['link'];
                        print(link);
                        return Card(
                          elevation: 2,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Image.network(
                                imageurl,
                                height: 300,
                                width: 350,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 230),
                                  height: 70,
                                  width: 350,
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: Row(
                                    //alignment: Alignment.centerLeft,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(left: 10),
                                        width: 230,
                                        height: 50,
                                        child: Text(
                                          wppost['title']['rendered'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: GestureDetector(
                                          onTap: (){
                                            _launchURL(link);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(left: 10),
                                            width: 90,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                boxShadow: List<BoxShadow>(),
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: Colors.white),
                                            child: Text(
                                              "Detail",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                              //menggunakan parse untuk mengubah xml menjadi text biasa
                              //Text(parse((wppost['excerpt']['rendered']).toString()).documentElement.text)
                            ],
                          ),
                        );
                      },
                    )),
              ],
            );
          }
          return Center(
                  child: Container(
                    margin: EdgeInsets.only(top:MediaQuery.of(context).size.height / 6) ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Mengambil Data ...")
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
