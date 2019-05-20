import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as JSON;
import 'package:http/http.dart' as http;

class Token {
  var token;
  Future obtainToken(email, password) async {
    final response = await http.post('http://10.0.2.2:8000/token/',
        headers: {'Content-Type': 'application/json'},
        body: JSON.jsonEncode({'email': email, 'password': password}));

    if (response.statusCode == 200) {
      final responseJson = JSON.jsonDecode(response.body)['token'];
      _setToken(responseJson);
    } else {
      print('error');
    }
  }

  Future<String> _setToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }
  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
