import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:shared_preferences/shared_preferences.dart';

class Doctor {
  var firstName;
  var lastName;
  var token;

  Future<bool> obtainToken(email, password) async {
    final response = await http.post(
      'http://10.0.2.2:8000/token/',
      headers: {'Content-Type': 'application/json'},
      body: JSON.jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseJson = JSON.jsonDecode(response.body);
      var user = responseJson['user'];
      var token = responseJson['token'];
      _setToken(token);
      _setDoctor(user);
    } else {
      print('error');
      return false;
    }
    return true;
  }

  void _setToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    this.token = token;
  }

  void _setDoctor(user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('first_name', user['first_name']);
    prefs.setString('last_name', user['last_name']);
    this.firstName = user['first_name'];
    this.lastName = user['last_name'];
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String> getDoctor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = prefs.getString('first_name');
    var lastname = prefs.getString('last_name');
    return (name + ', ' + lastname);
  }
}
