import 'dart:convert' as JSON;
import 'package:datient/models/room.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class RoomBloc {
  final _roomSubject = BehaviorSubject<List<Room>>();
  Stream<List<Room>> get rooms => _roomSubject.stream;

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

  dispose() {
    _roomSubject.close();
    this.dispose();
  }
}
