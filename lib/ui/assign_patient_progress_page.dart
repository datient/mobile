import 'package:datient/bloc/hospitalization_bloc.dart';
import 'package:datient/models/bed.dart';
import 'package:datient/models/hospitalization.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';

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
  const Status(this.name, this.icon);
  final String name;
  final Widget icon;
}

class _AssignPatientProgressPageState extends State<AssignPatientProgressPage> {
  final _cDiagnosis = TextEditingController();
  final _cDescription = TextEditingController();
  var statusIndex;
  Status selectedStatus;
  List<Status> statuses = <Status>[
    const Status(
      'Bien',
      Icon(
        Icons.fiber_manual_record,
        color: Colors.green,
      ),
    ),
    const Status(
      'Precaución',
      Icon(
        Icons.fiber_manual_record,
        color: Colors.yellow,
      ),
    ),
    const Status(
      'Peligro',
      Icon(
        Icons.fiber_manual_record,
        color: Colors.red,
      ),
    ),
  ];
  final GlobalKey<FormState> _createformKey = new GlobalKey<FormState>();
  String statusError;
  String diagnosisError;
  String descriptionError;

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
                errorText: diagnosisError,
                icon: Icon(Icons.assignment),
                labelText: 'Diagnóstico',
                hintText: 'Ingrese el diagnóstico de ingreso del paciente',
              ),
            ),
            DropdownButtonFormField<Status>(
              decoration: InputDecoration(
                errorText: statusError,
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
                  child: Row(
                    children: [
                      status.icon,
                      Text(status.name),
                    ],
                  ),
                );
              }).toList(),
            ),
            TextFormField(
              controller: _cDescription,
              decoration: InputDecoration(
                  errorText: descriptionError,
                  icon: Icon(Icons.subject),
                  labelText: 'Descripción',
                  hintText: 'Ingrese una descripción de ingreso'),
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
                              ' ha sido asignado con éxito a la cama ' +
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
          } else {
            Navigator.of(context).pop();
            if (success['status'] != null) {
              List _statusError = success['status'];
              statusError = '';
              _statusError.forEach((error) {
                setState(() {
                  statusError += '$error ';
                });
              });
            }
            if (success['diagnosis'] != null) {
              List _diagnosisError = success['diagnosis'];
              diagnosisError = '';
              _diagnosisError.forEach((error) {
                setState(() {
                  diagnosisError += '$error ';
                });
              });
            }
            if (success['description'] != null) {
              List _descriptionError = success['description'];
              descriptionError = '';
              _descriptionError.forEach((error) {
                setState(() {
                  descriptionError += '$error ';
                });
              });
            }
            if (success['detail'] != null) {
              Navigator.of(context).pop();
              return showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    title: Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 10),
                        Text('Ha ocurrido un error'),
                      ],
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(success),
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
              Text('Confirmación de acción'),
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
