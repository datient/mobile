import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';

class PatientPage extends StatefulWidget {
  PatientPage({Key key}) : super(key: key);

  @override
  _BedPageState createState() => _BedPageState();
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
              ? Text(snapshot.data.toString())
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
