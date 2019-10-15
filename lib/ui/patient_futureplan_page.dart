import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/future_plan.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'edit_futureplan_page.dart';

class PatientFuturePlanPage extends StatefulWidget {
  final Patient patient;
  PatientFuturePlanPage({Key key, this.patient}) : super(key: key);

  @override
  _PatientFuturePlanState createState() => _PatientFuturePlanState();
}

class _PatientFuturePlanState extends State<PatientFuturePlanPage> {
  Widget _buildFuturePlanStream() {
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    return StreamBuilder(
        stream: patientBloc.isloading,
        builder: (context, snapshot) {
          return (snapshot.hasData && snapshot.data)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder(
                  stream: patientBloc.patientFuturePlan,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        snapshot.error,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ));
                    } else {
                      return snapshot.hasData
                          ? _buildFuturePlan(snapshot.data)
                          : Container();
                    }
                  });
        });
  }

  Widget _buildFuturePlan(Patient data) {
    return ListView.builder(
      itemCount: data.futurePlans.length,
      itemBuilder: (BuildContext context, int index) {
        FuturePlan plans = data.futurePlans[index];

        void chooseAction(choice) {
          DatientBloc bloc = DatientProvider.of(context).bloc;
          PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
          if (choice == 'edit') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FuturePlanEditPage(
                    plan: data.futurePlans[index], patient: data),
              ),
            );
          }
          if (choice == 'delete') {
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
                      Text('Confirmación de accion'),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Divider(),
                        Text(
                          'Esta seguro que desea eliminar el plan futuro?',
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
                        bloc.doctor.listen(
                          (value) => patientBloc
                              .deleteFuturePlan(plans.id, value.token)
                              .then(
                            (success) {
                              if (success == true) {
                                Navigator.of(context).pop();
                                return showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Row(
                                        children: [
                                          Icon(Icons.info_outline),
                                          SizedBox(width: 10),
                                          Text('Paciente eliminado'),
                                        ],
                                      ),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text(
                                                'Estudio complementario eliminado con éxito'),
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
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                            },
                          ),
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
          }
        }

        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
              child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.only(top: 4, bottom: 4),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        plans.title,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      PopupMenuButton(
                        onSelected: chooseAction,
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.grey,
                        ),
                        itemBuilder: (_) => <PopupMenuItem<String>>[
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.edit,
                                ),
                                Text(
                                  'Editar',
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                Text(
                                  'Eliminar',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Divider(),
                  Text(
                    plans.description,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          )),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    DatientBloc bloc = DatientProvider.of(context).bloc;
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    bloc.doctor.listen(
        (value) => patientBloc.getFuturePlan(widget.patient.dni, value.token));
    return Scaffold(
      body: Container(child: _buildFuturePlanStream()),
    );
  }
}
