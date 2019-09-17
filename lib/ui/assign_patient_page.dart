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
  PatientAssignPage({Key key, this.patient,this.bed}) : super(key: key);

  @override
  _PatientAssignPageState createState() => _PatientAssignPageState();
}

class _PatientAssignPageState extends State<PatientAssignPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget _buildGuestList(data) {
    return Scrollbar(
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
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
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
          }),
    );
  }

  Widget build(BuildContext context) {
    DatientBloc bloc = DatientProvider.of(context).bloc;
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    bloc.doctor.listen((value) => patientBloc.getPatients(value.token));

    return Scaffold(
      appBar: AppBar(
        title: Text('Asignar paciente'),
      ),
      body: StreamBuilder(
        stream: patientBloc.patients,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _buildGuestList(snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
