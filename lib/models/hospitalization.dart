
class Hospitalization {
  var entryDate;
  var leftDate;
  var bed;
  var doctorInCharge;
  var hospitalizedPatient;
  var boardingDays;

  Hospitalization({
    this.entryDate,
    this.leftDate,
    this.bed,
    this.doctorInCharge,
    this.hospitalizedPatient,
    this.boardingDays,
  });
  factory Hospitalization.fromJson(Map<String, dynamic> json) {
    return Hospitalization(
      entryDate: json['entry_at'],
      leftDate: json['left_at'],
      bed: json['bed'],
      doctorInCharge: json['doctor'],
      hospitalizedPatient: json['patient'],
      boardingDays: json['boarding_days'],
    );
  }
}
