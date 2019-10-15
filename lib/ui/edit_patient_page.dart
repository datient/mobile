import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';
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
  final _cBirthDate = TextEditingController();
  final _cHistoryNumber = TextEditingController();
  final _cContact = TextEditingController();
  final _cSecondContact = TextEditingController();
  var genderIndex;
  Gender selectedGender;
  List<Gender> genders = <Gender>[
    const Gender('Masculino'),
    const Gender('Femenino'),
  ];
  final GlobalKey<FormState> _createformKey = new GlobalKey<FormState>();
  var selectedDate;
  var formatter = new DateFormat('dd-MM-yyyy');

  void initState() {
    _cFirstName..text = widget.patient.firstName;
    _cDni..text = widget.patient.dni.toString();
    _cHistoryNumber..text = widget.patient.historyNumber.toString();
    _cLastName..text = widget.patient.lastName;
    var _birthDate = DateTime.parse(widget.patient.birthDate);
    _cBirthDate..text = formatter.format(_birthDate);
    selectedDate = _birthDate;
    if (_cContact != null) {
      _cContact..text = widget.patient.contact;
    }
    if (_cContact != null) {
      _cSecondContact..text = widget.patient.secondContact;
    }
    super.initState();
  }

  void _showPicker() {
    showDatePicker(
            locale: Locale('es'),
            context: context,
            firstDate: new DateTime(1900),
            initialDate: DateTime.now(),
            lastDate: DateTime.now())
        .then((DateTime dt) {
      String formattedDate = formatter.format(dt);
      _cBirthDate.text = (formattedDate);
      selectedDate = dt;
    });
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
              enabled: false,
              controller: _cDni,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: Icon(Icons.picture_in_picture),
                labelText: 'DNI',
                hintText: 'Ingrese el DNI del paciente',
              ),
            ),
            GestureDetector(
              onTap: () {
                _showPicker();
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _cBirthDate,
                  decoration: InputDecoration(
                    labelText: 'Fecha de nacimiento',
                    icon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: _cHistoryNumber,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: Icon(Icons.book),
                labelText: 'Número de historial',
                hintText: 'Ingrese el número de historial',
              ),
            ),
            DropdownButtonFormField<Gender>(
              decoration: InputDecoration(
                icon: Icon(Icons.people),
              ),
              hint: Text('Seleccione su género'),
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
              controller: _cContact,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                icon: Icon(Icons.contact_phone),
                labelText: 'Número de contacto (Opcional)',
                hintText: 'Ingrese el número de contacto',
              ),
            ),
            TextFormField(
              controller: _cSecondContact,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                icon: Icon(Icons.contact_phone),
                labelText: '2do Número de contacto (Opcional)',
                hintText: 'Ingrese el número de contacto',
              ),
            ),
          ],
        ),
      ),
    );
  }

  _validateAndSubmit(token) {
    var _formatter = new DateFormat('yyyy-MM-dd');
    String _formattedDate = _formatter.format(selectedDate);
    var patient = PatientBloc();
    if (_createformKey.currentState.validate()) {
      String _firstName = _cFirstName.value.text;
      String _lastName = _cLastName.value.text;
      int _dni = int.parse(_cDni.value.text);
      String _birthdate = _formattedDate;
      int _historyNumber = int.parse(_cHistoryNumber.value.text);
      int _gender = genderIndex;
      String _contact = _cContact.value.text;
      String _secondContact = _cSecondContact.value.text;

      if (_contact.isEmpty) {
        _contact = null;
      }
      if (_secondContact.isEmpty) {
        _secondContact = null;
      }

      patient
          .editPatient(_firstName, _lastName, _dni, _birthdate, _historyNumber,
              _gender, _contact, _secondContact, token, widget.patient)
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
                      Text('El paciente ha sido modificado con éxito'),
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
          Navigator.of(context).pop();
          return showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(width: 10),
                    Text('Ha ocurrido un error'),
                  ],
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(success),
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
        }
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
