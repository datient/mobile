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
  final _cFirstName = TextEditingController();
  final _cLastName = TextEditingController();
  final _cDni = TextEditingController();
  final _cHistoryNumber = TextEditingController();
  final _cInitialDiagnosis = TextEditingController();
  final _cContact = TextEditingController();
  final _cSecondContact = TextEditingController();
  var genderIndex;
  Gender selectedGender;
  List<Gender> genders = <Gender>[
    const Gender('Masculino'),
    const Gender('Femenino'),
  ];
  final GlobalKey<FormState> _createformKey = new GlobalKey<FormState>();
  InputType inputType = InputType.date;
  DateTime date;
  @override
  Widget _buildDatePicker() {
    return DateTimePickerFormField(
      inputType: inputType,
      format: DateFormat('yyyy-MM-dd'),
      decoration: InputDecoration(
          icon: Icon(Icons.calendar_today),
          labelText: 'Fecha de nacimiento',
          hasFloatingPlaceholder: false),
      onChanged: (dt) => setState(() => date = dt),
    );
  }

  Widget _buildPatientForm() {
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
              keyboardType: TextInputType.phone,
              controller: _cContact,
              decoration: InputDecoration(
                icon: Icon(Icons.contact_phone),
                labelText: 'Numero de contacto (Opcional)',
                hintText: 'Ingrese el numero de contacto',
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: _cSecondContact,
              decoration: InputDecoration(
                icon: Icon(Icons.contact_phone),
                labelText: '2do Numero de contacto (Opcional)',
                hintText: 'Ingrese el numero de contacto',
              ),
            ),
            TextFormField(
              controller: _cInitialDiagnosis,
              decoration: InputDecoration(
                  icon: Icon(Icons.assignment),
                  labelText: 'Diagnostico Inicial',
                  hintText: 'Ingrese el diagnostico inicial'),
            ),
          ],
        ),
      ),
    );
  }

  _validateAndSubmit(token) {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(date);
    var patient = PatientBloc();
    if (_createformKey.currentState.validate()) {
      String _firstName = _cFirstName.value.text;
      String _lastName = _cLastName.value.text;
      int _dni = int.parse(_cDni.value.text);
      String _birthdate = formattedDate;
      int _historyNumber = int.parse(_cHistoryNumber.value.text);
      int _gender = genderIndex;
      String _incomeDiagnosis = _cInitialDiagnosis.value.text;
      patient
          .createPatient(_firstName, _lastName, _dni, _birthdate,
              _historyNumber, _gender, _incomeDiagnosis, token)
          .then((success) {
        if (success == true) {
          Navigator.of(context).pop();
          return showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(width: 10),
                    Text('Paciente registrado'),
                  ],
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('El paciente ha sido registrado con exito'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Cerrar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          return false;
        }
      });
    }
  }

  Widget build(BuildContext context) {
    final DatientBloc bloc = DatientProvider.of(context).bloc;
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo paciente'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              bloc.doctor.listen((value) => _validateAndSubmit(value.token));
            },
          )
        ],
      ),
      body: ListView(children: [
        _buildPatientForm(),
      ]),
    );
  }
}
