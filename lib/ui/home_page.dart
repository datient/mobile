import 'dart:convert' as JSON;
import 'package:datient/models/doctor.dart';
import 'package:datient/models/room.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var token;
  Doctor doctor = Doctor();

  Future<List<Room>> _getRooms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _token = prefs.getString('token');
    List list;
    final response = await http.get(
      'http://10.0.2.2:8000/api/room/',
      headers: {'Authorization': 'JWT $_token'},
    );
    if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body) as List;
      list = extractdata.map((json) => Room.fromJson(json)).toList();
    }
    return list;
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
              child: FutureBuilder(
                future: _getRooms(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.data != null
                      ? GridView.count(
                          crossAxisCount: 2,
                          children:
                              List.generate(snapshot.data.length, (index) {
                            return Container(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed('/room');
                                },
                                child: Card(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.local_hospital,
                                          size: 80,
                                        ),
                                        Text(
                                          snapshot.data[index].roomName,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        )
                      : Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
