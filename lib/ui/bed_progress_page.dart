import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/bed.dart';
import 'package:datient/models/doctor.dart';
import 'package:datient/models/hospitalization.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/models/progress.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/add_hospitalization_page.dart';
import 'package:datient/ui/bed_detail_page.dart';
import 'package:datient/ui/discharge_patient_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'assign_patient_page.dart';

class BedProgressPage extends StatefulWidget {
  final Bed bed;

  BedProgressPage({Key key, this.bed}) : super(key: key);

  @override
  _BedProgressPageState createState() => _BedProgressPageState();
}

class _BedProgressPageState extends State<BedProgressPage> {
  Progress progress;
  Patient patient;

  Widget _buildProgress(Patient data) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        Progress progress = data.patientProgress.first;
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
                    Text(
                      'Progreso $formattedCreateDate',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  stream: patientBloc.specificPatient,
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

  Widget build(BuildContext context) {
    final bloc = DatientProvider.of(context).bloc;
    final hospitalizationBloc = DatientProvider.of(context).hospitalizationBloc;
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    bloc.doctor.listen((value) => hospitalizationBloc.getHospitalization(
        value.token, widget.bed.id, patientBloc));
    return Scaffold(
      body: _buildProgressStream()
    );
  }
}
