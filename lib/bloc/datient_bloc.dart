import 'dart:convert' as JSON;
import 'package:datient/models/doctor.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class DatientBloc {
  final _doctorSubject = BehaviorSubject<Doctor>();

  Stream<Doctor> get doctor => _doctorSubject.stream;

  Future<Null> signIn(String mail, String password) async {
    Doctor doctor = Doctor();

    final response = await http.post(
      'http://10.0.2.2:8000/token/',
      headers: {'Content-Type': 'application/json'},
      body: JSON.jsonEncode({'email': mail, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseJson = JSON.jsonDecode(response.body);
      var token = responseJson['token'];
      var user = responseJson['user'];
      doctor.setUser(token, user);
    }

    _doctorSubject.sink.add(doctor);
  }

  dispose() {
    _doctorSubject.close();
    this.dispose();
  }
}
