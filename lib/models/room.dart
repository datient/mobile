import 'bed.dart';

class Room {
  var id;
  var roomName;
  List<dynamic> beds;

  Room({
    this.id,
    this.roomName,
    this.beds
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    List<dynamic> list;
    for (final i in json['beds']){
      Bed bed = Bed.fromJson(i);
      list.add(bed);
      print(list);
    }
    return Room(
      id: json['id'],
      roomName: json['name'],
      beds: list,
    );
  }
}
