import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert' as JSON;
import 'Doctor.dart';
import 'Room.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var token;
  var doctor;
  var room;
  @override
  void initState() {
    this.doctor = Doctor();
    doctor.getDoctor();
    this.room = Room();
    room.getRoom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salas'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: FutureBuilder(
                future: this.doctor.getDoctor(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return ListView(
                    children: [
                      Text(
                        'Doctor: ' + '${snapshot.data}',
                        style: TextStyle(fontSize: 28),
                      )
                    ],
                  );
                },
              ),
            ),
            Expanded(
              flex: 9,
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(13, (index) {
                  return Container(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/room');
                      },
                      child: Card(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_hospital,
                                size: 80,
                              ),
                              Text(
                                'Sala $index',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
