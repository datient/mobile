import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/login_page.dart';
import 'package:datient/ui/patient_info_page.dart';
import 'package:flutter/material.dart';

class PatientPage extends StatefulWidget {
  PatientPage({Key key}) : super(key: key);

  @override
  _BedPageState createState() => _BedPageState();
}

class _BedPageState extends State<PatientPage> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  bool activeSearch;

  @override
  void initState() {
    super.initState();
    activeSearch = false;
  }

  void _search(String queryString) {
    final bloc = DatientProvider.of(context).bloc;
    final patientBloc = DatientProvider.of(context).patientBloc;
    setState(() {
      var search = _searchController.value.text;
      bloc.doctor
          .listen((value) => patientBloc.searchPatient(value.token, search));
    });
  }

  PreferredSizeWidget _appBar() {
    DatientBloc bloc = DatientProvider.of(context).bloc;
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    if (activeSearch) {
      return AppBar(
        leading: Icon(Icons.search),
        title: TextField(
          onChanged: _search,
          controller: _searchController,
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
            onPressed: () {
              setState(() => activeSearch = false);
              _searchController.clear();
              var search = _searchController.value.text;
              bloc.doctor.listen(
                  (value) => patientBloc.searchPatient(value.token, search));
            },
          )
        ],
      );
    } else {
      return AppBar(
        title: Text('Pacientes'),
        actions: [
          IconButton(
            onPressed: () => setState(() => activeSearch = true),
            icon: Icon(Icons.search),
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.account_circle,
            size: 35,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      );
    }
  }

  Widget _buildGuestList(data) {
    return (data.length != 0)
    ? Scrollbar(
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
                              color: Colors.blue,
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
    )
    : Center(child: Text('No se han encontrado pacientes',style: TextStyle(fontSize:18,color: Colors.grey),),);
  }

  _buildPatientStream() {
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    if (activeSearch) {
      return StreamBuilder(
        stream: patientBloc.searchedPatients,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _buildGuestList(snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      );
    } else {
      return StreamBuilder(
        stream: patientBloc.patients,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _buildGuestList(snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      );
    }
  }

  Widget build(BuildContext context) {
    DatientBloc bloc = DatientProvider.of(context).bloc;
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    bloc.doctor.listen((value) => patientBloc.getPatients(value.token));

    return Scaffold(
      appBar: _appBar(),
      body: _buildPatientStream(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/patientadd');
          },
          child: Icon(Icons.person_add)),
    );
  }
}
