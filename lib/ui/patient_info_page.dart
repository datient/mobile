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
        Chip(
          avatar: CircleAvatar(
            child: Icon(
              Icons.person,
              size: 20,
            ),
          ),
          label: Text(
            'Nombre: ' + widget.patient.firstName,
            style: TextStyle(fontSize: 24),
          ),
        ),
        Chip(
          avatar: CircleAvatar(
            child: Icon(
              Icons.person,
              size: 20,
            ),
          ),
          label: Text(
            'Apellido: ' + widget.patient.lastName,
            style: TextStyle(fontSize: 24),
          ),
        ),
        Chip(
          avatar: CircleAvatar(
            child: Icon(
              Icons.featured_play_list,
              size: 20,
            ),
          ),
          label: Text(
            'DNI: ' + widget.patient.dni.toString(),
            style: TextStyle(fontSize: 24),
          ),
        ),
        Chip(
          avatar: CircleAvatar(
            child: Icon(
              Icons.calendar_today,
              size: 20,
            ),
          ),
          label: Text(
            'Fecha de Nacimiento: ' + widget.patient.birthDate,
            style: TextStyle(fontSize: 24),
          ),
        ),
        Chip(
          avatar: CircleAvatar(
            child: Icon(
              Icons.history,
              size: 20,
            ),
          ),
          label: Text(
            'Num. Historial: ' + widget.patient.historyNumber.toString(),
            style: TextStyle(fontSize: 24),
          ),
        ),
        Chip(
          avatar: CircleAvatar(
            child: Icon(
              Icons.people,
              size: 20,
            ),
          ),
          label: Text(
            'Genero: ' + _patientGender,
            style: TextStyle(fontSize: 24),
          ),
        ),
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
