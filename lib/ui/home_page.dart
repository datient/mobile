import 'package:datient/ui/patient_page.dart';
import 'package:datient/ui/rooms_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    final _pages = [
      RoomsPage(),
      PatientPage(),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        selectedFontSize: 15,
        unselectedFontSize: 15,
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            title: Text('Salas'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Pacientes'),
          ),
        ],
      ),
      body: _pages[_selectedPage],
    );
  }
}
