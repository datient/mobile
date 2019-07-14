import 'package:datient/models/doctor.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/patient_page.dart';
import 'package:datient/ui/room_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var token;
  Doctor doctor = Doctor();
  int _selectedPage = 0;

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
              elevation: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_hospital, size: 80),
                  Text(
                    data[index].roomName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
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

  _setTitle() {
    if (_selectedPage == 0) {
      return Text('Salas');
    } else {
      return Text('Pacientes');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = DatientProvider.of(context).bloc;
    final roomBloc = DatientProvider.of(context).roomBloc;
    final _pages = [
      _buildRoomPage(bloc, roomBloc),
      PatientPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: _setTitle(),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.account_circle),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.person),
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Icon(Icons.exit_to_app), Text('Cerrar sesion')],
                ),
              )
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        selectedFontSize: 15,
        unselectedFontSize: 15,
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            title: Text('Salas'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Pacientes'),
          ),
        ],
      ),
      body: _pages[_selectedPage],
    );
  }
}
