import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Room{
  var id;
  var room_name;

  Future <String> _setRoom(id,room_name){
    
  }
  Future <String> getRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _token = prefs.getString('token');
    final response = await http.get('http://10.0.2.2:8000/api/room/',
    headers: {'Authorization':'JWT $_token'}
    ).then((res){
      print(res.body);
    });
  }
}