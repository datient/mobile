import 'package:datient/models/doctor.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/room_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var token;
  Doctor doctor = Doctor();

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
    final roomBloc = DatientProvider.of(context).roomBloc;

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
                      ? StreamBuilder(
                          stream: roomBloc.rooms,
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
