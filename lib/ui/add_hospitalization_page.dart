import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/hospitalization_bloc.dart';
import 'package:datient/models/hospitalization.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class HospitalizationAddPage extends StatefulWidget {
  final Hospitalization hospitalization;

  HospitalizationAddPage({Key key, this.hospitalization}) : super(key: key);
  @override
  _HospitalizationAddPageState createState() => _HospitalizationAddPageState();
}

class Status {
  const Status(this.name);
  final String name;
}

class _HospitalizationAddPageState extends State<HospitalizationAddPage> {
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
                hintText: 'Ingrese el diagnostico del paciente',
              ),
            ),
            DropdownButtonFormField<Status>(
              decoration: InputDecoration(
                icon: Icon(Icons.traffic),
              ),
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
                  hintText: 'Ingrese una descripcion'),
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
          .createHospitalization(
              widget.hospitalization.entryDate,
              widget.hospitalization.bed,
              widget.hospitalization.doctorInCharge,
              widget.hospitalization.hospitalizedPatient,
              _diagnosis,
              _description,
              _status,
              token)
          .then((success) {
        if (success == true) {
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
                    Icon(Icons.info_outline),
                    SizedBox(width: 10),
                    Text('Hospitalizacion añadida'),
                  ],
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Divider(),
                      Text(
                        'La hospitalizacion se ha creado con exito',
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
          return false;
        }
      });
    }
  }

  Widget build(BuildContext context) {
    final DatientBloc bloc = DatientProvider.of(context).bloc;
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva hospitalizacion'),
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
