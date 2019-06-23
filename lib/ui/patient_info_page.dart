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
    var _fullname = widget.patient.firstName + ' ' + widget.patient.lastName;
    return Scaffold(
      appBar: AppBar(
        title: Text(_fullname),
      ),
      body: Container(
        child: Column(
          children: [
            Card(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.person,
                        size: 40,
                      ),
                      Text(
                        'Nombre: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.patient.firstName,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(width: 30),
                      Text(
                        'Apellido: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.patient.lastName,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'DNI: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.patient.dni.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Fecha de Nacimiento: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.patient.birthDate,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Numero de Historial: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.patient.historyNumber.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Genero: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.patient.gender.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
