import 'dart:convert' as JSON;
import 'package:datient/models/doctor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class DatientBloc {
  final _doctorSubject = BehaviorSubject<Doctor>();

  Stream<Doctor> get doctor => _doctorSubject.stream;

  Future<bool> signIn(String mail, String password) async {
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
      _doctorSubject.sink.add(doctor);
      return true;
    } else {
      var responseError = JSON.jsonDecode(response.body);
      print(responseError['non_field_errors']);
      return false;
    }
  }

  Future<Null> registerDoctor(
      String registerEmail,
      String firstName,
      String lastName,
      int hierarchy,
      String password,
      String passwordConfirm) async {
    Doctor doctor = Doctor();

    final res = await http.post(
      'http://10.0.2.2:8000/accounts/register',
      headers: {'Content-Type': 'application/json'},
      body: JSON.jsonEncode(
        {
          'email': registerEmail,
          'first_name': firstName,
          'last_name': lastName,
          'hierarchy': hierarchy,
          'password': password,
          'password_confirm': passwordConfirm
        },
      ),
    );
  }

  dispose() {
    _doctorSubject.close();
    this.dispose();
  }
}
