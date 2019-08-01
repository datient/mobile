import 'package:datient/models/bed.dart';
import 'package:datient/models/hospitalization.dart';
import 'package:datient/models/progress.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'assign_patient_page.dart';

class BedPage extends StatefulWidget {
  final Bed bed;

  BedPage({Key key, this.bed}) : super(key: key);

  @override
  _BedPageState createState() => _BedPageState();
}

class _BedPageState extends State<BedPage> {
  Progress progress;

  Widget _buildHospitalization(Hospitalization data) {
    var _patientStatus;
    if (data.progress.status == 0) {
      _patientStatus = 'Bien';
    } else if (data.progress.status == 1) {
      _patientStatus = 'Precaucion';
    } else if (data.progress.status == 2) {
      _patientStatus = 'Peligro';
    }
    var dateFormatter = new DateFormat('yMd');
    var timeFormatter = new DateFormat('Hms');
    if (data.leftDate == null) {
      var entryDate = DateTime.parse(data.entryDate);
      String formattedEntryDate = dateFormatter.format(entryDate);
      String formattedTimeEntryDate = timeFormatter.format(entryDate);
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
                  'Hospitalizacion',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Divider(),
                Text(
                  'Paciente internado',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  data.hospitalizedPatient.toString(),
                  style: TextStyle(fontSize: 18),
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
                Text(
                  data.doctorInCharge.toString(),
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
                  'Diagnostico',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  data.progress.diagnosis,
                  style: TextStyle(fontSize: 18),
                ),
                Divider(),
                Text(
                  'Descripcion',
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
          style: TextStyle(fontSize: 18),
        ),
      );
    }
  }

  Widget _buildDischargeFloatingActionButton(Hospitalization data) {
    final bloc = DatientProvider.of(context).bloc;
    final hospitalizationBloc = DatientProvider.of(context).hospitalizationBloc;
    if (data.leftDate == null) {
      return FloatingActionButton(
        child: Icon(Icons.assignment_turned_in),
        tooltip: 'Dar del alta el paciente',
        onPressed: () {
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
                        'Esta seguro que desea dar de alta al paciente?',
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
                      final hospitalizationBloc =
                          DatientProvider.of(context).hospitalizationBloc;
                      bloc.doctor.listen((value) =>
                          hospitalizationBloc.dischargePatient(
                              data.doctorInCharge,
                              data.bed,
                              data.hospitalizedPatient,
                              value.token));
                      Navigator.of(context).pop();
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
                                    style: TextStyle(fontSize: 18),
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
                      Navigator.of(context).pushReplacement(
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
