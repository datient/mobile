import 'dart:convert' as JSON;
import 'package:datient/models/patient.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class PatientBloc {
  final _patientSubject = BehaviorSubject<List<Patient>>();
  Stream<List<Patient>> get patients => _patientSubject.stream;

  Future<List> getPatients(token) async {
    List list;
    final response = await http.get(
      'http://10.0.2.2:8000/api/patient/',
      headers: {'Authorization': 'JWT $token'},
    );

    if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body) as List;
      list = extractdata.map((json) => Patient.fromJson(json)).toList();
    }
    _patientSubject.sink.add(list);
    return list;
  }

  dispose() {
    _patientSubject.close();
    this.dispose();
  }

  Future createPatient(
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
    print(res.body);
    return true;
  }

    Future editPatient(
      String registerFirstName,
      String registerLastName,
      int registerDni,
      String registerBirthDate,
      int registerHistoryNumber,
      int registerGender,
      String registerIncomeDiagnosis,
      token,Patient patient) async {
    final res = await http.put(
      'http://10.0.2.2:8000/api/patient/${patient.dni}',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
      body: JSON.jsonEncode(
        {
          'dni': registerDni,
          'first_name': registerFirstName,
          'last_name': registerLastName,
          'birth_date': registerBirthDate,
          'history_number': registerHistoryNumber,
          'gender': registerGender,
          'income_diagnosis': registerIncomeDiagnosis
        },
      ),
    );
    print(res.body);
    return true;
  }
}
