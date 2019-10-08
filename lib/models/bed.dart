import 'hospitalization.dart';

class Bed {
  var id;
  var bedName;
  var isAvailable;
  List<Hospitalization> hospitalizations;

  Bed({
    this.id,
    this.bedName,
    this.isAvailable,
    this.hospitalizations
  });

  factory Bed.fromJson(Map<String, dynamic> json) {
    return Bed(
      id: json['id'],
      bedName: json['name'],
      isAvailable: json['is_available'],
    );
  }
}
