import 'dart:io';
import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/bloc/room_bloc.dart';
import 'package:datient/models/future_plan.dart';
import 'package:datient/models/hospitalization.dart';
import 'package:datient/models/patient.dart';
import 'package:datient/models/progress.dart';
import 'package:datient/models/study.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'add_futureplan_page.dart';
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
    final DatientBloc bloc = DatientProvider.of(context).bloc;
    final PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
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

  Widget _buildFuturePlanStream() {
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    return StreamBuilder(
        stream: patientBloc.isloading,
        builder: (context, snapshot) {
          return (snapshot.hasData && snapshot.data)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder(
                  stream: patientBloc.patientFuturePlan,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        snapshot.error,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ));
                    } else {
                      return snapshot.hasData
                          ? _buildFuturePlan(snapshot.data)
                          : Container();
                    }
                  });
        });
  }

  Widget _buildFuturePlan(Patient data) {
    return ListView.builder(
      itemCount: data.futurePlans.length,
      itemBuilder: (BuildContext context, int index) {
        FuturePlan plans = data.futurePlans[index];
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
              child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.only(top: 4, bottom: 4),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        plans.title,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(),
                  Text(plans.description),
                ],
              ),
            ),
          )),
        );
      },
    );
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
    final DatientBloc bloc = DatientProvider.of(context).bloc;
    final PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
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
                      data.birthDate,
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
    } else {
      return Container();
    }
  }

  Widget _buildStudyStream() {
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    return StreamBuilder(
        stream: patientBloc.isloading,
        builder: (context, snapshot) {
          return (snapshot.hasData && snapshot.data)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder(
                  stream: patientBloc.patientStudy,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        snapshot.error,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ));
                    } else {
                      return snapshot.hasData
                          ? _buildPatientStudies(snapshot.data)
                          : Container();
                    }
                  });
        });
  }

  Widget _buildPatientStudies(Patient data) {
    return ListView.builder(
      itemCount: data.studies.length,
      itemBuilder: (BuildContext context, int index) {
        Study studies = data.studies[index];
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
    );
  }

  Widget _buildHasLeft(data) {
    return data == true
        ? Chip(
            backgroundColor: Colors.red,
            label: Text(
              'Dado de alta',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          )
        : Container();
  }

  Widget _buildProgressStream() {
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    return StreamBuilder(
        stream: patientBloc.isloading,
        builder: (context, snapshot) {
          return (snapshot.hasData && snapshot.data)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder(
                  stream: patientBloc.patientProgress,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        snapshot.error,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ));
                    } else {
                      return snapshot.hasData
                          ? _buildProgress(snapshot.data)
                          : Container();
                    }
                  });
        });
  }

  Widget _buildProgress(Patient data) {
    return ListView.builder(
      itemCount: data.patientProgress.length,
      itemBuilder: (BuildContext context, int index) {
        Progress progress = data.patientProgress[index];
        var _patientStatus;
        if (progress.status == 0) {
          _patientStatus = 'Bien';
        } else if (progress.status == 1) {
          _patientStatus = 'Precaución';
        } else if (progress.status == 2) {
          _patientStatus = 'Peligro';
        }
        var _createdDate = DateTime.parse(progress.createdAt);
        var dateFormatter = new DateFormat('yMd');
        String formattedCreateDate = dateFormatter.format(_createdDate);
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
              child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.only(top: 4, bottom: 4),
            child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Progreso $formattedCreateDate',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 70,
                        ),
                        _buildHasLeft(progress.hasLeft)
                      ],
                    ),
                    Divider(),
                    Text(
                      'Diagnóstico',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      progress.diagnosis,
                      style: TextStyle(fontSize: 18),
                    ),
                    Divider(),
                    Text(
                      'Descripción',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      progress.description,
                      style: TextStyle(fontSize: 18),
                    ),
                    Divider(),
                    Text(
                      'Estado',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      _patientStatus,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                )),
          )),
        );
      },
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
    var _createdDate = DateTime.parse(widget.patient.createdDate);
    var _updatedDate = DateTime.parse(widget.patient.updatedDate);
    var dateFormatter = new DateFormat('dd-MM-yyyy');
    var timeFormatter = new DateFormat('Hms');
    String formattedCreateDate = dateFormatter.format(_createdDate);
    String formattedTimeCreateDate = timeFormatter.format(_createdDate);
    String formattedUpdateDate = dateFormatter.format(_updatedDate);
    String formattedTimeUpdateDate = timeFormatter.format(_updatedDate);
    var _fullname = widget.patient.firstName + ' ' + widget.patient.lastName;
    final bloc = DatientProvider.of(context).bloc;
    PatientBloc patientBloc = DatientProvider.of(context).patientBloc;
    bloc.doctor.listen((value) =>
        patientBloc.getSpecificPatients(value.token, widget.patient.dni));
    bloc.doctor.listen(
        (value) => patientBloc.getStudy(widget.patient.dni, value.token));
    bloc.doctor.listen(
        (value) => patientBloc.getFuturePlan(widget.patient.dni, value.token));
    bloc.doctor.listen(
        (value) => patientBloc.getProgress(widget.patient.dni, value.token));
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
              Container(child: _buildProgressStream()),
              Container(child: _buildFuturePlanStream()),
              Container(child: _buildStudyStream()),
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
