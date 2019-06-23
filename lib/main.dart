import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/bloc/room_bloc.dart';
import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/bed_page.dart';
import 'package:datient/ui/home_page.dart';
import 'package:datient/ui/login_page.dart';
import 'package:datient/ui/patient_page.dart';
import 'package:datient/ui/room_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DatientProvider(
      bloc: DatientBloc(),
      roomBloc: RoomBloc(),
      patientBloc: PatientBloc(),
      child: MaterialApp(
        title: 'Datient',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(title: 'Login'),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => LoginPage(),
          '/home': (BuildContext context) => HomePage(),
          '/room': (BuildContext context) => RoomPage(),
          '/bed': (BuildContext context) => BedPage(),
          '/patient': (BuildContext context) => PatientPage(),
        },
      ),
    );
  }
}
