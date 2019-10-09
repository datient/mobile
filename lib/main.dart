import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/hospitalization_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/bloc/room_bloc.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/add_patient_page.dart';
import 'package:datient/ui/assign_patient_page.dart';
import 'package:datient/ui/bed_page.dart';
import 'package:datient/ui/edit_patient_page.dart';
import 'package:datient/ui/home_page.dart';
import 'package:datient/ui/login_page.dart';
import 'package:datient/ui/patient_page.dart';
import 'package:datient/ui/room_page.dart';
import 'package:datient/ui/add_hospitalization_page.dart';
import 'package:datient/ui/statistics_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DatientProvider(
      bloc: DatientBloc(),
      roomBloc: RoomBloc(),
      patientBloc: PatientBloc(),
      hospitalizationBloc: HospitalizationBloc(),
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('es'),
        ],
        title: 'Datient',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Datient(),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => LoginPage(),
          '/home': (BuildContext context) => HomePage(),
          '/room': (BuildContext context) => RoomPage(),
          '/bed': (BuildContext context) => BedPage(),
          '/patient': (BuildContext context) => PatientPage(),
          '/patientadd': (BuildContext context) => PatientAddPage(),
          '/patientedit': (BuildContext context) => PatientEditPage(),
          '/patientassign': (BuildContext context) => PatientAssignPage(),
          '/hospitalizationadd': (BuildContext context) =>
              HospitalizationAddPage(),
          '/statistics': (BuildContext context) => StatisticsPage(),
        },
      ),
    );
  }
}

class Datient extends StatefulWidget {
  @override
  _DatientState createState() => _DatientState();
}

class _DatientState extends State<Datient> {
  @override
  Widget build(BuildContext context) {
    final bloc = DatientProvider.of(context).bloc;
    final roomBloc = DatientProvider.of(context).roomBloc;
    final patient = DatientProvider.of(context).patientBloc;

    return StreamBuilder(
      stream: bloc.doctor,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data.token != null) {
          String token = snapshot.data.token;
          roomBloc.getRooms(token);
          patient.getPatients(token);
          return HomePage();
        }
        return LoginPage();
      },
    );
  }
}
