import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/models/study.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/patient_info_page.dart';
import 'package:flutter/material.dart';

class PatientStudyPage extends StatefulWidget {
  final Patient patient;
  PatientStudyPage({Key key, this.patient}) : super(key: key);

  @override
  _PatientStudyState createState() => _PatientStudyState();
}

class _PatientStudyState extends State<PatientStudyPage> {
  @override
  Widget _buildStudyStream() {
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    return StreamBuilder(
        stream: patientBloc.isloading,
        builder: (context, snapshot) {
          return (snapshot.hasData && snapshot.data)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder(
                  stream: patientBloc.patientStudy,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        snapshot.error,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ));
                    } else {
                      return snapshot.hasData
                          ? _buildPatientStudies(snapshot.data)
                          : Container();
                    }
                  });
        });
  }

  Widget _buildPatientStudies(Patient data) {
    return ListView.builder(
      itemCount: data.studies.length,
      itemBuilder: (BuildContext context, int index) {
        Study studies = data.studies[index];
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Container(
                child: GestureDetector(
                  child: Hero(
                    tag: 'studyHero$index',
                    child: Image.network(studies.image),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return DetailScreen(image: studies.image, index: index);
                    }));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    DatientBloc bloc = DatientProvider.of(context).bloc;
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    bloc.doctor.listen(
        (value) => patientBloc.getStudy(widget.patient.dni, value.token));
    return Scaffold(
      body: Container(
        child: _buildStudyStream(),
      ),
    );
  }
}
