import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as JSON;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _token = 'token';

  Future _getDoctors() async {
    await http.get('http://10.0.2.2:8000/api/doctor/',
        headers: {'Authorization': 'JWT ${_token}'}).then((res) {
      print(res.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                _getDoctors();
              },
              child: Text('Traer data'),
            )
          ],
        ),
      ),
    );
  }
}
