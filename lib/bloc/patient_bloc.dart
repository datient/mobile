import 'dart:convert' as JSON;
import 'dart:convert';
import 'dart:io';
import 'package:datient/models/bed.dart';
import 'package:datient/models/hospitalization.dart';
import 'package:datient/models/patient.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart';

class PatientBloc {
  PatientBloc() {
    _isLoading.add(true);
    _bedIsLoading.add(true);
  }
  final _patientSubject = BehaviorSubject<List<Patient>>();
  final _patientSearchSubject = BehaviorSubject<List<Patient>>();
  final _patientSpecificSubject = BehaviorSubject<Patient>();
  final _patientBedSubject = BehaviorSubject<Bed>();
  final _patientStudySubject = BehaviorSubject<Patient>();
  final _patientFuturePlanSubject = BehaviorSubject<Patient>();
  final _patientProgressSubject = BehaviorSubject<Patient>();
  final _isLoading = BehaviorSubject<bool>();
  final _bedIsLoading = BehaviorSubject<bool>();
  Stream<List<Patient>> get patients => _patientSubject.stream;
  Stream<List<Patient>> get searchedPatients => _patientSearchSubject.stream;
  Stream<Patient> get specificPatient => _patientSpecificSubject.stream;
  Stream<Bed> get patientBed => _patientBedSubject.stream;
  Stream<bool> get isloading => _isLoading.stream;
  Stream<bool> get bedIsLoading => _bedIsLoading.stream;
  Stream<Patient> get patientStudy => _patientStudySubject.stream;
  Stream<Patient> get patientFuturePlan => _patientFuturePlanSubject.stream;
  Stream<Patient> get patientProgress => _patientProgressSubject.stream;

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

  Future<dynamic> getPatientPdf(dni, token) async {
    final response = await http.get(
      'http://10.0.2.2:8000/pdf/$dni',
      headers: {'Authorization': 'JWT $token'},
    );
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
    }
  }

  Future<Patient> getSpecificPatients(token, dni) async {
    Patient patient;
    final response = await http.get(
      'http://10.0.2.2:8000/api/patient/$dni',
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
    final response = await http.post(
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
    if (response.statusCode == 201) {
      return true;
    } else {
      print(response.body);
      var responseError = JSON.jsonDecode(utf8.decode(response.bodyBytes));
      return responseError;
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
    final response = await http.put(
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
          'contact': editContact,
          'contact2': editSecondContact,
        },
      ),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      var responseError = JSON.jsonDecode(utf8.decode(response.bodyBytes));
      return responseError;
    }
  }

  Future<dynamic> deletePatient(dni, token) async {
    final response = await http.delete(
      'http://10.0.2.2:8000/api/patient/$dni/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      var responseError = JSON.jsonDecode(utf8.decode(response.bodyBytes));
      return responseError['detail'];
    }
  }

  Future getHospitalizedPatient(token, Hospitalization hospitalization) async {
    final response = await http.get(
      'http://10.0.2.2:8000/api/patient/${hospitalization.hospitalizedPatient}/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
    );
    print(response.body);
    return true;
  }

  Future<List> searchPatient(token, dni) async {
    List list = [];
    final response = await http.get(
      'http://10.0.2.2:8000/api/patient/?dni=$dni',
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
    } else {
      return false;
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
      if (patient.futurePlans.isEmpty) {
        _patientFuturePlanSubject
            .addError('No se han encontrado planes a futuro');
      }
    } else if (response.statusCode == 404) {
      _patientFuturePlanSubject.sink.add(null);
      _isLoading.sink.add(false);
      _patientFuturePlanSubject
          .addError('No se han encontrado planes a futuro');
    }
    _isLoading.sink.add(false);
    return patient;
  }

  Future getProgress(dni, token) async {
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
      _patientProgressSubject.sink.add(patient);
      if (patient.patientProgress.isEmpty) {
        _patientProgressSubject.addError('No se han encontrado progresos');
      }
    } else if (response.statusCode == 404) {
      _patientProgressSubject.sink.add(null);
      _isLoading.sink.add(false);
      _patientFuturePlanSubject.addError('No se han encontrado progresos');
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
    } else {
      var responseError = JSON.jsonDecode(utf8.decode(response.bodyBytes));
      return responseError['detail'];
    }
  }

  Future<dynamic> deleteFuturePlan(id, token) async {
    final response = await http.delete(
      'http://10.0.2.2:8000/api/plans/$id/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      var responseError = JSON.jsonDecode(utf8.decode(response.bodyBytes));
      return responseError['detail'];
    }
  }

  Future<dynamic> editFuturePlan(id, title, description, patient, token) async {
    final response = await http.put('http://10.0.2.2:8000/api/plans/$id/',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'JWT $token',
        },
        body: JSON.jsonEncode({
          'title': title,
          'description': description,
          'patient': patient,
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      var responseError = JSON.jsonDecode(utf8.decode(response.bodyBytes));
      return responseError['detail'];
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
    final extractdata = JSON.jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      hospitalization = Hospitalization.fromJson(extractdata);
      _bedIsLoading.sink.add(false);
      // _patientBedSubject.sink.add(hospitalization);
      return getBedName(hospitalization.bed, token);
    } else if (response.statusCode == 404) {
      _patientBedSubject.sink.add(null);
      _bedIsLoading.sink.add(false);
      _patientBedSubject.sink.addError('Ninguna cama asignada');
    }
    _bedIsLoading.sink.add(false);
    return hospitalization;
  }

  Future getBedName(bedNumber, token) async {
    Bed bed;
    final response =
        await http.get('http://10.0.2.2:8000/api/bed/$bedNumber/', headers: {
      'Content-Type': 'application/json',
      'Authorization': 'JWT $token',
    });
    if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body);
      bed = Bed.fromJson(extractdata);
      _patientBedSubject.sink.add(bed);
    } else {
      print(response.body);
    }
    return bed;
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
      if (patient.studies.isEmpty) {
        _patientStudySubject.addError('No se han encontrado estudios');
      }
    } else if (response.statusCode == 404) {
      _patientStudySubject.sink.add(null);
      _isLoading.sink.add(false);
    }
    _isLoading.sink.add(false);
    return patient;
  }

  Future<dynamic> deleteStudy(id, token) async {
    final response = await http.delete(
      'http://10.0.2.2:8000/api/study/$id/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      var responseError = JSON.jsonDecode(utf8.decode(response.bodyBytes));
      return responseError['detail'];
    }
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
    _bedIsLoading.close();
    this.dispose();
  }
}
