class Progress {
  var diagnosis;
  var description;
  var status;
  var createdAt;
  var hasLeft;

  Progress(
      {this.diagnosis,
      this.description,
      this.status,
      this.createdAt,
      this.hasLeft});

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      diagnosis: json['diagnosis'],
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'],
      hasLeft: json['has_left'],
    );
  }
}
