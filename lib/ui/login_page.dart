import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/bloc/room_bloc.dart';
import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';
import 'package:expandable_card/expandable_card.dart';

class Hierarchy {
  const Hierarchy(this.name);
  final String name;
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var hasError = false;
  var hierarchyIndex;
  Hierarchy selectedHierarchy;
  List<Hierarchy> hierarchies = <Hierarchy>[
    const Hierarchy('Jefe del servicio medico'),
    const Hierarchy('Medico del servicio de clinica medica'),
    const Hierarchy('Medico encargado del internado')
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _regformKey = new GlobalKey<FormState>();
  final _mailController = TextEditingController();
  final _pwController = TextEditingController();
  final _rmailController = TextEditingController();
  final _rfirstnameController = TextEditingController();
  final _rlastnameController = TextEditingController();
  final _rpasswordController = TextEditingController();
  final _rpasswordconfirmController = TextEditingController();
  String emailError;
  String nameError;
  String lastNameError;
  String passwordError;
  String hierarchyError;

  Widget loginForm(DatientBloc bloc) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.only(right: 10, left: 10, top: 100),
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Wrap(
                children: <Widget>[
                  TextFormField(
                    controller: _mailController,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        hasError = true;
                        return 'Ingrese su correo electrónico';
                      }
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Correo Electrónico',
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "Ingrese su correo",
                      fillColor: Colors.white70,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        hasError = true;
                        return 'Ingrese su correo contraseña';
                      }
                    },
                    controller: _pwController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Contraseña',
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Ingrese su contraseña",
                        fillColor: Colors.white70),
                    obscureText: true,
                  ),
                  Container(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _validateAndSubmit(
    DatientBloc bloc,
    RoomBloc roomBloc,
    PatientBloc patientBloc,
  ) {
    if (_formKey.currentState.validate()) {
      String mail = _mailController.value.text;
      String password = _pwController.value.text;
      bloc.signIn(mail, password, roomBloc, patientBloc).then((success) {
        if (success == true) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(success),
            duration: Duration(seconds: 3),
          ));
        }
      });
    }
  }

  _register() {
    var doctor = DatientBloc();
    if (_regformKey.currentState.validate()) {
      String registerEmail = _rmailController.value.text;
      String registerFirstName = _rfirstnameController.value.text;
      String registerLastName = _rlastnameController.value.text;
      int hierarchy = hierarchyIndex;
      String registerPassword = _rpasswordController.value.text;
      String registerConfirmPassword = _rpasswordconfirmController.value.text;
      doctor
          .registerDoctor(registerEmail, registerFirstName, registerLastName,
              hierarchy, registerPassword, registerConfirmPassword)
          .then((success) {
        if (success == true) {
          Navigator.of(context).popAndPushNamed('/login');
          return showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(width: 10),
                    Text('Usuario Registrado'),
                  ],
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('El usuario ha sido registrado con exito'),
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
          if (success['email'] != null) {
            List _emailError = success['email'];
            emailError = '';
            _emailError.forEach((error) {
              setState(() {
                emailError += '$error ';
              });
            });
          }
          if (success['first_name'] != null) {
            List _nameError = success['first_name'];
            nameError = '';
            _nameError.forEach((error) {
              setState(() {
                nameError += '$error ';
              });
            });
          }
          if (success['last_name'] != null) {
            List _lastNameError = success['last_name'];
            lastNameError = '';
            _lastNameError.forEach((error) {
              setState(() {
                lastNameError += '$error ';
              });
            });
          }
          if (success['hierarchy'] != null) {
            List _hierarchyError = success['hierarchy'];
            hierarchyError = '';
            _hierarchyError.forEach((error) {
              setState(() {
                hierarchyError += '$error ';
              });
            });
          }
          if (success['password'] != null) {
            List _pwError = success['password'];
            passwordError = '';
            _pwError.forEach((error) {
              setState(() {
                passwordError += '$error ';
              });
            });
          }
        }
      });
    }
  }

  Widget _buildBtnSubmit(bloc, roomBloc, patientBloc) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: SizedBox(
        width: 200,
        height: 40,
        child: RaisedButton(
          color: Colors.red,
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: () {
            _validateAndSubmit(bloc, roomBloc, patientBloc);
          },
          child: Text(
            'Iniciar Sesión',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRegister() {
    return ExpandableCard(
      hasHandle: false,
      backgroundColor: Colors.white,
      hasRoundedCorners: true,
      maxHeight: MediaQuery.of(context).size.height - 20,
      minHeight: 130,
      children: <Widget>[
        Column(
          children: [
            Text(
              'Registrarse',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(color: Colors.black, height: 40.0),
            Form(
              key: _regformKey,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _rmailController,
                      decoration: InputDecoration(
                        errorMaxLines: 3,
                        errorText: emailError,
                        icon: Icon(Icons.email),
                        labelText: 'Correo Electrónico',
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Ingrese su correo",
                        fillColor: Colors.white70,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    DropdownButtonFormField<Hierarchy>(
                      decoration: InputDecoration(
                        errorText: hierarchyError,
                        icon: Icon(Icons.star),
                      ),
                      hint: Text('Seleccione su jerarquía'),
                      value: selectedHierarchy,
                      onChanged: (Hierarchy newValue) {
                        setState(() {
                          selectedHierarchy = newValue;
                          hierarchyIndex = hierarchies.indexOf(newValue);
                        });
                      },
                      items: hierarchies.map((Hierarchy hierarchy) {
                        return new DropdownMenuItem<Hierarchy>(
                          value: hierarchy,
                          child: new Text(
                            hierarchy.name,
                            style: new TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                    TextFormField(
                      controller: _rfirstnameController,
                      decoration: InputDecoration(
                        errorText: nameError,
                        icon: Icon(Icons.person),
                        labelText: 'Nombre',
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Ingrese su nombre",
                        fillColor: Colors.white70,
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    TextFormField(
                      controller: _rlastnameController,
                      decoration: InputDecoration(
                        errorText: lastNameError,
                        icon: Icon(Icons.person),
                        labelText: 'Apellido',
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Ingrese su apellido",
                        fillColor: Colors.white70,
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    TextFormField(
                      controller: _rpasswordController,
                      decoration: InputDecoration(
                          errorMaxLines: 4,
                          errorText: passwordError,
                          icon: Icon(Icons.lock),
                          labelText: 'Contraseña',
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Ingrese su contraseña",
                          fillColor: Colors.white70),
                      obscureText: true,
                    ),
                    TextFormField(
                      controller: _rpasswordconfirmController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: 'Confirme su contraseña',
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Vuelva a ingresar su contraseña",
                          fillColor: Colors.white70),
                      obscureText: true,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: 300,
                        height: 40,
                        child: RaisedButton(
                          child: Text(
                            'Registrarse',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                wordSpacing: 5),
                          ),
                          onPressed: () {
                            _register();
                          },
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = DatientProvider.of(context).bloc;
    final roomBloc = DatientProvider.of(context).roomBloc;
    final patientBloc = DatientProvider.of(context).patientBloc;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Login'),
      ),
      body: ExpandableCardPage(
          page: SafeArea(
            child: Stack(
              children: [
                ListView(
                  children: [loginForm(bloc)],
                ),
                Positioned(
                  top: 250,
                  left: 85,
                  child: _buildBtnSubmit(bloc, roomBloc, patientBloc),
                ),
              ],
            ),
          ),
          expandableCard: buildRegister()),
    );
  }
}
