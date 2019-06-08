import 'package:datient/models/doctor.dart';
import 'package:datient/models/room.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var token;
  Doctor doctor = Doctor();
  Room room = Room();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salas'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: FutureBuilder(
                future: this.doctor.getDoctor(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return ListView(
                    children: [
                      Text(
                        'Doctor: ' + '${snapshot.data}',
                        style: TextStyle(fontSize: 28),
                      )
                    ],
                  );
                },
              ),
            ),
            Expanded(
              flex: 9,
              child: FutureBuilder(
                future: this.room.getRoom(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(snapshot.data.length, (i) {
                      return Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/room');
                          },
                          child: Card(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_hospital,
                                    size: 80,
                                  ),
                                  Text(
                                    snapshot.data[i]['name'],
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
