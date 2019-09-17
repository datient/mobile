import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/models/progress.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatientProgressPage extends StatefulWidget {
  final Patient patient;
  PatientProgressPage({Key key, this.patient}) : super(key: key);

  @override
  _PatientProgressState createState() => _PatientProgressState();
}

class _PatientProgressState extends State<PatientProgressPage> {
  @override
  Widget _buildProgressStream() {
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    return StreamBuilder(
        stream: patientBloc.isloading,
        builder: (context, snapshot) {
          return (snapshot.hasData && snapshot.data)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder(
                  stream: patientBloc.patientProgress,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        snapshot.error,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ));
                    } else {
                      return snapshot.hasData
                          ? _buildProgress(snapshot.data)
                          : Container();
                    }
                  });
        });
  }

  Widget _buildProgress(Patient data) {
    return ListView.builder(
      itemCount: data.patientProgress.length,
      itemBuilder: (BuildContext context, int index) {
        Progress progress = data.patientProgress[index];
        var _patientStatus;
        if (progress.status == 0) {
          _patientStatus = 'Bien';
        } else if (progress.status == 1) {
          _patientStatus = 'Precaución';
        } else if (progress.status == 2) {
          _patientStatus = 'Peligro';
        }
        var _createdDate = DateTime.parse(progress.createdAt);
        var dateFormatter = new DateFormat('dd-MM-yyyy');
        String formattedCreateDate = dateFormatter.format(_createdDate);
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
                      children: [
                        Text(
                          'Progreso $formattedCreateDate',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 60,
                        ),
                        _buildHasLeft(progress.hasLeft)
                      ],
                    ),
                    Divider(),
                    Text(
                      'Diagnóstico',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      progress.diagnosis,
                      style: TextStyle(fontSize: 18),
                    ),
                    Divider(),
                    Text(
                      'Descripción',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      progress.description,
                      style: TextStyle(fontSize: 18),
                    ),
                    Divider(),
                    Text(
                      'Estado',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      _patientStatus,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                )),
          )),
        );
      },
    );
  }

  Widget _buildHasLeft(data) {
    return data == true
        ? Chip(
            backgroundColor: Colors.red,
            label: Text(
              'Dado de alta',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          )
        : Container();
  }

  Widget build(BuildContext context) {
    DatientBloc bloc = DatientProvider.of(context).bloc;
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    bloc.doctor.listen(
        (value) => patientBloc.getProgress(widget.patient.dni, value.token));
    return Scaffold(
        body: Container(
      child: _buildProgressStream(),
    ));
  }
}
