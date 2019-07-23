import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/room_bloc.dart';
import 'package:datient/models/bed.dart';
import 'package:datient/models/hospitalization.dart';
import 'package:datient/models/room.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';

class BedPage extends StatefulWidget {
  final Bed bed;
  BedPage({Key key, this.bed}) : super(key: key);

  @override
  _BedPageState createState() => _BedPageState();
}

class _BedPageState extends State<BedPage> {
  @override
  Widget build(BuildContext context) {
    var _hospitalizations = widget.bed.hospitalizations;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.bed.bedName}'),
      ),
      body: _hospitalizations.isNotEmpty
          ? ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                Hospitalization hospitalizations = _hospitalizations.last;
                return Container(
                  child: Card(
                    margin: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 6,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hospitalizacion',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Divider(),
                          Text('Paciente internado',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)),
                          Text(
                            hospitalizations.hospitalizedPatient.toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                          Divider(),
                          Text('Fecha de ingreso',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)),
                          Text(hospitalizations.entryDate,
                              style: TextStyle(fontSize: 18)),
                          Divider(),
                          Text('Atendido por',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)),
                          Text(hospitalizations.doctorInCharge.toString(),
                              style: TextStyle(fontSize: 18)),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                );
              })
          : Center(
              child: Text('No se han encontrado hospitalizaciones'),
            ),
      floatingActionButton: _hospitalizations.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.assignment_turned_in),
            )
          : FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
            ),
    );
  }
}
