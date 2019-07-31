import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/bed.dart';
import 'package:datient/models/doctor.dart';
import 'package:datient/models/hospitalization.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/patient_info_page.dart';
import 'package:flutter/material.dart';

import 'bed_page.dart';

class PatientAssignPage extends StatefulWidget {
  final Bed bed;
  PatientAssignPage({Key key, this.bed}) : super(key: key);

  @override
  _PatientAssignPageState createState() => _PatientAssignPageState();
}

class _PatientAssignPageState extends State<PatientAssignPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget _buildGuestList(data) {
    return Scrollbar(
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            Patient patients = data[index];
            return Container(
              child: GestureDetector(
                onTap: () {
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
                            Text('Confirmacion de accion'),
                          ],
                        ),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Divider(),
                              Text(
                                'Esta seguro que desea asignar a ' +
                                    patients.firstName +
                                    ' ' +
                                    patients.lastName +
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
                              final hospitalizationBloc =
                                  DatientProvider.of(context)
                                      .hospitalizationBloc;
                              bloc.doctor.listen((value) =>
                                  hospitalizationBloc.assignPatient(
                                      value.id,
                                      widget.bed.id,
                                      patients.dni,
                                      value.token));
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => BedPage(
                                    bed: widget.bed,
                                  ),
                                ),
                              );
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                                patients.firstName +
                                                ' ' +
                                                patients.lastName +
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
                },
                child: Card(
                  elevation: 6,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.person),
                          SizedBox(width: 20),
                          Text(
                            patients.firstName + ' ' + patients.lastName,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget build(BuildContext context) {
    DatientBloc bloc = DatientProvider.of(context).bloc;
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    bloc.doctor.listen((value) => patientBloc.getPatients(value.token));

    return Scaffold(
      appBar: AppBar(
        title: Text('Asignar paciente'),
      ),
      body: StreamBuilder(
        stream: patientBloc.patients,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _buildGuestList(snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
