class Hospitalization {
  var entryDate;
  var leftDate;
  var bed;
  var doctorInCharge;
  var hospitalizedPatient;

  Hospitalization({
    this.entryDate,
    this.leftDate,
    this.bed,
    this.doctorInCharge,
    this.hospitalizedPatient,
  });
  factory Hospitalization.fromJson(Map<String, dynamic> json) {
    return Hospitalization(
      entryDate: json['entry_at'],
      leftDate: json['left_at'],
      bed: json['bed'],
      doctorInCharge: json['doctor'],
      hospitalizedPatient: json['patient'],
    );
  }
}
