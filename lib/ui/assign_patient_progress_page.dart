import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/hospitalization_bloc.dart';
import 'package:datient/models/bed.dart';
import 'package:datient/models/hospitalization.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

import 'bed_page.dart';

class AssignPatientProgressPage extends StatefulWidget {
  final Bed bed;
  final Patient patient;
  final Hospitalization hospitalization;

  AssignPatientProgressPage(
      {Key key, this.hospitalization, this.patient, this.bed})
      : super(key: key);
  @override
  _AssignPatientProgressPageState createState() =>
      _AssignPatientProgressPageState();
}

class Status {
  const Status(this.name);
  final String name;
}

class _AssignPatientProgressPageState extends State<AssignPatientProgressPage> {
  final _cDiagnosis = TextEditingController();
  final _cDescription = TextEditingController();
  var statusIndex;
  Status selectedStatus;
  List<Status> statuses = <Status>[
    const Status('Bien'),
    const Status('Precaucion'),
    const Status('Peligro'),
  ];
  final GlobalKey<FormState> _createformKey = new GlobalKey<FormState>();
  @override
  Widget _buildHospitalizationForm() {
    return Form(
      key: _createformKey,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextFormField(
              controller: _cDiagnosis,
              decoration: InputDecoration(
                icon: Icon(Icons.assignment),
                labelText: 'Diagnostico',
                hintText: 'Ingrese el diagnostico de ingreso del paciente',
              ),
            ),
            DropdownButtonFormField<Status>(
              decoration: InputDecoration(
                icon: Icon(Icons.traffic),
              ),
              hint: Text('Seleccione el estado de ingreso del paciente'),
              value: selectedStatus,
              onChanged: (Status newValue) {
                setState(() {
                  selectedStatus = newValue;
                  statusIndex = statuses.indexOf(newValue);
                });
              },
              items: statuses.map((Status status) {
                return new DropdownMenuItem<Status>(
                  value: status,
                  child: new Text(
                    status.name,
                    style: new TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
            TextFormField(
              controller: _cDescription,
              decoration: InputDecoration(
                  icon: Icon(Icons.subject),
                  labelText: 'Descripcion',
                  hintText: 'Ingrese una descripcion de ingreso'),
            ),
          ],
        ),
      ),
    );
  }

  _validateAndSubmit(token) {
    if (_createformKey.currentState.validate()) {
      String _diagnosis = _cDiagnosis.value.text;
      String _description = _cDescription.value.text;
      int _status = statusIndex;
      var hospitalization = HospitalizationBloc();
      final bloc = DatientProvider.of(context).bloc;
      bloc.doctor.listen(
        (value) => hospitalization
            .assignPatient(_diagnosis, _description, _status,
                widget.patient.dni, value.id, widget.bed.id, value.token)
            .then((success) {
          if (success == true) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  title: Row(
                    children: [
                      Icon(Icons.check_circle_outline),
                      SizedBox(width: 10),
                      Text('Paciente asignado'),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Divider(),
                        Text(
                          'El paciente ' +
                              widget.patient.firstName +
                              ' ' +
                              widget.patient.lastName +
                              ' ha sido asignado con exito a la cama ' +
                              widget.bed.id.toString(),
                          style: TextStyle(fontSize: 18),
                        )
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
          }
        }),
      );
    }
  }

  _confirmationDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.info_outline),
              SizedBox(width: 10),
              Text('Confirmacion de accion'),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Divider(),
                Text(
                  'Esta seguro que desea asignar a ' +
                      widget.patient.firstName +
                      ' ' +
                      widget.patient.lastName +
                      ' a la cama ' +
                      widget.bed.id.toString() +
                      '?',
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              child: Text('Confirmar'),
              color: Colors.green,
              onPressed: () {
                final bloc = DatientProvider.of(context).bloc;
                bloc.doctor.listen((value) => _validateAndSubmit(value.token));
              },
            ),
            FlatButton(
              textColor: Colors.white,
              child: Text('Cancelar'),
              color: Colors.red,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    final DatientBloc bloc = DatientProvider.of(context).bloc;
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingresar paciente'),
        actions: [
          IconButton(
            icon: Icon(Icons.assignment_turned_in),
            onPressed: () {
              _confirmationDialog();
            },
          )
        ],
      ),
      body: ListView(children: [
        _buildHospitalizationForm(),
      ]),
    );
  }
}
