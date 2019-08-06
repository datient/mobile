import 'package:datient/models/progress.dart';

class Hospitalization {
  var entryDate;
  var leftDate;
  var bed;
  var doctorInCharge;
  var hospitalizedPatient;
  var boardingDays;
  Progress progress;

  Hospitalization({
    this.entryDate,
    this.leftDate,
    this.bed,
    this.doctorInCharge,
    this.hospitalizedPatient,
    this.boardingDays,
    this.progress,
  });
  factory Hospitalization.fromJson(Map<String, dynamic> json) {
    Progress progress = Progress.fromJson(json['progress']);
    return Hospitalization(
      entryDate: json['entry_at'],
      leftDate: json['left_at'],
      bed: json['bed'],
      doctorInCharge: json['doctor'],
      hospitalizedPatient: json['patient'],
      boardingDays: json['boarding_days'],
      progress: progress,
    );
  }
}