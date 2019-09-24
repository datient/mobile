import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/bed.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/assign_patient_progress_page.dart';
import 'package:flutter/material.dart';

class PatientAssignPage extends StatefulWidget {
  final Bed bed;
  final Patient patient;
  PatientAssignPage({Key key, this.patient, this.bed}) : super(key: key);

  @override
  _PatientAssignPageState createState() => _PatientAssignPageState();
}

class _PatientAssignPageState extends State<PatientAssignPage> {
  final _formKey = GlobalKey<FormState>();
  bool activeSearch;
  final _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    activeSearch = true;
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

  // Widget _buildGuestList(data) {
  //   return SizedBox(
  //     height: 560,
  //     child: Scrollbar(
  //       child: ListView.builder(
  //           itemCount: data.length,
  //           itemBuilder: (BuildContext context, int index) {
  //             Patient patients = data[index];
  //             return Container(
  //               child: GestureDetector(
  //                 onTap: () {
  //                   Navigator.of(context).pushReplacement(
  //                     MaterialPageRoute(
  //                       builder: (context) => AssignPatientProgressPage(
  //                         patient: data[index],
  //                         bed: widget.bed,
  //                       ),
  //                     ),
  //                   );
  //                 },
  //                 child: Card(
  //                   elevation: 6,
  //                   child: Column(
  //                     children: [
  //                       SizedBox(height: 10),
  //                       Row(
  //                         children: [
  //                           SizedBox(
  //                             width: 10,
  //                           ),
  //                           Icon(Icons.person),
  //                           SizedBox(width: 20),
  //                           Text(
  //                             patients.firstName + ' ' + patients.lastName,
  //                             style: TextStyle(
  //                                 fontSize: 18, fontWeight: FontWeight.bold),
  //                           ),
  //                         ],
  //                       ),
  //                       SizedBox(height: 10),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }),
  //     ),
  //   );
  // }

  Widget _buildGuestList(data) {
    return (data.length != 0)
        ? SizedBox(
            height: 560,
            child: Scrollbar(
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    Patient patients = data[index];
                    return Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => AssignPatientProgressPage(
                                patient: data[index],
                                bed: widget.bed,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          patients.firstName +
                                              ' ' +
                                              patients.lastName,
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
            ),
          )
        : Center(
            child: Text(
              'No se han encontrado pacientes',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
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
      appBar: AppBar(
        title: Text('Asignar paciente'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              child: TextField(
                onChanged: _search,
                controller: _searchController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildPatientStream(),
          ),
        ],
      ),
    );
  }
}
