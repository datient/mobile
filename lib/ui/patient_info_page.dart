import 'dart:io';

import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/models/study.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'edit_patient_page.dart';
import 'package:intl/intl.dart';

class PatientInfoPage extends StatefulWidget {
  final Patient patient;
  PatientInfoPage({Key key, this.patient}) : super(key: key);
  @override
  _PatientInfoPageState createState() => _PatientInfoPageState();
}

class _PatientInfoPageState extends State<PatientInfoPage>
    with SingleTickerProviderStateMixin {
  @override
  var _patientGender;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  File _image;

  Future getImage() async {
    final DatientBloc bloc = DatientProvider.of(context).bloc;
    final PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    if (_image != null) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Row(
              children: [
                Icon(Icons.info_outline),
                SizedBox(width: 10),
                Text('Publicar estudio'),
              ],
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Image.file(_image),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Aceptar',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
                onPressed: () {
                  bloc.doctor.listen((value) => patientBloc
                          .postStudy(_image, widget.patient.dni, value.token)
                          .then((success) {
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
                                  Text('Estudio publicado'),
                                ],
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(
                                        'El estudio se ha publicado con exito'),
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
                      }));
                },
              ),
              FlatButton(
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
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

  Widget _buildPatientInfo() {
    return ListView(
      children: [
        Card(
          margin: EdgeInsets.all(15),
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nombre',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      widget.patient.firstName,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apellido',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      widget.patient.lastName,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DNI',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      widget.patient.dni.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fecha de nacimiento',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      widget.patient.birthDate,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edad',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      widget.patient.age.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
                _buildPatientContacts(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Número de historial',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      widget.patient.historyNumber.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Género',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      _patientGender,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diagnóstico Inicial',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      widget.patient.incomeDiagnostic,
                      maxLines: 3,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPatientContacts() {
    if (widget.patient.contact != null &&
        widget.patient.secondContact != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Telefono de contacto',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              Text(
                widget.patient.contact.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Segundo telefono de contacto',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              Text(
                widget.patient.secondContact.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Divider(),
        ],
      );
    } else if (widget.patient.contact != null &&
        widget.patient.secondContact == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Telefono de contacto',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              Text(
                widget.patient.contact.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Divider(),
        ],
      );
    } else if (widget.patient.secondContact != null &&
        widget.patient.contact == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Segundo telefono de contacto',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              Text(
                widget.patient.secondContact.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Divider(),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildPatientStudies() {
    return (widget.patient.studies.isNotEmpty)
        ? ListView.builder(
            itemCount: widget.patient.studies.length,
            itemBuilder: (BuildContext context, int index) {
              Study studies = widget.patient.studies[index];
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: GestureDetector(
                    child: Hero(
                      tag: 'studyHero$index',
                      child: Image.network(studies.image),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return DetailScreen(image: studies.image, index: index);
                      }));
                    },
                  ),
                ),
              );
            },
          )
        : Center(
            child: Text(
              'No se han encontrado estudios',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
  }

  Widget _buildFloatingActionButton() {
    if (_tabController.index == 0) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PatientEditPage(
                patient: widget.patient,
              ),
            ),
          );
        },
        child: Icon(Icons.edit),
      );
    } else {
      return FloatingActionButton(
        onPressed: () {
          getImage();
        },
        child: Icon(Icons.file_upload),
      );
    }
  }

  Widget build(BuildContext context) {
    var _createdDate = DateTime.parse(widget.patient.createdDate);
    var _updatedDate = DateTime.parse(widget.patient.updatedDate);
    var dateFormatter = new DateFormat('yMd');
    var timeFormatter = new DateFormat('Hms');
    String formattedCreateDate = dateFormatter.format(_createdDate);
    String formattedTimeCreateDate = timeFormatter.format(_createdDate);
    String formattedUpdateDate = dateFormatter.format(_updatedDate);
    String formattedTimeUpdateDate = timeFormatter.format(_updatedDate);
    var _fullname = widget.patient.firstName + ' ' + widget.patient.lastName;

    if (widget.patient.gender == 0) {
      _patientGender = 'Masculino';
    } else {
      _patientGender = 'Femenino';
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(_fullname),
            actions: [
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  showDialog<void>(
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
                            Text('Detalles'),
                          ],
                        ),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(
                                'Fecha de creación',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(formattedCreateDate +
                                  ' a las ' +
                                  formattedTimeCreateDate),
                              Divider(),
                              Text(
                                'Última actualización',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(formattedUpdateDate +
                                  ' a las ' +
                                  formattedTimeUpdateDate),
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
                },
              )
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(icon: Icon(Icons.assignment), text: 'Datos'),
                Tab(icon: Icon(Icons.save), text: 'Estudios'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              Container(child: _buildPatientInfo()),
              Container(
                child: _buildPatientStudies(),
              )
            ],
          ),
          floatingActionButton: _buildFloatingActionButton()),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String image;
  final int index;
  DetailScreen({Key key, this.image, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          child: Center(
            child: Hero(
              tag: 'studyHero$index',
              child: RotatedBox(
                quarterTurns: 1,
                child: Image.network(image),
              ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
