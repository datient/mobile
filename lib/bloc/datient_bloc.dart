import 'dart:convert' as JSON;
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/bloc/room_bloc.dart';
import 'package:datient/models/doctor.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class DatientBloc {
  final _doctorSubject = BehaviorSubject<Doctor>();

  Stream<Doctor> get doctor => _doctorSubject.stream;

  Future<bool> signIn(String mail, String password, RoomBloc roomBloc,
      PatientBloc patientBloc) async {
    Doctor doctor = Doctor();

    final response = await http.post(
      'http://159.65.222.187:8000/token/',
      headers: {'Content-Type': 'application/json'},
      body: JSON.jsonEncode({'email': mail, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseJson = JSON.jsonDecode(response.body);
      var token = responseJson['token'];
      var user = responseJson['user'];
      doctor.setUser(token, user);
      _doctorSubject.sink.add(doctor);
      roomBloc.getRooms(token);
      patientBloc.getPatients(token);
      return true;
    } else {
      var responseError = JSON.jsonDecode(response.body);
      print(responseError['non_field_errors']);
      return false;
    }
  }

  Future<bool> signOut(token) async {
    print(token);
    final response = await http.post(
      'http://159.65.222.187:8000/accounts/logout/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
      body: JSON.jsonEncode({'revoke_token': true}),
    );
    if (response.statusCode == 200){
      print(response.body);
      return true;
    }else{
      return false;
    }
  }

  Future<bool> registerDoctor(
    String registerEmail,
    String registerFirstName,
    String registerLastName,
    int hierarchy,
    String registerPassword,
    String registerPasswordConfirm,
  ) async {
    final res = await http.post(
      'http://159.65.222.187:8000/accounts/register/',
      headers: {'Content-Type': 'application/json'},
      body: JSON.jsonEncode(
        {
          'email': registerEmail,
          'first_name': registerFirstName,
          'last_name': registerLastName,
          'hierarchy': hierarchy,
          'password': registerPassword,
          'password_confirm': registerPasswordConfirm
        },
      ),
    );
    print(res.body);
    return true;
  }

  dispose() {
    _doctorSubject.close();
    this.dispose();
  }
}
