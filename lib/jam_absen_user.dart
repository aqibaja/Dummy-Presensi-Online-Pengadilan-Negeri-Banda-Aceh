import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Jam extends StatefulWidget {
  @override
  _JamState createState() => _JamState();
}

class _JamState extends State<Jam> {
  String _timeString ="";
  String _tanggalString ="";

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    _tanggalString = _tanggal(DateTime.now());

    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
        children: <Widget>[
          Text(
            _timeString,
            style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
          ),
          Text(_tanggalString,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      )),
    );
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String jam = _formatDateTime(now);
    final String tanggal = _tanggal(now);
    setState(() {
      _timeString = jam;
      _tanggalString = tanggal;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }

  String _tanggal(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy').format(dateTime);
  }
}
