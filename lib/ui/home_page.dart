import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/models/doctor.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/patient_page.dart';
import 'package:datient/ui/rooms_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;

  Widget _buildDoctorInfo(Doctor data) {
    DatientBloc bloc = DatientProvider.of(context).bloc;
    return ListView(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(
            data.firstName + ' ' + data.lastName,
            style: TextStyle(fontSize: 18),
          ),
          accountEmail: Text(data.email),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                ? Colors.blue
                : Colors.white,
            child: Text(
              '${data.firstName[0].toUpperCase()}${data.lastName[0].toUpperCase()}',
              style: TextStyle(fontSize: 40.0),
            ),
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed('/statistics');
          },
          title: Text(
            'Estadísticas',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          trailing: Icon(Icons.insert_chart),
        ),
        ListTile(
          onTap: () {
            bloc.signOut(data.token).then(
              (success) {
                if (success != false) {
                  Navigator.of(context).pushReplacementNamed('/login');
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        title: Row(
                          children: [
                            Icon(Icons.info_outline),
                            SizedBox(width: 10),
                            Text('Cerrar Sesión'),
                          ],
                        ),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Divider(),
                              Text(
                                'Se ha cerrado la sesión',
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
          title: Text(
            'Cerrar sesión',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          trailing: Icon(Icons.exit_to_app),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DatientBloc bloc = DatientProvider.of(context).bloc;

    final _pages = [
      RoomsPage(),
      PatientPage(),
    ];

    return SafeArea(
      child: Scaffold(
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
        drawer: Drawer(
          child: Container(
            child: StreamBuilder(
                stream: bloc.doctor,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? _buildDoctorInfo(snapshot.data)
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                }),
          ),
        ),
      ),
    );
  }
}
