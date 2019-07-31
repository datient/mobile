class Progress {
  var diagnosis;
  var description;
  var status;

  Progress({this.diagnosis, this.description, this.status});

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      diagnosis: json['diagnosis'],
      description: json['description'],
      status: json['status'],
    );
  }
}
