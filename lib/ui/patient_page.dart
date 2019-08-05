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
                    Column(),
                    SizedBox(height: 10),
                    Column(children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.account_circle,size: 35,),
                          SizedBox(width: 20),
                          Column(
                            children: [
                              Text(
                                patients.firstName + ' ' + patients.lastName,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                patients.dni.toString(),
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
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

class _BedPageState extends State<PatientPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    DatientBloc bloc = DatientProvider.of(context).bloc;
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    bloc.doctor.listen((value) => patientBloc.getPatients(value.token));

    return Scaffold(
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
