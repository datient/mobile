import 'package:datient/models/bed.dart';
import 'package:datient/models/doctor.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/room_page.dart';
import 'package:flutter/material.dart';

class RoomsPage extends StatefulWidget {
  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  bool bedIsAvailable;
  var token;
  Doctor doctor = Doctor();

  // void initState() {
  //   super.initState();
  //   setState(() {
  //     bedIsAvailable = false;
  //   });
  // }

  Widget _buildRoomList(data) {
    return Scrollbar(
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(data.length, (index) {
          // checkBedsAvailable(data[index].beds);
          return Container(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RoomPage(
                      room: data[index],
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_hospital,
                      size: 80,
                    ),
                    Text(
                      data[index].roomName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    // _buildBedIsAvailable()
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Future checkBedsAvailable(List<Bed> beds) async {
  //   for (int i = 0; i < beds.length; i++) {
  //     if (beds[i].isAvailable == true) {
  //       bedIsAvailable = true;
  //     } else {
  //       bedIsAvailable = false;
  //       print('${beds[i].bedName}: $bedIsAvailable');
  //     }
  //   }
  // }

  // Widget _buildBedIsAvailable() {
  //   return bedIsAvailable ? Text('Available') : Text('Full');
  // }

  Widget _buildRoomPage(bloc, roomBloc) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: bloc.doctor,
              builder: (context, snap) {
                return snap.hasData
                    ? StreamBuilder(
                        stream: roomBloc.rooms,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return snapshot.hasData
                              ? _buildRoomList(snapshot.data)
                              : Center(child: CircularProgressIndicator());
                        },
                      )
                    : Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = DatientProvider.of(context).bloc;
    final roomBloc = DatientProvider.of(context).roomBloc;
    bloc.doctor.listen((value) => roomBloc.getRooms(value.token));

    return Scaffold(
      appBar: AppBar(
        title: Text('Salas'),
        leading: IconButton(
          icon: Icon(
            Icons.account_circle,
            size: 35,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: _buildRoomPage(bloc, roomBloc),
    );
  }
}
