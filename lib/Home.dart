import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert' as JSON;
import 'Token.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var token;
  @override
  void initState() {
    this.token = Token();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: FutureBuilder(
          future: this.token.getToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            print(snapshot.toString());
            return ListView(children:[Text('${snapshot.data}')],);
          },
        ),
      ),
    );
  }
}
