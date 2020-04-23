import 'package:absensi_online_pengadilan/get_wordpress.dart';
import 'package:flutter/material.dart';

class Berita extends StatefulWidget {
  @override
  _BeritaState createState() => _BeritaState();
}

class _BeritaState extends State<Berita> {
  @override
  Widget build(BuildContext context) {
    return GetWordpress();
  }
}