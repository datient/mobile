import 'dart:async';
import 'package:datient/bloc/stats_bloc.dart';
import 'package:datient/models/statistic.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'indicator.dart';

class StatisticsPage extends StatefulWidget {
  StatisticsPage({
    Key key,
  }) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  StreamController<PieTouchResponse> pieTouchedResultStreamController;
  int touchedIndex;

  @override
  void initState() {
    super.initState();

    pieTouchedResultStreamController = StreamController();
    pieTouchedResultStreamController.stream.distinct().listen((details) {
      if (details == null) {
        return;
      }

      setState(() {
        if (details.touchInput is FlLongPressEnd) {
          touchedIndex = -1;
        } else {
          touchedIndex = details.touchedSectionPosition;
        }
      });
    });
  }

  Widget build(BuildContext context) {
    final bloc = DatientProvider.of(context).bloc;
    StatsBloc statsBloc = DatientProvider.of(context).statsBloc;
    bloc.doctor.listen((value) => statsBloc.getStats(value.token));
    return Scaffold(
        appBar: AppBar(
          title: Text('Estadisticas'),
        ),
        body: _buildStatsStream());
  }

  Widget _buildChart(data) {
    return AspectRatio(
      aspectRatio: 0.69,
      child: Card(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: FlChart(
                  chart: PieChart(
                    PieChartData(
                        pieTouchData: PieTouchData(
                            touchResponseStreamSink:
                                pieTouchedResultStreamController.sink),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingSections(data)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Statistic statistics = data[index];
                      return Indicator(
                        color: Color(0xff0293ee),
                        text: '${statistics.diagnosis}',
                        isSquare: false,
                        size: touchedIndex == index ? 18 : 16,
                        textColor:
                            touchedIndex == index ? Colors.black : Colors.grey,
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(data) {
    return List.generate(
      data.length,
      (index) {
        Statistic statistics = data[index];
        final isTouched = index == touchedIndex;
        int intVar = statistics.percentage;
        double doubleVar = intVar.toDouble();
        final double fontSize = isTouched ? 25 : 16;
        final double radius = isTouched ? 60 : 50;
        return PieChartSectionData(
          color: const Color(0xff0293ee),
          value: doubleVar,
          title: '${statistics.percentage}%',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)),
        );
      },
    );
  }

  Widget _buildStatsStream() {
    StatsBloc statsBloc = DatientProvider.of(context).statsBloc;
    return StreamBuilder(
        stream: statsBloc.isloading,
        builder: (context, snapshot) {
          return (snapshot.hasData && snapshot.data)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder(
                  stream: statsBloc.stats,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        snapshot.error,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ));
                    } else {
                      return snapshot.hasData
                          ? _buildChart(snapshot.data)
                          : Container();
                    }
                  });
        });
  }
}
