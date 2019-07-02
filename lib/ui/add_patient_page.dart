import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/providers/datient_provider.dart';
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
    final DatientBloc bloc = DatientProvider.of(context).bloc;

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
                  icon: Icon(Icons.book), labelText: 'Numero de historial'),
            ),
            TextFormField(
              decoration: InputDecoration(
                  icon: Icon(Icons.assignment),
                  labelText: 'Diagnostico Inicial'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: RaisedButton(
                child: Text(
                  'Crear',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, wordSpacing: 5),
                ),
                onPressed: () {
                  bloc.doctor.listen((value) => _createPatient(value.token));
                },
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createPatient(token) {
    var patient = PatientBloc();
    patient.createPatient(
        'Facundo', 'Barafani', 20560780, '2015-06-19', 10, 0, 'prueba', token);
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
