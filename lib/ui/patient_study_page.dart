import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/models/study.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/patient_info_page.dart';
import 'package:flutter/material.dart';

class PatientStudyPage extends StatefulWidget {
  final Patient patient;
  PatientStudyPage({Key key, this.patient}) : super(key: key);

  @override
  _PatientStudyState createState() => _PatientStudyState();
}

class _PatientStudyState extends State<PatientStudyPage> {
  @override
  Widget _buildStudyStream() {
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    return StreamBuilder(
        stream: patientBloc.isloading,
        builder: (context, snapshot) {
          return (snapshot.hasData && snapshot.data)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder(
                  stream: patientBloc.patientStudy,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        snapshot.error,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ));
                    } else {
                      return snapshot.hasData
                          ? _buildPatientStudies(snapshot.data)
                          : Container();
                    }
                  });
        });
  }

  Widget _buildPatientStudies(Patient data) {
    return ListView.builder(
      itemCount: data.studies.length,
      itemBuilder: (BuildContext context, int index) {
        Study studies = data.studies[index];

        void chooseAction(choice) {
          DatientBloc bloc = DatientProvider.of(context).bloc;
          PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
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
                          'Esta seguro que desea eliminar el estudio complementario?',
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
                        bloc.doctor.listen((value) =>
                            patientBloc.deleteStudy(studies.id, value.token));
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
            child: GestureDetector(
              child: Hero(
                tag: 'studyHero$index',
                child: Card(
                    color: Colors.blue,
                    child: Column(children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Text(
                              'Estudio ${studies.id}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          Spacer(),
                          PopupMenuButton(
                            onSelected: chooseAction,
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            itemBuilder: (_) => <PopupMenuItem<String>>[
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
                      Image.network(studies.image),
                    ])),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return DetailScreen(image: studies.image, index: index);
                }));
              },
            ),
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    DatientBloc bloc = DatientProvider.of(context).bloc;
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    bloc.doctor.listen(
        (value) => patientBloc.getStudy(widget.patient.dni, value.token));
    return Scaffold(
      body: Container(
        child: _buildStudyStream(),
      ),
    );
  }
}
