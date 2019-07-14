import 'package:datient/models/patient.dart';
import 'package:flutter/material.dart';
import 'edit_patient_page.dart';
import 'package:intl/intl.dart';

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
    return ListView(
      children: [
        Card(
          margin: EdgeInsets.all(10),
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nombre',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      widget.patient.firstName,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apellido',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      widget.patient.lastName,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DNI',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      widget.patient.dni.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fecha de nacimiento',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      widget.patient.birthDate,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edad',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      widget.patient.age.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Numero de historial',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      widget.patient.historyNumber.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Genero',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      _patientGender,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diagnostico Inicial',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      widget.patient.incomeDiagnostic,
                      maxLines: 3,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget build(BuildContext context) {
    var _createdDate = DateTime.parse(widget.patient.createdDate);
    var _updatedDate = DateTime.parse(widget.patient.updatedDate);
    var formatter = new DateFormat('yMMMMEEEEd');
    String formattedCreateDate = formatter.format(_createdDate);
    String formattedUpdateDate = formatter.format(_updatedDate);
    var _fullname = widget.patient.firstName + ' ' + widget.patient.lastName;

    if (widget.patient.gender == 0) {
      _patientGender = 'Masculino';
    } else {
      _patientGender = 'Femenino';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_fullname),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Detalles'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(
                            'Fecha de creacion',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(formattedCreateDate),
                          Divider(),
                          Text(
                            'Ultima actualizacion',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(formattedUpdateDate)
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Cerrar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      body: Container(child: _buildPatientInfo()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PatientEditPage(
                patient: widget.patient,
              ),
            ),
          );
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
