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
  Widget _buildIsAvailable(Bed bed) {
    return bed.isAvailable
        ? Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              Text('Disponible')
            ],
          )
        : Row(
            children: [
              Icon(
                Icons.cancel,
                color: Colors.red,
              ),
              Text('Ocupado')
            ],
          );
  }

  Widget _buildRoomStream() {
    RoomBloc roomBloc = DatientProvider.of(context).roomBloc;
    return StreamBuilder(
        stream: roomBloc.isLoading,
        builder: (context, snapshot) {
          return (snapshot.hasData && snapshot.data)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder(
                  stream: roomBloc.specificRoom,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        snapshot.error,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ));
                    } else {
                      return snapshot.hasData
                          ? _buildRoom(snapshot.data)
                          : Container();
                    }
                  });
        });
  }

  Widget _buildRoom(Room data) {
    return ListView.builder(
      itemCount: data.beds.length,
      itemBuilder: (BuildContext context, int index) {
        Bed beds = data.beds[index];

        return Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Container(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BedPage(
                      bed: data.beds[index],
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.hotel),
                          SizedBox(width: 20),
                          Text(
                            beds.bedName,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Spacer(),
                      _buildIsAvailable(beds),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    final bloc = DatientProvider.of(context).bloc;
    RoomBloc roomBloc = DatientProvider.of(context).roomBloc;
    bloc.doctor.listen(
        (value) => roomBloc.getSpecificRoom(widget.room.id, value.token));
    return Scaffold(
      appBar: AppBar(
        title: Text('Sala ${widget.room.id}'),
      ),
      body: Container(child: _buildRoomStream()),
    );
  }
}
