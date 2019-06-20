class Bed {
  var id;
  var bedName;

  Bed({
    this.id,
    this.bedName,
  });

  factory Bed.fromJson(Map<String, dynamic> json) {
    return Bed(
      id: json['id'],
      bedName: json['name'],
    );
  }
}
