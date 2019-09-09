import 'dart:convert' as JSON;
import 'dart:io';
import 'package:datient/models/future_plan.dart';
import 'package:datient/models/hospitalization.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/models/study.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart';

class PatientBloc {
  PatientBloc() {
    _isLoading.add(true);
  }
  final _patientSubject = BehaviorSubject<List<Patient>>();
  final _patientSearchSubject = BehaviorSubject<List<Patient>>();
  final _patientSpecificSubject = BehaviorSubject<Patient>();
  final _patientBedSubject = BehaviorSubject<Hospitalization>();
  final _patientStudySubject = BehaviorSubject<Patient>();
  final _patientFuturePlanSubject = BehaviorSubject<Patient>();
  final _isLoading = BehaviorSubject<bool>();
  Stream<List<Patient>> get patients => _patientSubject.stream;
  Stream<List<Patient>> get searchedPatients => _patientSearchSubject.stream;
  Stream<Patient> get specificPatient => _patientSpecificSubject.stream;
  Stream<Hospitalization> get patientBed => _patientBedSubject.stream;
  Stream<bool> get isloading => _isLoading.stream;
  Stream<Patient> get patientStudy => _patientStudySubject.stream;
  Stream<Patient> get patientFuturePlan => _patientFuturePlanSubject.stream;

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

  Future<Patient> getSpecificPatients(token, dni) async {
    Patient patient;
    final response = await http.get(
      'http://10.0.2.2:8000/api/patient/${dni}',
      headers: {'Authorization': 'JWT $token'},
    );
    if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body);
      patient = Patient.fromJson(extractdata);
      _patientSpecificSubject.sink.add(patient);
    } else {
      _patientSpecificSubject.sink.add(null);
    }
    _isLoading.sink.add(false);
    return patient;
  }

  Future<dynamic> createPatient(
      String createFirstName,
      String createLastName,
      int createDni,
      String createBirthDate,
      int createHistoryNumber,
      int createGender,
      String contactNumber,
      String secondContactNumber,
      token) async {
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
          'contact': contactNumber,
          'contact2': secondContactNumber,
        },
      ),
    );
    if (res.statusCode == 201) {
      return true;
    } else {
      print(res.body);
      return false;
    }
  }

  Future<dynamic> editPatient(
      String editFirstName,
      String editLastName,
      int editDni,
      String editBirthDate,
      int editHistoryNumber,
      int editGender,
      editContact,
      editSecondContact,
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
        },
      ),
    );
    if (res.statusCode == 200) {
      return true;
    } else {
      print(res.body);
    }
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

  Future<dynamic> postStudy(File image, patient, token) async {
    Dio dio = Dio();
    FormData formData = new FormData.from(
        {'patient': patient, 'image': UploadFileInfo(image, image.path)});
    final response = await dio.post(
      'http://10.0.2.2:8000/api/study/',
      data: formData,
      options: Options(
        method: 'POST',
        responseType: ResponseType.json,
        headers: {'Authorization': 'JWT $token'},
      ),
    );
    if (response.statusCode == 201) {
      return true;
    }
  }

  Future getFuturePlan(dni, token) async {
    Patient patient;
    final response = await http.get(
      'http://10.0.2.2:8000/api/patient/$dni/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
    );
    final extractdata = JSON.jsonDecode(response.body);
    if (response.statusCode == 200) {
      _isLoading.sink.add(false);
      patient = Patient.fromJson(extractdata);
      _patientFuturePlanSubject.sink.add(patient);
    } else if (response.statusCode == 404) {
      _patientFuturePlanSubject.sink.add(null);
      _isLoading.sink.add(false);
      _patientFuturePlanSubject
          .addError('No se han encontrado planes a futuro');
    }
    _isLoading.sink.add(false);
    return patient;
  }

  Future<dynamic> postFuturePlan(title, description, patientDni, token) async {
    final response = await http.post(
      'http://10.0.2.2:8000/api/plans/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
      body: JSON.jsonEncode(
        {
          'title': title,
          'description': description,
          'patient': patientDni,
        },
      ),
    );
    if (response.statusCode == 201) {
      return true;
    }
  }

  Future getPatientBed(dni, token) async {
    Hospitalization hospitalization;
    final response = await http.get(
        'http://10.0.2.2:8000/api/hospitalization/$dni/patient_filter/',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'JWT $token',
        });
    final extractdata = JSON.jsonDecode(response.body);
    if (response.statusCode == 200) {
      _isLoading.sink.add(false);
      hospitalization = Hospitalization.fromJson(extractdata);
      _patientBedSubject.sink.add(hospitalization);
    } else if (response.statusCode == 404) {
      _patientBedSubject.sink.add(null);
      _isLoading.sink.add(false);
    }
    _isLoading.sink.add(false);
    return hospitalization;
  }

  Future getBedName(bed, token) async {
    final response =
        await http.get('http://10.0.2.2:8000/api/bed/$bed/', headers: {
      'Content-Type': 'application/json',
      'Authorization': 'JWT $token',
    });
    if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body);
      return (extractdata['name']);
    } else {}
  }

  Future getStudy(dni, token) async {
    Patient patient;
    final response =
        await http.get('http://10.0.2.2:8000/api/patient/$dni/', headers: {
      'Content-Type': 'application/json',
      'Authorization': 'JWT $token',
    });
    final extractdata = JSON.jsonDecode(response.body);
    if (response.statusCode == 200) {
      _isLoading.sink.add(false);
      patient = Patient.fromJson(extractdata);
      _patientStudySubject.sink.add(patient);
    } else if (response.statusCode == 404) {
      _patientStudySubject.sink.add(null);
      _isLoading.sink.add(false);
    }
    _isLoading.sink.add(false);
    return patient;
  }

  Future setNull() async {
    _patientSpecificSubject.sink.add(null);
    _isLoading.sink.add(false);
    _patientSpecificSubject.sink.addError('No se han encontrado progresos');
  }

  dispose() {
    _patientSubject.close();
    _patientSearchSubject.close();
    _patientSpecificSubject.close();
    _patientBedSubject.close();
    _isLoading.close();
    _patientStudySubject.close();
    _patientFuturePlanSubject.close();
    this.dispose();
  }
}
