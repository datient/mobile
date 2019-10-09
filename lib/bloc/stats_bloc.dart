import 'dart:convert' as JSON;
import 'package:datient/models/statistic.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class StatsBloc {
  final _statsSubject = BehaviorSubject<Statistic>();
  Stream<Statistic> get stats => _statsSubject.stream;

  Future<Statistic> getStats(token) async {
    Statistic statistic;
    final response = await http.get(
      'http://10.0.2.2:8000/statistics/',
      headers: {'Authorization': 'JWT $token'},
    );

    if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body);
      statistic = Statistic.fromJson(extractdata);
      _statsSubject.sink.add(statistic);
      print(statistic);
    }
    return statistic;
  }

  dispose() {
    _statsSubject.close();
    this.dispose();
  }
}
