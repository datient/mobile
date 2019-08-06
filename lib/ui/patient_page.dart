import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/patient_info_page.dart';
import 'package:flutter/material.dart';

class PatientPage extends StatefulWidget {
  PatientPage({Key key}) : super(key: key);

  @override
  _BedPageState createState() => _BedPageState();
}

class _BedPageState extends State<PatientPage> {
  final _formKey = GlobalKey<FormState>();
  bool activeSearch;

  @override
  void initState() {
    super.initState();
    activeSearch = false;
  }

  PreferredSizeWidget _appBar() {
    DatientBloc bloc = DatientProvider.of(context).bloc;
    if (activeSearch) {
      return AppBar(
        leading: Icon(Icons.search),
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Buscar paciente',
            hintStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => setState(() => activeSearch = false),
          )
        ],
      );
    } else {
      return AppBar(
        automaticallyImplyLeading: false,
        title: Text('Pacientes'),
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
                              if (success == true) {
                                Navigator.of(context).pushReplacementNamed('/');
                              } else {}
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
        actions: [
          IconButton(
            onPressed: () => setState(() => activeSearch = true),
            icon: Icon(Icons.search),
          ),
        ],
      );
    }
  }

  Widget _buildGuestList(data) {
    return Scrollbar(
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            Patient patients = data[index];
            return Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PatientInfoPage(
                        patient: data[index],
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 6,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Column(children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.account_circle,
                              size: 35,
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  patients.firstName + ' ' + patients.lastName,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  patients.dni.toString(),
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ]),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget build(BuildContext context) {
    DatientBloc bloc = DatientProvider.of(context).bloc;
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    bloc.doctor.listen((value) => patientBloc.getPatients(value.token));

    return Scaffold(
      appBar: _appBar(),
      body: StreamBuilder(
        stream: patientBloc.patients,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _buildGuestList(snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/patientadd');
          },
          child: Icon(Icons.person_add)),
    );
  }
}
