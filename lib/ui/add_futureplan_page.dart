import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';

class FuturePlanAddPage extends StatefulWidget {
  final Patient patient;
  FuturePlanAddPage({Key key,this.patient}) : super(key: key);
  @override
  _FuturePlanAddPageState createState() => _FuturePlanAddPageState();
}

class Status {
  const Status(this.name);
  final String name;
}

class _FuturePlanAddPageState extends State<FuturePlanAddPage> {
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
  Widget _buildFuturePlanForm() {
    return Form(
      key: _createformKey,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextFormField(
              controller: _cDiagnosis,
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
    // if (_createformKey.currentState.validate()) {
    //   String _diagnosis = _cDiagnosis.value.text;
    //   String _description = _cDescription.value.text;
    //   int _status = statusIndex;
    //   var hospitalization = HospitalizationBloc();
    //   hospitalization
    //       .createHospitalization(
    //           widget.hospitalization.entryDate,
    //           widget.hospitalization.bed,
    //           widget.hospitalization.doctorInCharge,
    //           widget.hospitalization.hospitalizedPatient,
    //           _diagnosis,
    //           _description,
    //           _status,
    //           token)
    //       .then((success) {
    //     if (success == true) {
    //       Navigator.of(context).pop();
    //       showDialog<void>(
    //         context: context,
    //         barrierDismissible: false,
    //         builder: (BuildContext context) {
    //           return AlertDialog(
    //             shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(15)),
    //             title: Row(
    //               children: [
    //                 Icon(Icons.info_outline),
    //                 SizedBox(width: 10),
    //                 Text('Hospitalizacion añadida'),
    //               ],
    //             ),
    //             content: SingleChildScrollView(
    //               child: ListBody(
    //                 children: <Widget>[
    //                   Divider(),
    //                   Text(
    //                     'La hospitalizacion se ha creado con exito',
    //                     style: TextStyle(fontSize: 18),
    //                   )
    //                 ],
    //               ),
    //             ),
    //             actions: <Widget>[
    //               FlatButton(
    //                 child: Text('Cerrar'),
    //                 onPressed: () {
    //                   Navigator.of(context).pop();
    //                 },
    //               ),
    //             ],
    //           );
    //         },
    //       );
    //     } else {
    //       return false;
    //     }
    //   });
    // }
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