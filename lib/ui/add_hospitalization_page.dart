import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/hospitalization_bloc.dart';
import 'package:datient/models/hospitalization.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';

class HospitalizationAddPage extends StatefulWidget {
  final Hospitalization hospitalization;

  HospitalizationAddPage({Key key, this.hospitalization}) : super(key: key);
  @override
  _HospitalizationAddPageState createState() => _HospitalizationAddPageState();
}

class Status {
  const Status(this.name, this.icon);
  final String name;
  final Widget icon;
}

class _HospitalizationAddPageState extends State<HospitalizationAddPage> {
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
                hintText: 'Ingrese el diagnóstico del paciente',
              ),
            ),
            DropdownButtonFormField<Status>(
              decoration: InputDecoration(
                  icon: Icon(Icons.traffic), errorText: statusError),
              hint: Text('Seleccione el estado del paciente'),
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
              maxLength: null,
              controller: _cDescription,
              decoration: InputDecoration(
                  errorText: descriptionError,
                  icon: Icon(Icons.subject),
                  labelText: 'Descripción',
                  hintText: 'Ingrese una descripción'),
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
      hospitalization
          .createHospitalization(widget.hospitalization.hospitalizedPatient,
              _diagnosis, _description, _status, token)
          .then((success) {
        if (success == true) {
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
                    Text('Progreso actualizado'),
                  ],
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Divider(),
                      Text(
                        'El progreso se ha actualizado con éxito',
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
                        Text(success['detail']),
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
      });
    }
  }

  Widget build(BuildContext context) {
    final DatientBloc bloc = DatientProvider.of(context).bloc;
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo progreso'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              bloc.doctor.listen((value) => _validateAndSubmit(value.token));
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
