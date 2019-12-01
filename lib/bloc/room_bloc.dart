import 'dart:convert' as JSON;
import 'package:datient/models/room.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class RoomBloc {
  final _roomSubject = BehaviorSubject<List<Room>>();
  final _specificRoomSubject = BehaviorSubject<Room>();
  final _isLoading = BehaviorSubject<bool>();
  Stream<List<Room>> get rooms => _roomSubject.stream;
  Stream<Room> get specificRoom => _specificRoomSubject.stream;
  Stream<bool> get isLoading => _isLoading.stream;

  Future<List> getRooms(token) async {
    List list;

    final response = await http.get(
      'http://159.65.222.187:8000/api/room/',
      headers: {'Authorization': 'JWT $token'},
    );

    if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body) as List;
      list = extractdata.map((json) => Room.fromJson(json)).toList();
      _roomSubject.sink.add(list);
    }
    return list;
  }

  Future<Room> getSpecificRoom(id, token) async {
    Room room;
    final response = await http.get(
      'http://159.65.222.187:8000/api/room/$id/',
      headers: {'Authorization': 'JWT $token'},
    );
    if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body);
      room = Room.fromJson(extractdata);
      _specificRoomSubject.sink.add(room);
    } else {
      _specificRoomSubject.sink.add(null);
    }
    _isLoading.sink.add(false);
    return room;
  }

  dispose() {
    _roomSubject.close();
    _specificRoomSubject.close();
    _isLoading.close();
    this.dispose();
  }
}
