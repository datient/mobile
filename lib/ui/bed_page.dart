import 'package:datient/models/bed.dart';
import 'package:datient/models/hospitalization.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';

class BedPage extends StatefulWidget {
  final Bed bed;

  BedPage({Key key, this.bed}) : super(key: key);

  @override
  _BedPageState createState() => _BedPageState();
}

class _BedPageState extends State<BedPage> {
  Widget _buildHospitalization(List data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        Hospitalization hospitalizations = data[index];

        return Container(
          child: Card(
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
                    hospitalizations.hospitalizedPatient.toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                  Divider(),
                  Text(
                    'Fecha de ingreso',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    hospitalizations.entryDate,
                    style: TextStyle(fontSize: 18),
                  ),
                  Divider(),
                  Text(
                    'Atendido por',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    hospitalizations.doctorInCharge.toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    final bloc = DatientProvider.of(context).bloc;
    final hospitalizationBloc = DatientProvider.of(context).hospitalizationBloc;
    bloc.doctor
        .listen((value) => hospitalizationBloc.getHospitalization(value.token));

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.bed.bedName}'),
      ),
      body: StreamBuilder(
        stream: hospitalizationBloc.hospitalizations,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _buildHospitalization(snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
