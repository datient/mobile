import 'package:datient/models/bed.dart';
import 'package:datient/models/room.dart';
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
                elevation: 6,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Icon(Icons.hotel),
                    Text(
                      beds.bedName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
