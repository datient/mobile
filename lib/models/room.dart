import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as JSON;

class Room {
  var id;
  var roomName;

  Future getRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _token = prefs.getString('token');
    print(_token);
    final response = await http.get(
      'http://10.0.2.2:8000/api/room/',
      headers: {'Authorization': 'JWT $_token'},
    );
    var extractdata = JSON.jsonDecode(response.body);
    return extractdata;
  }
}