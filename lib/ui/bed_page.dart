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
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.bed.bedName}'),
      ),
      body: ListView.builder(
          itemCount: widget.bed.hospitalizations.length,
          itemBuilder: (BuildContext context, int index) {
            Hospitalization hospitalizations =
                widget.bed.hospitalizations[index];
            return Container(
              child: Card(
                elevation: 6,
                child: Column(
                  children: [
                    Text('Hospitalizacion',
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                    Divider(),
                    Text('Paciente internado',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                    Text(hospitalizations.hospitalizedPatient.toString()),
                    Divider(),
                    Text('Fecha de ingreso',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                    Divider(),
                    Text(hospitalizations.entryDate),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
