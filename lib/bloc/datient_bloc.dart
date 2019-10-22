import 'dart:convert' as JSON;
import 'dart:convert';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/bloc/room_bloc.dart';
import 'package:datient/models/doctor.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatientBloc {
  final _doctorSubject = BehaviorSubject<Doctor>();
  final _doctorSpecificSubject = BehaviorSubject<Doctor>();

  Stream<Doctor> get doctor => _doctorSubject.stream;
  Stream<Doctor> get specificDoctor => _doctorSpecificSubject.stream;

  DatientBloc() {
    _getToken().then((List list) {
      String token = list[0];
      String userId = list[1];
      if (token != null) {
        automaticSignIn(token, userId);
      }
    });
  }

  automaticSignIn(token, userId) async {
    final response = await http.get(
      'http://10.0.2.2:8000/api/doctor/$userId/',
      headers: {'Authorization': 'JWT $token'},
    );

    if (response.statusCode == 200) {
      var json = JSON.jsonDecode(response.body);
      Doctor doctor = Doctor.fromJson(json, token);
      _doctorSubject.sink.add(doctor);
    }
  }

  Future<dynamic> signIn(
    String mail,
    String password,
    RoomBloc roomBloc,
    PatientBloc patientBloc,
  ) async {
    final response = await http.post(
      'http://10.0.2.2:8000/token/',
      headers: {'Content-Type': 'application/json'},
      body: JSON.jsonEncode({'email': mail, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseJson = JSON.jsonDecode(response.body);
      var token = responseJson['token'];
      var user = responseJson['user'];
      var userId = responseJson['user']['id'].toString();
      _saveToken(token, userId);
      Doctor doctor = Doctor.fromJson(user, token);
      _doctorSubject.sink.add(doctor);
      roomBloc.getRooms(token);
      patientBloc.getPatients(token);
      return true;
    } else {
      var responseError = JSON.jsonDecode(utf8.decode(response.bodyBytes));
      return responseError['non_field_errors'][0];
    }
  }

  Future<dynamic> signOut(token) async {
    final response = await http.post(
      'http://10.0.2.2:8000/accounts/logout/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
      body: JSON.jsonEncode({'revoke_token': true}),
    );

    if (response.statusCode == 200) {
      var res = JSON.jsonDecode(response.body);
      _removeToken();
      return res['detail'];
    }
    print(response.body);
    return false;
  }

  Future<dynamic> registerDoctor(
    String registerEmail,
    String registerFirstName,
    String registerLastName,
    int hierarchy,
    String registerPassword,
    String registerPasswordConfirm,
  ) async {
    final response = await http.post(
      'http://10.0.2.2:8000/accounts/register/',
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
    if (response.statusCode == 201) {
      return true;
    } else {
      var responseError = JSON.jsonDecode(utf8.decode(response.bodyBytes));
      return responseError;
    }
  }

  Future<Doctor> getSpecificDoctor(token, id) async {
    Doctor doctor;
    final response = await http.get(
      'http://10.0.2.2:8000/api/doctor/$id',
      headers: {'Authorization': 'JWT $token'},
    );
    if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body);
      doctor = Doctor.fromJson(extractdata, token);
      _doctorSpecificSubject.sink.add(doctor);
    }
    return doctor;
  }

  void _saveToken(String token, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('userId', userId);
  }

  Future<List> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String userId = prefs.getString('userId');
    List list = [token, userId];
    return list;
  }

  void _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userId');
  }

  dispose() {
    _doctorSubject.close();
    _doctorSpecificSubject.close();
    this.dispose();
  }
}
