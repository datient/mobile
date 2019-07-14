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
    List<Hospitalization> list = [];
    for (final i in json['hospitalizations']) {
      Hospitalization hospitalization = Hospitalization.fromJson(i);
      list.add(hospitalization);
    }
    return Bed(
      id: json['id'],
      bedName: json['name'],
      hospitalizations :list,
    );
  }
}
