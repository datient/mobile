import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/future_plan.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';

class PatientFuturePlanPage extends StatefulWidget {
  final Patient patient;
  PatientFuturePlanPage({Key key, this.patient}) : super(key: key);

  @override
  _PatientFuturePlanState createState() => _PatientFuturePlanState();
}

class _PatientFuturePlanState extends State<PatientFuturePlanPage> {
  @override
  Widget _buildFuturePlanStream() {
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    return StreamBuilder(
        stream: patientBloc.isloading,
        builder: (context, snapshot) {
          return (snapshot.hasData && snapshot.data)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder(
                  stream: patientBloc.patientFuturePlan,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        snapshot.error,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ));
                    } else {
                      return snapshot.hasData
                          ? _buildFuturePlan(snapshot.data)
                          : Container();
                    }
                  });
        });
  }

  Widget _buildFuturePlan(Patient data) {
    return ListView.builder(
      itemCount: data.futurePlans.length,
      itemBuilder: (BuildContext context, int index) {
        FuturePlan plans = data.futurePlans[index];
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        plans.title,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(),
                  Text(plans.description),
                ],
              ),
            ),
          )),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    DatientBloc bloc = DatientProvider.of(context).bloc;
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    bloc.doctor.listen(
        (value) => patientBloc.getFuturePlan(widget.patient.dni, value.token));
    return Scaffold(
        body: Container(
      child: _buildFuturePlanStream()),
    );
  }
}
