class Study {
  var image;
  var patient;
  var id;

  Study({this.image, this.patient,this.id});

  factory Study.fromJson(Map<String, dynamic> json) {
    return Study(
      image: json['image'],
      patient: json['patient'],
      id: json['id'],
    );
  }
}