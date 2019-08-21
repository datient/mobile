import 'package:datient/models/progress.dart';
import 'package:datient/models/study.dart';
import 'future_plan.dart';

class Patient {
  var dni;
  var age;
  var firstName;
  var lastName;
  var birthDate;
  var historyNumber;
  var gender;
  var incomeDiagnostic;
  var createdDate;
  var updatedDate;
  List<Study> studies;
  List<FuturePlan> futurePlans;
  var contact;
  var secondContact;
  List<Progress> patientProgress;

  Patient({
    this.dni,
    this.age,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.historyNumber,
    this.gender,
    this.incomeDiagnostic,
    this.createdDate,
    this.updatedDate,
    this.studies,
    this.contact,
    this.secondContact,
    this.futurePlans,
    this.patientProgress,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    List<Study> list = [];
    List<FuturePlan> plans = [];
    List<Progress> progresses = [];
    for (final i in json['studies']) {
      Study study = Study.fromJson(i);
      list.add(study);
    }
    for (final i in json['plans']) {
      FuturePlan plan = FuturePlan.fromJson(i);
      plans.add(plan);
    }
    for (final i in json['progress']) {
      Progress progress = Progress.fromJson(i);
      progresses.add(progress);
    }
    return Patient(
      dni: json['dni'],
      age: json['age'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      birthDate: json['birth_date'],
      historyNumber: json['history_number'],
      gender: json['gender'],
      incomeDiagnostic: json['income_diagnosis'],
      createdDate: json['created_at'],
      updatedDate: json['updated_at'],
      studies: list,
      contact: json['contact'],
      secondContact: json['contact2'],
      futurePlans: plans,
    );
  }
}
