import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/bed.dart';
import 'package:datient/models/doctor.dart';
import 'package:datient/models/hospitalization.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/models/progress.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/add_hospitalization_page.dart';
import 'package:datient/ui/discharge_patient_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'assign_patient_page.dart';

class BedPage extends StatefulWidget {
  final Bed bed;

  BedPage({Key key, this.bed}) : super(key: key);

  @override
  _BedPageState createState() => _BedPageState();
}

class _BedPageState extends State<BedPage> {
  Progress progress;
  Patient patient;

  Widget _buildPatientName(Patient data) {
    return Text(
      data.firstName + ' ' + data.lastName,
      style: TextStyle(fontSize: 18),
    );
  }

  Widget _buildDoctorName(Doctor data) {
    return Text(
      data.firstName + ' ' + data.lastName,
      style: TextStyle(fontSize: 18),
    );
  }

  Widget _buildHospitalization(Hospitalization data) {
    var _patientStatus;
    if (data.progress.status == 0) {
      _patientStatus = 'Bien';
    } else if (data.progress.status == 1) {
      _patientStatus = 'Precaución';
    } else if (data.progress.status == 2) {
      _patientStatus = 'Peligro';
    }
    var dateFormatter = new DateFormat('yMd');
    var timeFormatter = new DateFormat('Hms');
    if (data.leftDate == null) {
      var entryDate = DateTime.parse(data.entryDate);
      String formattedEntryDate = dateFormatter.format(entryDate);
      String formattedTimeEntryDate = timeFormatter.format(entryDate);
      DatientBloc bloc = DatientProvider.of(context).bloc;
      PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
      bloc.doctor.listen((value) => patientBloc.getSpecificPatients(
          value.token, data.hospitalizedPatient));
      bloc.doctor.listen(
          (value) => bloc.getSpecificDoctor(value.token, data.doctorInCharge));
      return ListView(children: [
        Card(
          margin: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 6,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hospitalización',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Divider(),
                Text(
                  'Paciente internado',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                StreamBuilder(
                  stream: patientBloc.specificPatient,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? _buildPatientName(snapshot.data)
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ),
                Divider(),
                Text(
                  'Fecha de ingreso',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  formattedEntryDate + ' a las ' + formattedTimeEntryDate,
                  style: TextStyle(fontSize: 18),
                ),
                Divider(),
                Text(
                  'Atendido por',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                StreamBuilder(
                  stream: bloc.specificDoctor,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? _buildDoctorName(snapshot.data)
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ),
                Divider(),
                Text(
                  'Dias internado',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  data.boardingDays.toString(),
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 20),
                Text(
                  'Progreso',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Divider(),
                Text(
                  'Diagnóstico',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  data.progress.diagnosis,
                  style: TextStyle(fontSize: 18),
                ),
                Divider(),
                Text(
                  'Descripción',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  data.progress.description,
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
            ),
          ),
        ),
      ]);
    } else {
      return Center(
        child: Text(
          'No se han encontrado hospitalizaciones',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
  }

  Widget _buildDischargeFloatingActionButton(Hospitalization data) {
    final bloc = DatientProvider.of(context).bloc;
    final hospitalizationBloc = DatientProvider.of(context).hospitalizationBloc;
    if (data.leftDate == null) {
      return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22),
        visible: true,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
              child: Icon(Icons.add),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HospitalizationAddPage(
                      hospitalization: data,
                    ),
                  ),
                );
              },
              label: 'Nueva hospitalización',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Colors.blue),
          SpeedDialChild(
              child: Icon(Icons.assignment_turned_in),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DischargePatientPage(
                      hospitalization: data,
                    ),
                  ),
                );
              },
              label: 'Dar de alta',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Colors.blue)
        ],
      );
    } else {
      return FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Agregar paciente a la cama',
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => PatientAssignPage(
                bed: widget.bed,
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildHospitalizationStream() {
    final hospitalizationBloc = DatientProvider.of(context).hospitalizationBloc;
    return StreamBuilder(
      stream: hospitalizationBloc.isloading,
      builder: (context, snapshot) {
        return (snapshot.data == true)
            ? Center(child: CircularProgressIndicator())
            : StreamBuilder(
                stream: hospitalizationBloc.hospitalizations,
                builder: (context, snapshot) {
                  return (snapshot.hasData)
                      ? _buildHospitalization(snapshot.data)
                      : StreamBuilder(
                          stream: hospitalizationBloc.error,
                          builder: (context, snapshot) {
                            return (snapshot.hasData)
                                ? Center(
                                    child: Text(
                                    snapshot.data,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  ))
                                : Center(child: CircularProgressIndicator());
                          });
                },
              );
      },
    );
  }

  Widget build(BuildContext context) {
    final bloc = DatientProvider.of(context).bloc;
    final hospitalizationBloc = DatientProvider.of(context).hospitalizationBloc;
    bloc.doctor.listen((value) =>
        hospitalizationBloc.getHospitalization(value.token, widget.bed.id));
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.bed.bedName}'),
        ),
        body: Container(
          child: (_buildHospitalizationStream()),
        ),
        floatingActionButton: StreamBuilder(
          stream: hospitalizationBloc.hospitalizations,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? _buildDischargeFloatingActionButton(snapshot.data)
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    tooltip: 'Agregar paciente a la cama',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PatientAssignPage(
                            bed: widget.bed,
                          ),
                        ),
                      );
                    },
                  );
          },
        ));
  }
}
