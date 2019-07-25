import 'dart:convert' as JSON;
import 'package:datient/models/hospitalization.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class HospitalizationBloc {
  final _hospitalizationSubject = BehaviorSubject<List<Hospitalization>>();
  Stream<List<Hospitalization>> get hospitalizations =>
      _hospitalizationSubject.stream;

  Future<List> getHospitalization(token) async {
    List list;

    final response = await http.get(
      'http://10.0.2.2:8000/api/hospitalization/',
      headers: {'Authorization': 'JWT $token'},
    );

    if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body) as List;
      list = extractdata.map((json) => Hospitalization.fromJson(json)).toList();
    }

    _hospitalizationSubject.sink.add(list);
    return list;
  }

  dispose() {
    _hospitalizationSubject.close();
    this.dispose();
  }
}
