import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';

class FuturePlanAddPage extends StatefulWidget {
  final Patient patient;
  FuturePlanAddPage({Key key, this.patient}) : super(key: key);
  @override
  _FuturePlanAddPageState createState() => _FuturePlanAddPageState();
}

class Status {
  const Status(this.name);
  final String name;
}

class _FuturePlanAddPageState extends State<FuturePlanAddPage> {
  final _cTitle = TextEditingController();
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
  Widget _buildFuturePlanForm() {
    return Form(
      key: _createformKey,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextFormField(
              controller: _cTitle,
              decoration: InputDecoration(
                icon: Icon(Icons.title),
                labelText: 'Titulo',
                hintText: 'Ingrese el titulo',
              ),
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
      String _title = _cTitle.value.text;
      String _description = _cDescription.value.text;
      var patient = PatientBloc();
      patient
          .postFuturePlan(_title, _description, widget.patient.dni, token)
          .then((success) {});
    }
  }

  Widget build(BuildContext context) {
    final DatientBloc bloc = DatientProvider.of(context).bloc;
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Plan Futuro'),
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
        _buildFuturePlanForm(),
      ]),
    );
  }
}