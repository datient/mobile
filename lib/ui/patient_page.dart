import 'package:datient/models/patient.dart';
import 'package:flutter/material.dart';

class PatientPage extends StatefulWidget {
  final Patient patient;
  PatientPage({Key key, this.patient}) : super(key: key);

  @override
  _BedPageState createState() => _BedPageState();
}

class _BedPageState extends State<PatientPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text('Prueba'),
          ],
        ),
      ),
    );
  }
}
