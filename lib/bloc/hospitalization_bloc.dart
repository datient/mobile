import 'dart:convert' as JSON;
import 'package:datient/models/hospitalization.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class HospitalizationBloc {
  final _hospitalizationSubject = BehaviorSubject<Hospitalization>();
  Stream<Hospitalization> get hospitalizations =>
      _hospitalizationSubject.stream;

  Future<Hospitalization> getHospitalization(token, int bedId) async {
    Hospitalization hospitalization;

    final response = await http.get(
      'http://10.0.2.2:8000/api/hospitalization/$bedId/bed_filter/',
      headers: {'Authorization': 'JWT $token'},
    );

    if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body);
      hospitalization = Hospitalization.fromJson(extractdata);
      _hospitalizationSubject.sink.add(hospitalization);
      return hospitalization;
    }else{
      return null;
    }
  }

  dispose() {
    _hospitalizationSubject.close();
    this.dispose();
  }
}
