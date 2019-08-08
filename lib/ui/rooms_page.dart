import 'package:datient/models/doctor.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/patient_page.dart';
import 'package:datient/ui/room_page.dart';
import 'package:flutter/material.dart';

class RoomsPage extends StatefulWidget {
  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  var token;
  Doctor doctor = Doctor();

  Widget _buildRoomList(data) {
    return Scrollbar(
      child: GridView.count(
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
                elevation: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_hospital, size: 80),
                    Text(
                      data[index].roomName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRoomPage(bloc, roomBloc) {
    return Container(
      child: Column(
        children: [
          Expanded(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = DatientProvider.of(context).bloc;
    final roomBloc = DatientProvider.of(context).roomBloc;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Salas'),
        leading: PopupMenuButton(
          icon: Icon(
            Icons.account_circle,
            size: 35,
          ),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.person),
                  SizedBox(
                    width: 8,
                  ),
                  StreamBuilder(
                    stream: bloc.doctor,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return snapshot.hasData
                          ? Text(
                              '${snapshot.data.getFullName()}',
                            )
                          : Center(child: CircularProgressIndicator());
                    },
                  )
                ],
              ),
            ),
            PopupMenuItem(
                child: StreamBuilder(
              stream: bloc.doctor,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return snapshot.hasData
                    ? GestureDetector(
                        onTap: () {
                          bloc.signOut('${snapshot.data.token}').then(
                            (success) {
                              if (success != false) {
                                Navigator.of(context)
                                    .pushReplacementNamed('/login');
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      title: Row(
                                        children: [
                                          Icon(Icons.info_outline),
                                          SizedBox(width: 10),
                                          Text('Se ha cerrado la sesión'),
                                        ],
                                      ),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Divider(),
                                            Text(
                                              success,
                                              style: TextStyle(fontSize: 18),
                                            )
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Cerrar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.exit_to_app),
                            Text('Cerrar sesion')
                          ],
                        ),
                      )
                    : Center(child: CircularProgressIndicator());
              },
            ))
          ],
        ),
      ),
      body: _buildRoomPage(bloc, roomBloc),
    );
  }
}
