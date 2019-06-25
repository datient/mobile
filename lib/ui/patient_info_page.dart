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
  var _patientGender;

  Widget _buildPatientInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          margin: EdgeInsets.all(10),
          elevation: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text('Nombre'),
                  Text(
                    widget.patient.firstName,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Divider(),
              Column(
                children: [
                  Text('Apellido'),
                  Text(
                    widget.patient.lastName,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Divider(),
              Column(
                children: [
                  Text('Fecha de nacimiento'),
                  Text(
                    widget.patient.birthDate,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Divider(),
              Column(
                children: [
                  Text('Edad'),
                  Text(
                    widget.patient.age.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Divider(),
              Column(
                children: [
                  Text('Numero de historial'),
                  Text(
                    widget.patient.age.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Divider(),
              Column(
                children: [
                  Text('Genero'),
                  Text(
                    _patientGender,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget build(BuildContext context) {
    var _fullname = widget.patient.firstName + ' ' + widget.patient.lastName;

    if (widget.patient.gender == 0) {
      _patientGender = 'Masculino';
    } else {
      _patientGender = 'Femenino';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_fullname),
      ),
      body: Container(child: _buildPatientInfo()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.edit),
      ),
    );
  }
}
