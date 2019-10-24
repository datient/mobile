import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';
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
  DateTime selectedDate = DateTime.now();
  String nameError;
  String lastNameError;
  String dniError;
  String dateError;
  String genderError;
  String contactError;
  String contact2Error;

  void _showPicker() {
    var formatter = new DateFormat('dd-MM-yyyy');
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
              validator: (value) {
                if (value.isEmpty) {
                  return 'Ingrese un nombre válido';
                }
              },
              controller: _cFirstName,
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Nombre',
                hintText: 'Ingrese el nombre del paciente',
              ),
            ),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Ingrese un apellido válido';
                }
              },
              controller: _cLastName,
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Apellido',
                hintText: 'Ingrese el apellido del paciente',
              ),
            ),
            TextFormField(
              controller: _cDni,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Ingrese un DNI válido';
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                errorText: dniError,
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Ingrese una fecha de nacimiento válida';
                    }
                  },
                  controller: _cBirthDate,
                  decoration: InputDecoration(
                    labelText: 'Fecha de nacimiento',
                    icon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Ingrese un número de historial válido';
                }
              },
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
                errorText: genderError,
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
              keyboardType: TextInputType.phone,
              controller: _cContact,
              decoration: InputDecoration(
                icon: Icon(Icons.contact_phone),
                labelText: 'Número de contacto (Opcional)',
                hintText: 'Ingrese el número de contacto',
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: _cSecondContact,
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
    var formatter = new DateFormat('yyyy-MM-dd');
    String date = formatter.format(selectedDate);
    var patient = PatientBloc();
    if (_createformKey.currentState.validate()) {
      String _firstName = _cFirstName.value.text;
      String _lastName = _cLastName.value.text;
      int _dni = int.parse(_cDni.value.text);
      String _birthdate = date;
      int _historyNumber = int.parse(_cHistoryNumber.value.text);
      int _gender = genderIndex;
      String _contactNumber = _cContact.value.text;
      String _secondContactNumber = _cSecondContact.value.text;

      if (_contactNumber.isEmpty) {
        _contactNumber = null;
      }
      if (_secondContactNumber.isEmpty) {
        _secondContactNumber = null;
      }

      patient
          .createPatient(
              _firstName,
              _lastName,
              _dni,
              _birthdate,
              _historyNumber,
              _gender,
              _contactNumber,
              _secondContactNumber,
              token)
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
                      Text('El paciente ha sido registrado con éxito'),
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
          if (success['dni'] != null) {
            List _dniError = success['dni'];
            dniError = '';
            _dniError.forEach((error) {
              setState(() {
                dniError += '$error ';
              });
            });
          }
          if (success['gender'] != null) {
            List _genderError = success['gender'];
            genderError = '';
            _genderError.forEach((error) {
              setState(() {
                genderError += '$error ';
              });
            });
          }
          if (success['detail'] != null) {
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
                        Text('${success['detail']}'),
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
