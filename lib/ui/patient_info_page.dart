import 'package:datient/models/patient.dart';
import 'package:flutter/material.dart';

class PatientInfoPage extends StatefulWidget {
  final Patient patient;
  PatientInfoPage({Key key, this.patient}) : super(key: key);
  @override
  _PatientInfoPageState createState() => _PatientInfoPageState();
}

class _PatientInfoPageState extends State<PatientInfoPage> {

  @override
  Widget build(BuildContext context) {
    var _fullname = widget.patient.firstName+' '+widget.patient.lastName;
    return Scaffold(
      appBar: AppBar(
        title: Text(_fullname),
      ),
      body: Container(
        child: Column(
          children: [
            Text(widget.patient.lastName),
          ],
        ),
      ),
    );
  }
}