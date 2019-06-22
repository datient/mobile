import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/room_bloc.dart';
import 'package:datient/models/bed.dart';
import 'package:datient/models/room.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/bed_page.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Sala ${widget.room.id}'),
      ),
      body: ListView.builder(
          itemCount: widget.room.beds.length,
          itemBuilder: (BuildContext context, int index) {
            Bed beds = widget.room.beds[index];
            return Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BedPage(
                            bed: widget.room.beds[index],
                          ),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        beds.bedName,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
