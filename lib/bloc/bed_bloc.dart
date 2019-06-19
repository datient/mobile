import 'dart:convert' as JSON;
import 'package:datient/models/bed.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class BedBloc{
  final _bedSubject = BehaviorSubject<List<Bed>>();
  Stream<List<Bed>> get beds => _bedSubject.stream;

    Future<List> getBeds(token) async {
    List list;
    final response = await http.get(
      'http://10.0.2.2:8000/api/room/',
      headers: {'Authorization': 'JWT $token'}, 
    );
    if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body) as List;
      list = extractdata.map((json) => Bed.fromJson(json)).toList();
    }
  _bedSubject.sink.add(list);
  return list;
  }
    dispose() {
    _bedSubject.close();
    this.dispose();
  }
}