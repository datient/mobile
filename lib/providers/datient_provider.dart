import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/room_bloc.dart';
import 'package:flutter/material.dart';

class DatientProvider extends InheritedWidget {
  final DatientBloc bloc;
  final RoomBloc roomBloc;

  DatientProvider({this.bloc,this.roomBloc, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static DatientProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(DatientProvider);
}
