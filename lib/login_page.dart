import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:absensi_online_pengadilan/main_page_user.dart';
import 'package:absensi_online_pengadilan/main_page_admin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginStatus { notSignIn, signIn }

enum LoginUsers{user, admin}


class _LoginPageState extends State<LoginPage> {
  LoginStatus status = LoginStatus.notSignIn;
  LoginUsers users;
  final nipController = TextEditingController();
  final passController = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool _secureText = true;
  bool loading = true;
  int value;
  String nip;

  void alert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("NIP atau Password Tidak Benar!"),
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

  checkForm() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      print("tidak kosong!");
      if (!mounted) return;
      setState(() {
        loading = !loading;
      });
      login();
    }
  }

  showText() {
    if (!mounted) return;
    setState(() {
      _secureText = !_secureText;
    });
  }


  login() async {
    final response = await http.post(
        "http://absensipengadilan.000webhostapp.com/absensi-online/login.php",
        body: {
          'nip_user': nipController.text,
          'password': passController.text
        });
    final data = json.decode(response.body);
    if (!mounted) return;
    setState(() {
      value = data['value'];
      nip = data['nip'];
    });
    print(data);
    if (value == 1) {
      if (!mounted) return;
      setState(() {
        savePref(nip,value);
        status = LoginStatus.signIn;
        users = LoginUsers.admin;
      });
    } else if (value == 2) {
      if (!mounted) return;
      setState(() {
        savePref(nip,value);
        status = LoginStatus.signIn;
        users = LoginUsers.user;
      });
    } else {
      alert();
      if (!mounted) return;
      setState(() {
        loading = !loading;
      });
    }
  }

  savePref(String nip, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      preferences.setString('nip', nip);
      preferences.setInt('value', value);
    });
  }

  String nipSave;
  int valueSave;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      nipSave = preferences.getString('nip');
      valueSave = preferences.getInt('value');
      status = nipSave != null ? LoginStatus.signIn : LoginStatus.notSignIn;
      users = valueSave == 1 ? LoginUsers.admin : LoginUsers.user;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  void dispose() {
    login();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double marginHeight = MediaQuery.of(context).size.height / 7;
    double marginWidth = MediaQuery.of(context).size.width / 8;
    switch (status) {
      case LoginStatus.notSignIn:
        return Scaffold(
          body:
              //Comtainer untuk membuat gradien background
              Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: <Color>[Color(0xFF00853C), Color(0xFFFFF500)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            child: Form(
              key: _key,
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      //kotak diatas tombol login
                      Container(
                        decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey[700],
                                  blurRadius: 5.0,
                                  spreadRadius: 1,
                                  offset: Offset(4, 5))
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        margin: EdgeInsets.only(
                            top: marginHeight,
                            right: marginWidth,
                            left: marginWidth),
                        //color: Colors.white,
                        height: MediaQuery.of(context).size.height / 1.6,
                        child:
                            //agar bisa ditimpa dibuat stack / tumpukan
                            Stack(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(bottom: 10),
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      child: TextFormField(
                                        validator: (e) {
                                          if (e.isEmpty) {
                                            return "NIP tidak boleh kosong!";
                                          }
                                          return null;
                                        },
                                        controller: nipController,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: "NIP",
                                            labelText: "NIP"),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      child: TextFormField(
                                        validator: (e) {
                                          if (e.isEmpty) {
                                            return "Password tidak boleh kosong!";
                                          }
                                          return null;
                                        },
                                        controller: passController,
                                        decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                                icon: Icon(!_secureText
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                                onPressed: showText),
                                            border: OutlineInputBorder(),
                                            hintText: "Password",
                                            labelText: "Password"),
                                        obscureText: _secureText,
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              margin: EdgeInsets.all(20),
                              alignment: Alignment.topCenter,
                              height: MediaQuery.of(context).size.height / 2.7,
                              child:
                                  Image(image: AssetImage("images/logo.png")),
                            ),
                          ],
                        ),
                      ),
                      //Tombol Login
                      GestureDetector(
                        onTap: () {
                          checkForm();
                          //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MainPageAdmin()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.lightGreen[600],
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey[700],
                                    blurRadius: 5.0,
                                    spreadRadius: 1,
                                    offset: Offset(3, 4))
                              ]),
                          margin: EdgeInsets.only(
                            top: 30,
                            right: marginWidth + 10,
                            left: marginWidth + 10,
                          ),
                          height: MediaQuery.of(context).size.height / 12,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: (!loading)
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.yellow),
                                  )
                                : Text(
                                    "Login",
                                    style: TextStyle(
                                        fontSize: 29,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        if(users == LoginUsers.admin){
          return MainPageAdmin();
        }else{
          //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MainPageUser()));
          return MainPageUser();
        }
        break;
    }
    return null;
  }
}
