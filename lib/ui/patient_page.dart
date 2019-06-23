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
  return ListView.builder(
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
                  Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 20),
                      Text(
                        patients.firstName + ' ' + patients.lastName,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      });
}

class _BedPageState extends State<PatientPage> {
  @override
  Widget build(BuildContext context) {
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;

    return Scaffold(
      body: StreamBuilder(
        stream: patientBloc.patients,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _buildGuestList(snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: () {}, child: Icon(Icons.person_add)),
    );
  }
}
