import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/room_bloc.dart';
import 'package:flutter/material.dart';

class DatientProvider extends InheritedWidget {
  final DatientBloc bloc;
  final RoomBloc roomBloc;
  final PatientBloc patientBloc;

  DatientProvider({this.bloc,this.roomBloc,this.patientBloc, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static DatientProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(DatientProvider);
}
