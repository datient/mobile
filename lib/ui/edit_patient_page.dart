import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/doctor.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class PatientEditPage extends StatefulWidget {
  final Patient patient;

  PatientEditPage({Key key, this.patient}) : super(key: key);
  @override
  _PatientEditPageState createState() => _PatientEditPageState();
}

class Gender {
  const Gender(this.name);
  final String name;
}

class _PatientEditPageState extends State<PatientEditPage> {
  final _cFirstName = TextEditingController();
  final _cLastName = TextEditingController();
  final _cDni = TextEditingController();
  final _cHistoryNumber = TextEditingController();
  final _cInitialDiagnosis = TextEditingController();
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
              controller: _cFirstName..text = widget.patient.firstName,
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Nombre',
                hintText: 'Ingrese el nombre del paciente',
              ),
            ),
            TextFormField(
              controller: _cLastName..text = widget.patient.lastName,
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Apellido',
                hintText: 'Ingrese el apellido del paciente',
              ),
            ),
            TextFormField(
              controller: _cDni..text = widget.patient.dni.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: Icon(Icons.picture_in_picture),
                labelText: 'DNI',
                hintText: 'Ingrese el DNI del paciente',
              ),
            ),
            _buildDatePicker(),
            TextFormField(
              controller: _cHistoryNumber
                ..text = widget.patient.historyNumber.toString(),
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
              controller: _cInitialDiagnosis
                ..text = widget.patient.incomeDiagnostic,
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
          .editPatient(_firstName, _lastName, _dni, _birthdate, _historyNumber,
              _gender, _incomeDiagnosis, token, widget.patient)
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
                    Text('Paciente modificado'),
                  ],
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('El paciente ha sido modificado con exito'),
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
        } else {}
      });
    }
  }

  Widget build(BuildContext context) {
    final DatientBloc bloc = DatientProvider.of(context).bloc;

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar paciente'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
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
