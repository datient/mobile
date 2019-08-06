import 'dart:convert' as JSON;
import 'package:datient/models/hospitalization.dart';
import 'package:datient/models/patient.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class PatientBloc {
  final _patientSubject = BehaviorSubject<List<Patient>>();
  final _patientSearchSubject = BehaviorSubject<List<Patient>>();
  final _patientSpecificSubject = BehaviorSubject<Patient>();
  Stream<List<Patient>> get patients => _patientSubject.stream;
  Stream<List<Patient>> get searchedPatients => _patientSearchSubject.stream;
  Stream<Patient> get specificPatient => _patientSpecificSubject.stream;

  Future<List> getPatients(token) async {
    List list = [];
    final response = await http.get(
      'http://10.0.2.2:8000/api/patient/',
      headers: {'Authorization': 'JWT $token'},
    );

    if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body) as List;
      list = extractdata.map((json) => Patient.fromJson(json)).toList();
      _patientSubject.sink.add(list);
    }
    return list;
  }

    Future <Patient>getSpecificPatients(token,dni) async {
      Patient patient;
    final response = await http.get(
      'http://10.0.2.2:8000/api/patient/${dni}',
      headers: {'Authorization': 'JWT $token'},
    );
        if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body);
      patient = Patient.fromJson(extractdata);
      _patientSpecificSubject.sink.add(patient);
    }
    return patient;
    }

  Future<bool> createPatient(
      String createFirstName,
      String createLastName,
      int createDni,
      String createBirthDate,
      int createHistoryNumber,
      int createGender,
      String createIncomeDiagnosis,
      token) async {
    print(token);
    final res = await http.post(
      'http://10.0.2.2:8000/api/patient/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
      body: JSON.jsonEncode(
        {
          'dni': createDni,
          'first_name': createFirstName,
          'last_name': createLastName,
          'birth_date': createBirthDate,
          'history_number': createHistoryNumber,
          'gender': createGender,
          'income_diagnosis': createIncomeDiagnosis
        },
      ),
    );
    if (res.statusCode == 200) {
      print(res.body);
      return true;
    } else {
      return false;
    }
  }

  Future editPatient(
      String editFirstName,
      String editLastName,
      int editDni,
      String editBirthDate,
      int editHistoryNumber,
      int editGender,
      String editIncomeDiagnosis,
      token,
      Patient patient) async {
    final res = await http.put(
      'http://10.0.2.2:8000/api/patient/${patient.dni}/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
      body: JSON.jsonEncode(
        {
          'dni': editDni,
          'first_name': editFirstName,
          'last_name': editLastName,
          'birth_date': editBirthDate,
          'history_number': editHistoryNumber,
          'gender': editGender,
          'income_diagnosis': editIncomeDiagnosis
        },
      ),
    );
    print(res.body);
    return true;
  }

  Future getHospitalizedPatient(token, Hospitalization hospitalization) async {
    final res = await http.get(
      'http://10.0.2.2:8000/api/patient/${hospitalization.hospitalizedPatient}/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
    );
    print(res.body);
    return true;
  }

  Future<List> searchPatient(token, dni) async {
    List list = [];
    final response = await http.get(
      'http://10.0.2.2:8000/api/patient/?dni=${dni}',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
    );
    if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body) as List;
      list = extractdata.map((json) => Patient.fromJson(json)).toList();
      _patientSearchSubject.sink.add(list);
    }
    return list;
  }

  dispose() {
    _patientSubject.close();
    _patientSearchSubject.close();
    _patientSpecificSubject.close();
    this.dispose();
  }
}
