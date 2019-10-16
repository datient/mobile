import 'dart:io';
import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/models/hospitalization.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:datient/ui/patient_futureplan_page.dart';
import 'package:datient/ui/patient_progress_page.dart';
import 'package:datient/ui/patient_study_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'add_futureplan_page.dart';
import 'edit_patient_page.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientInfoPage extends StatefulWidget {
  final Patient patient;
  PatientInfoPage({Key key, this.patient}) : super(key: key);
  @override
  _PatientInfoPageState createState() => _PatientInfoPageState();
}

class _PatientInfoPageState extends State<PatientInfoPage>
    with SingleTickerProviderStateMixin {
  var _patientGender;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
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

  _buildBed(Hospitalization data) {
    // bloc.doctor.listen((value) =>
    //     patientBloc.getBedName(data.bed, value.token).then((bedName) {
    //     }));
    return Text(
      '${data.bed.toString()}',
      style: TextStyle(fontSize: 20),
    );
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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

  Widget _buildPatientInfoStream() {
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    return StreamBuilder(
        stream: patientBloc.isloading,
        builder: (context, snapshot) {
          return (snapshot.hasData && snapshot.data)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder(
                  stream: patientBloc.specificPatient,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        snapshot.error,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ));
                    } else {
                      return snapshot.hasData
                          ? _buildPatientInfo(snapshot.data)
                          : Container();
                    }
                  });
        });
  }

  Widget _buildPatientInfo(Patient data) {
    final PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    var _birthDate = DateTime.parse(data.birthDate);
    var dateFormatter = new DateFormat('dd-MM-yyyy');
    String formattedBirthDate = dateFormatter.format(_birthDate);
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
                      data.firstName,
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
                      data.lastName,
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
                      data.dni.toString(),
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
                      formattedBirthDate,
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
                      data.age.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
                _buildPatientContacts(data),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Número de historial',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      data.historyNumber.toString(),
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
                      'Cama actual',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    StreamBuilder(
                      stream: patientBloc.isloading,
                      builder: (context, AsyncSnapshot<bool> snapshot) {
                        return snapshot.data && snapshot.hasData
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : StreamBuilder(
                                stream: patientBloc.patientBed,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text(
                                      snapshot.error,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey),
                                    );
                                  }
                                  return snapshot.hasData
                                      ? _buildBed(snapshot.data)
                                      : Container();
                                },
                              );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPatientContacts(Patient data) {
    if (data.contact != null && data.secondContact != null) {
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
                data.contact.toString(),
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
                data.secondContact.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Divider(),
        ],
      );
    } else if (data.contact != null && data.secondContact == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Teléfono de contacto',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              Text(
                data.contact.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Divider(),
        ],
      );
    } else if (data.secondContact != null && data.contact == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Segundo teléfono de contacto',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              Text(
                data.secondContact.toString(),
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
    } else if (_tabController.index == 2) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FuturePlanAddPage(
                patient: widget.patient,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      );
    } else if (_tabController.index == 3) {
      return FloatingActionButton(
        onPressed: () {
          getImage();
        },
        child: Icon(Icons.file_upload),
      );
    }
  }

  Widget build(BuildContext context) {
    var _fullname = widget.patient.firstName + ' ' + widget.patient.lastName;
    final bloc = DatientProvider.of(context).bloc;
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    bloc.doctor.listen((value) =>
        patientBloc.getSpecificPatients(value.token, widget.patient.dni));
    bloc.doctor.listen(
        (value) => patientBloc.getPatientBed(widget.patient.dni, value.token));

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
              PopupMenuButton(
                onSelected: chooseAction,
                icon: Icon(
                  Icons.more_vert,
                ),
                itemBuilder: (_) => <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                    value: 'detail',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                        ),
                        Text(
                          'Detalles',
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'create_pdf',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.picture_as_pdf,
                        ),
                        Text(
                          'Generar PDF',
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        Text(
                          'Eliminar',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(icon: Icon(Icons.assignment), text: 'Datos'),
                Tab(icon: Icon(Icons.timeline), text: 'Evolución'),
                Tab(icon: Icon(Icons.description), text: 'Plan Futuro'),
                Tab(icon: Icon(Icons.folder_shared), text: 'Estudios'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              Container(child: _buildPatientInfoStream()),
              PatientProgressPage(patient: widget.patient),
              PatientFuturePlanPage(patient: widget.patient),
              PatientStudyPage(patient: widget.patient),
            ],
          ),
          floatingActionButton: _buildFloatingActionButton()),
    );
  }

  _launchURL(dni) async {
    var url = 'http://10.0.2.2:8000/pdf/$dni';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void chooseAction(choice) {
    if (choice == 'detail') {
      var _createdDate = DateTime.parse(widget.patient.createdDate);
      var _updatedDate = DateTime.parse(widget.patient.updatedDate);
      var dateFormatter = new DateFormat('dd-MM-yyyy');
      var timeFormatter = new DateFormat('Hms');
      String formattedCreateDate = dateFormatter.format(_createdDate);
      String formattedTimeCreateDate = timeFormatter.format(_createdDate);
      String formattedUpdateDate = dateFormatter.format(_updatedDate);
      String formattedTimeUpdateDate = timeFormatter.format(_updatedDate);
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
    }
    if (choice == 'delete') {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Row(
              children: [
                Icon(Icons.info_outline),
                SizedBox(width: 10),
                Text('Confirmación de accion'),
              ],
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Divider(),
                  Text(
                    'Esta seguro que desea eliminar el paciente?',
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                textColor: Colors.white,
                child: Text('Confirmar'),
                color: Colors.green,
                onPressed: () {
                  _deletePatient();
                },
              ),
              FlatButton(
                textColor: Colors.white,
                child: Text('Cancelar'),
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
    if (choice == 'create_pdf') {
      _launchURL(widget.patient.dni);
    }
  }

  _deletePatient() {
    final bloc = DatientProvider.of(context).bloc;
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    bloc.doctor.listen(
      (value) =>
          patientBloc.deletePatient(widget.patient.dni, value.token).then(
        (success) {
          if (success == true) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
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
                      Text('Paciente eliminado'),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Divider(),
                        Text(
                          'El paciente ha sido eliminado con exito',
                          style: TextStyle(fontSize: 18),
                        )
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
        },
      ),
    );
  }
}
