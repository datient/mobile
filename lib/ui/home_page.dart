import 'dart:convert' as JSON;
import 'package:datient/models/doctor.dart';
import 'package:datient/models/room.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/room_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var token;
  Doctor doctor = Doctor();

  Future<List<Room>> _getRooms(token) async {
    List list;
    final response = await http.get(
      'http://10.0.2.2:8000/api/room/',
      headers: {'Authorization': 'JWT $token'},
    );
    if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body) as List;
      list = extractdata.map((json) => Room.fromJson(json)).toList();
    }
    return list;
  }

  Widget _buildRoomList(data) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(data.length, (index) {
        return Container(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RoomPage(
                        room: data[index],
                      ),
                ),
              );
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_hospital, size: 80),
                  Text(
                    data[index].roomName,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = DatientProvider.of(context).bloc;

    return Scaffold(
      appBar: AppBar(
        title: Text('Salas'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: StreamBuilder(
                stream: bloc.doctor,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.hasData
                      ? Text(
                          'Doctor: ' + '${snapshot.data.getFullName()}',
                          style: TextStyle(fontSize: 28),
                        )
                      : Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Expanded(
              flex: 9,
              child: StreamBuilder(
                stream: bloc.doctor,
                builder: (context, snap) {
                  return snap.hasData
                      ? FutureBuilder(
                          future: _getRooms(snap.data.token),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            return snapshot.hasData
                                ? _buildRoomList(snapshot.data)
                                : Center(child: CircularProgressIndicator());
                          },
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
