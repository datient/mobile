class Room {
  var id;
  var roomName;

  Room({
    this.id,
    this.roomName,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      roomName: json['name'],
    );
  }
}
