import 'dart:convert' as JSON;
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/hospitalization.dart';
import 'package:datient/models/progress.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class HospitalizationBloc {
  final _hospitalizationSubject = BehaviorSubject<Hospitalization>();
  final _hospitalizationErrorSubject = BehaviorSubject<String>();
  final _hospitalizationIsLoading = BehaviorSubject<bool>();

  HospitalizationBloc() {
    _hospitalizationIsLoading.add(true);
  }

  Stream<Hospitalization> get hospitalizations =>
      _hospitalizationSubject.stream;
  Stream<String> get error => _hospitalizationErrorSubject.stream;
  Stream<bool> get isloading => _hospitalizationIsLoading.stream;

  Future<Hospitalization> getHospitalization(
      token, int bedId, PatientBloc patientBloc) async {
    _hospitalizationIsLoading.add(true);
    Hospitalization hospitalization;

    final response = await http.get(
      'http://10.0.2.2:8000/api/hospitalization/$bedId/bed_filter/',
      headers: {'Authorization': 'JWT $token'},
    );

    if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body);
      hospitalization = Hospitalization.fromJson(extractdata);
      _hospitalizationSubject.sink.add(hospitalization);
      _hospitalizationErrorSubject.sink.add(null);
      _hospitalizationIsLoading.add(false);
      patientBloc.getSpecificPatients(
          token, hospitalization.hospitalizedPatient);
      return hospitalization;
    } else {
      var responseError = JSON.jsonDecode(response.body);
      responseError = responseError['detail'];
      _hospitalizationSubject.add(null);
      _hospitalizationIsLoading.add(false);
      _hospitalizationErrorSubject.add(responseError);
      patientBloc.setNull();
    }
  }

  Future<dynamic> createHospitalization(int patientDni, String diagnosis,
      String description, int status, token) async {
    final response = await http.post(
      'http://10.0.2.2:8000/api/progress/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
      body: JSON.jsonEncode(
        {
          'patient': patientDni,
          'diagnosis': diagnosis,
          'description': description,
          'status': status,
        },
      ),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      var responseError = JSON.jsonDecode(response.body);
      return responseError;
    }
  }

  Future<dynamic> dischargePatient(bed,doctor,int patientDni, String diagnosis,
      String description, status, token) async {
    final response = await http.post(
      'http://10.0.2.2:8000/api/progress/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
      body: JSON.jsonEncode(
        {
          'patient': patientDni,
          'has_left': true,
          'diagnosis': diagnosis,
          'description': description,
          'status': status,
        },
      ),
    );
    if (response.statusCode == 201) {
      dischargePatientHospitalization(patientDni, bed, doctor, token);
      return true;
    } else {
      print(response.body);
    }
  }

  Future<dynamic> dischargePatientHospitalization(
      int dni, bed, doctor, token) async {
    final response = await http.post(
      'http://10.0.2.2:8000/api/hospitalization/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
      body: JSON.jsonEncode(
        {
          'patient': dni,
          'left_at': DateTime.now().toString(),
          'bed': bed,
          'doctor': doctor,
        },
      ),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      print(response.body);
    }
  }

  Future assignPatient(int doctorId, int bedId, int patientDni, token) async {
    final response = await http.post(
      'http://10.0.2.2:8000/api/hospitalization/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
      body: JSON.jsonEncode(
        {
          'doctor': doctorId,
          'bed': bedId,
          'patient': patientDni,
          'entry_at': DateTime.now().toString(),
        },
      ),
    );
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
    }
  }

  dispose() {
    _hospitalizationSubject.close();
    _hospitalizationErrorSubject.close();
    _hospitalizationIsLoading.close();
    this.dispose();
  }
}
