import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class PatientAddPage extends StatefulWidget {
  final Patient patient;

  PatientAddPage({Key key, this.patient}) : super(key: key);
  @override
  _PatientAddPageState createState() => _PatientAddPageState();
}

class Gender {
  const Gender(this.name);
  final String name;
}

class _PatientAddPageState extends State<PatientAddPage> {
    var genderIndex;
  Gender selectedGender;
  List<Gender> genders = <Gender>[
    const Gender('Masculino'),
    const Gender('Femenino'),
  ];
  final GlobalKey<FormState> _createformKey = new GlobalKey<FormState>();
  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };
  InputType inputType = InputType.date;
  bool editable = true;
  DateTime date;
  @override
  Widget _buildDatePicker() {
    return DateTimePickerFormField(
      inputType: inputType,
      format: formats[inputType],
      editable: editable,
      decoration: InputDecoration(
          icon: Icon(Icons.calendar_today),
          labelText: 'Fecha de nacimiento',
          hasFloatingPlaceholder: false),
      onChanged: (dt) => setState(() => date = dt
      ),
      
    );
  }

  Widget _buildPatientForm() {
    final DatientBloc bloc = DatientProvider.of(context).bloc;
    final _cFirstName = TextEditingController();
    final _cLastName = TextEditingController();
    final _cDni = TextEditingController();
    final _cHistoryNumber = TextEditingController();
    final _cInitialDiagnosis = TextEditingController();

    return Form(
      key: _createformKey,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextFormField(
              controller: _cFirstName,
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Nombre',
                hintText: 'Ingrese el nombre del paciente',
              ),
            ),
            TextFormField(
              controller: _cLastName,
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Apellido',
                hintText: 'Ingrese el apellido del paciente',
              ),
            ),
            TextFormField(
              controller: _cDni,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: Icon(Icons.picture_in_picture),
                labelText: 'DNI',
                hintText: 'Ingrese el DNI del paciente',
              ),
            ),
            _buildDatePicker(),
            TextFormField(
              controller: _cHistoryNumber,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: Icon(Icons.book),
                labelText: 'Numero de historial',
                hintText: 'Ingrese el numero de historial',
              ),
            ),
                                DropdownButtonFormField<Gender>(
                      decoration: InputDecoration(
                        icon: Icon(Icons.people),
                      ),
                      hint: Text('Seleccione su genero'),
                      value: selectedGender,
                      onChanged: (Gender newValue) {
                        setState(() {
                          selectedGender = newValue;
                          genderIndex = genders.indexOf(newValue);
                        });
                      },
                      items: genders.map((Gender gender) {
                        return new DropdownMenuItem<Gender>(
                          value: gender,
                          child: new Text(
                            gender.name,
                            style: new TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
            TextFormField(
              controller: _cInitialDiagnosis,
              decoration: InputDecoration(
                  icon: Icon(Icons.assignment),
                  labelText: 'Diagnostico Inicial',
                  hintText: 'Ingrese el diagnostico inicial'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: RaisedButton(
                child: Text(
                  'Crear',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, wordSpacing: 5),
                ),
                onPressed: () {
                  bloc.doctor.listen((value) => _createPatient(value.token));
                },
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ],
        ),
      ),
    );
    _validateAndSubmit(PatientBloc patient) {
      if (_createformKey.currentState.validate()) {
        String _firstName = _cFirstName.value.text;
        String _lastName = _cLastName.value.text;
        int _dni = int.parse(_cDni.value.text);
        String _birthdate = date.toString();
        int _historyNumber = int.parse(_cHistoryNumber.value.text);
        String _incomeDiagnosis = _cInitialDiagnosis.value.text;
        // patient.createPatient().then((success) {
        //   if (success == true) {
        //     //Navigator.of(context).pushReplacementNamed('/home');
        //   } else {}
        // });
      }
    }
  }

  _createPatient(token) {
    var patient = PatientBloc();
    patient.createPatient(
        'Facundo', 'Barafani', 20560780, '2015-06-19', 10, 0, 'prueba', token);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear paciente'),
      ),
      body: ListView(children: [
        _buildPatientForm(),
      ]),
    );
  }
}
