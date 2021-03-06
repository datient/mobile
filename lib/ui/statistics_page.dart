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
    bloc.doctor.listen((value) => statsBloc.getTotalStats(value.token));
    return Scaffold(
        appBar: AppBar(
          title: Text('Estadisticas'),
        ),
        body: _buildStatsStream());
  }

  Widget _buildChart(data) {
    StatsBloc statsBloc = DatientProvider.of(context).statsBloc;
    return AspectRatio(
      aspectRatio: 0.69,
      child: Column(
        children: [
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 3,
              child: FlChart(
                chart: PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(
                          touchResponseStreamSink:
                              pieTouchedResultStreamController.sink),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: showingSections(data)),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Statistic statistics = data[index];
                      return Padding(
                        padding: EdgeInsets.all(2),
                        child: Indicator(
                          color: Color(int.parse(
                                  statistics.color.substring(1, 7),
                                  radix: 16) +
                              0xFF000000),
                          text: '${statistics.diagnosis}: ${statistics.total}',
                          isSquare: false,
                          size: touchedIndex == index ? 18 : 16,
                          textColor: touchedIndex == index
                              ? Colors.black
                              : Colors.grey,
                        ),
                      );
                    }),
              ),
            ),
          ),
          Container(
            child: StreamBuilder(
                stream: statsBloc.statsTotal,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      snapshot.error,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ));
                  } else {
                    return snapshot.hasData
                        ? Chip(
                          avatar: Icon(Icons.pie_chart,color:Colors.white),
                          backgroundColor: Colors.blue,
                            label: Text(
                              'Total: ${snapshot.data}',
                              style: TextStyle(fontSize: 20,color: Colors.white),
                            ),
                          )
                        : Container();
                  }
                }),
          )
        ],
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
          color: Color(int.parse(statistics.color.substring(1, 7), radix: 16) +
              0xFF000000),
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
