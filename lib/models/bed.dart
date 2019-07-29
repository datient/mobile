import 'hospitalization.dart';

class Bed {
  var id;
  var bedName;
  List<Hospitalization> hospitalizations;

  Bed({
    this.id,
    this.bedName,
    this.hospitalizations
  });

  factory Bed.fromJson(Map<String, dynamic> json) {
    return Bed(
      id: json['id'],
      bedName: json['name'],
    );
  }
}
