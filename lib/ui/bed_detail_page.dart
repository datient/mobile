import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/bed.dart';
import 'package:datient/models/doctor.dart';
import 'package:datient/models/hospitalization.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/models/progress.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/patient_info_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BedDetailPage extends StatefulWidget {
  final Bed bed;

  BedDetailPage({Key key, this.bed}) : super(key: key);

  @override
  _BedDetailPageState createState() => _BedDetailPageState();
}

class _BedDetailPageState extends State<BedDetailPage> {
  Progress progress;
  Patient patient;

  Widget _buildPatientName(Patient data) {
    return Row(
      children: [
        Text(
          data.firstName + ' ' + data.lastName,
          style: TextStyle(fontSize: 18),
        ),
        IconButton(
          icon: Icon(
            Icons.launch,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PatientInfoPage(
                  patient: data,
                ),
              ),
            );
          },
          tooltip: 'Ir al paciente',
        )
      ],
    );
  }

  Widget _buildDoctorName(Doctor data) {
    return Text(
      data.firstName + ' ' + data.lastName,
      style: TextStyle(fontSize: 18),
    );
  }

  Widget _buildHospitalization(Hospitalization data) {
    var dateFormatter = new DateFormat('dd-MM-yyyy');
    var timeFormatter = new DateFormat('Hms');
    if (data.leftDate == null) {
      var entryDate = DateTime.parse(data.entryDate);
      String formattedEntryDate = dateFormatter.format(entryDate);
      String formattedTimeEntryDate = timeFormatter.format(entryDate);
      DatientBloc bloc = DatientProvider.of(context).bloc;
      PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
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
                  'Días internado',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  data.boardingDays.toString(),
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
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    bloc.doctor.listen((value) => hospitalizationBloc.getHospitalization(
        value.token, widget.bed.id, patientBloc));
    return Scaffold(
      body: _buildHospitalizationStream(),
    );
  }
}
