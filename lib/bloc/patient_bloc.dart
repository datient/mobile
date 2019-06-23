import 'dart:convert' as JSON;
import 'package:datient/models/patient.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class PatientBloc{
  final _patientSubject = BehaviorSubject<List<Patient>>();
  Stream<List<Patient>> get patients => _patientSubject.stream;

    Future<List> getPatients(token) async {
    List list;
    final response = await http.get(
      'http://10.0.2.2:8000/api/patient/',
      headers: {'Authorization': 'JWT $token'}, 
    );
    if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body) as List;
      list = extractdata.map((json) => Patient.fromJson(json)).toList();
    }
  _patientSubject.sink.add(list);
  return list;
  }
    dispose() {
    _patientSubject.close();
    this.dispose();
  }
}