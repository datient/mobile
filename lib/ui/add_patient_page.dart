import 'package:datient/models/patient.dart';
import 'package:flutter/material.dart';

class PatientAddPage extends StatefulWidget {
  final Patient patient;
  PatientAddPage({Key key, this.patient}) : super(key: key);
  @override
  _PatientAddPageState createState() => _PatientAddPageState();
}

class _PatientAddPageState extends State<PatientAddPage> {
  @override
  Widget _buildPatientForm() {
    return Form(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  icon: Icon(Icons.person), labelText: 'Nombre'),
            ),
            TextFormField(
              decoration: InputDecoration(
                  icon: Icon(Icons.person), labelText: 'Apellido'),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  icon: Icon(Icons.picture_in_picture), labelText: 'DNI'),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  icon: Icon(Icons.book),
                  labelText: 'Numero de historial'),
            ),
            TextFormField(
              decoration: InputDecoration(
                  icon: Icon(Icons.assignment),
                  labelText: 'Diagnostico Inicial'),
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear paciente'),
      ),
      body: ListView(children: [
        _buildPatientForm(),
      ]),
    );
  }
}
