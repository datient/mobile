import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/future_plan.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';

class FuturePlanEditPage extends StatefulWidget {
  final FuturePlan plan;
  final Patient patient;

  FuturePlanEditPage({Key key, this.plan, this.patient}) : super(key: key);
  @override
  _FuturePlanEditPageState createState() => _FuturePlanEditPageState();
}

class _FuturePlanEditPageState extends State<FuturePlanEditPage> {
  final _cTitle = TextEditingController();
  final _cDescription = TextEditingController();
  final GlobalKey<FormState> _createformKey = new GlobalKey<FormState>();

  void initState() {
    _cTitle..text = widget.plan.title;
    _cDescription..text = widget.plan.description;
    super.initState();
  }

  Widget _buildFuturePlanForm() {
    return Form(
      key: _createformKey,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Ingrese un título válido';
                }
              },
              controller: _cTitle,
              decoration: InputDecoration(
                icon: Icon(Icons.title),
                labelText: 'Título',
                hintText: 'Ingrese el título',
              ),
            ),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Ingrese una descripción válida';
                }
              },
              controller: _cDescription,
              decoration: InputDecoration(
                icon: Icon(Icons.subject),
                labelText: 'Descripción',
                hintText: 'Ingrese la descripción',
              ),
            ),
          ],
        ),
      ),
    );
  }

  _validateAndSubmit(token) {
    var patient = PatientBloc();
    if (_createformKey.currentState.validate()) {
      String _title = _cTitle.value.text;
      String _description = _cDescription.value.text;
      patient
          .editFuturePlan(
              widget.plan.id, _title, _description, widget.patient.dni, token)
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
                    Text('Plan futuro modificado'),
                  ],
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('El plan futuro ha sido modificado con exito'),
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
      });
    }
  }

  Widget build(BuildContext context) {
    final DatientBloc bloc = DatientProvider.of(context).bloc;

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar plan futuro'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
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
