import 'package:datient/bloc/room_bloc.dart';
import 'package:datient/models/room.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';

class RoomPage extends StatefulWidget {
  final Room room;

  RoomPage({Key key, this.room}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  @override
  Widget build(BuildContext context) {
    RoomBloc roomBloc = DatientProvider.of(context).roomBloc;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sala ${widget.room.id}'),
      ),
      body: Container(
        child: Column(
          children: [
            Text(widget.room.roomName),
          ],
        ),
      ),
    );
  }
}
