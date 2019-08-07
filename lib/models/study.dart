class Study {
  var image;
  var patient;

  Study({this.image, this.patient});

  factory Study.fromJson(Map<String, dynamic> json) {
    return Study(
      image: json['image'],
      patient: json['patient'],
    );
  }
}