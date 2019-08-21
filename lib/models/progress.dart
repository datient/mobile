class Progress {
  var diagnosis;
  var description;
  var status;
  var createdAt;

  Progress({this.diagnosis, this.description, this.status, this.createdAt});

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      diagnosis: json['diagnosis'],
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
}
