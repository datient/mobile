import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/bed.dart';
import 'package:datient/models/hospitalization.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/models/progress.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/add_hospitalization_page.dart';
import 'package:datient/ui/bed_detail_page.dart';
import 'package:datient/ui/discharge_patient_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'assign_patient_page.dart';
import 'bed_progress_page.dart';

class BedPage extends StatefulWidget {
  final Bed bed;

  BedPage({Key key, this.bed}) : super(key: key);

  @override
  _BedPageState createState() => _BedPageState();
}

class _BedPageState extends State<BedPage> {
  Progress progress;
  Patient patient;

  Widget _buildDischargeFloatingActionButton(Hospitalization data) {
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
              label: 'Nuevo progreso',
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

  Widget build(BuildContext context) {
    final bloc = DatientProvider.of(context).bloc;
    final hospitalizationBloc = DatientProvider.of(context).hospitalizationBloc;
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    bloc.doctor.listen((value) => hospitalizationBloc.getHospitalization(
        value.token, widget.bed.id, patientBloc));
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text('${widget.bed.bedName}'),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.assignment), text: 'Información'),
                Tab(icon: Icon(Icons.timeline), text: 'Progreso'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              BedDetailPage(bed: widget.bed),
              BedProgressPage(bed: widget.bed,),
            ],
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
          )),
    );
  }
}
