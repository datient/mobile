class Patient {
  var dni;
  var age;
  var firstName;
  var lastName;
  var birthDate;
  var historyNumber;
  var gender;
  var incomeDiagnostic;

  Patient({
    this.dni,
    this.age,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.historyNumber,
    this.gender,
    this.incomeDiagnostic,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      dni: json['dni'],
      age: json['age'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      birthDate: json['birth_date'],
      historyNumber: json['history_number'],
      gender: json['gender'],
      incomeDiagnostic: json['income_diagnosis']
    );
  }
}
