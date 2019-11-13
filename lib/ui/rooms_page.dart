import 'package:datient/models/doctor.dart';
import 'package:datient/models/room.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/room_page.dart';
import 'package:flutter/material.dart';

class RoomsPage extends StatefulWidget {
  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  var token;
  Doctor doctor = Doctor();
  bool selectAll = true;
  bool selectAvailable = false;
  bool selectFull = false;
  var filteredRoom;
  List<Room> roomList;

  Widget _buildRoomList(data) {
    roomList = data.toList();
    checkRoomIsAvailable(data);
    if (selectAll == true){
      filteredRoom = roomList;
    }
    return Scrollbar(
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(filteredRoom.length, (index) {
          return Container(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RoomPage(
                      room: filteredRoom[index],
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
                      filteredRoom[index].roomName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    filteredRoom[index].isAvailable
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              Text('Disponible')
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              Text('Ocupado')
                            ],
                          )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  checkRoomIsAvailable(List<Room> rooms) {
    rooms.forEach((room) {
      room.beds.forEach((bed) {
        if (bed.isAvailable == true) {
          room.isAvailable = true;
        }
      });
    });
  }

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

  chooseAction(choice) {
    if (choice == 'all') {
      setState(() {
        selectAll = true;
        selectFull = false;
        selectAvailable = false;
        filteredRoom = roomList
            .where(
                (room) => room.isAvailable == true || room.isAvailable == false)
            .toList();
      });
    }
    if (choice == 'available') {
      setState(() {
        selectAvailable = true;
        selectAll = false;
        selectFull = false;
        filteredRoom =
            roomList.where((room) => room.isAvailable == true).toList();
      });
    }
    if (choice == 'full') {
      setState(() {
        selectFull = true;
        selectAll = false;
        selectAvailable = false;
        filteredRoom =
            roomList.where((room) => room.isAvailable == false).toList();
      });
    }
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
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.filter_list),
            onSelected: chooseAction,
            itemBuilder: (_) => [
              CheckedPopupMenuItem(
                checked: selectAll,
                value: 'all',
                child: new Text('Mostrar todo'),
              ),
              CheckedPopupMenuItem(
                checked: selectAvailable,
                value: 'available',
                child: new Text('Mostrar disponibles'),
              ),
              CheckedPopupMenuItem(
                checked: selectFull,
                value: 'full',
                child: new Text('Mostrar ocupadas'),
              ),
            ],
          ),
        ],
      ),
      body: _buildRoomPage(bloc, roomBloc),
    );
  }
}
