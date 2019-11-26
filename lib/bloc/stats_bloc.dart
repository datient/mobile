import 'dart:convert' as JSON;
import 'package:datient/models/statistic.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class StatsBloc {
  StatsBloc() {
    _isLoading.add(true);
  }

  final _statsSubject = BehaviorSubject<List<Statistic>>();
  final _statsTotalSubject = BehaviorSubject();
  final _isLoading = BehaviorSubject<bool>();
  Stream<List<Statistic>> get stats => _statsSubject.stream;
  Stream get statsTotal => _statsTotalSubject.stream;
  Stream<bool> get isloading => _isLoading.stream;

  Future<List> getStats(token) async {
    List list;
    final response = await http.get(
      'http://10.0.2.2:8000/statistics/',
      headers: {'Authorization': 'JWT $token'},
    );

    if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body);
      list =
          extractdata['data'].map<Statistic>((json) => Statistic.fromJson(json)).toList();
      _isLoading.sink.add(false);
      _statsSubject.sink.add(list);
    } else {
      _statsSubject.sink.addError('Error');
    }
    return list;
  }

    Future getTotalStats(token) async {
    final response = await http.get(
      'http://10.0.2.2:8000/statistics/',
      headers: {'Authorization': 'JWT $token'},
    );

    if (response.statusCode == 200) {
      final extractdata = JSON.jsonDecode(response.body);
      _statsTotalSubject.sink.add(extractdata['total']);
      return extractdata['total'];
    } else {
      _statsTotalSubject.sink.addError('Error');
    }
  }

  dispose() {
    _statsSubject.close();
    _statsTotalSubject.close();
    _isLoading.close();
    this.dispose();
  }
}
