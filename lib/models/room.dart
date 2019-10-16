import 'package:datient/models/bed.dart';

class Room {
  var id;
  var roomName;
  List<Bed> beds;
  bool isAvailable = false;

  Room({this.id, this.roomName, this.beds,});

  factory Room.fromJson(Map<String, dynamic> json) {
    List<Bed> list = [];
    for (final i in json['beds']) {
      Bed bed = Bed.fromJson(i);
      list.add(bed);
    }
    return Room(id: json['id'], roomName: json['name'], beds: list);
  }
}
