import 'package:datient/bloc/patient_bloc.dart';
import 'package:datient/bloc/room_bloc.dart';
import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';

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
            margin: EdgeInsets.only(right: 10, left: 10),
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
                  Container(
                    height: 20,
                  )
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

  Widget buildBtnSubmit(bloc, roomBloc, patientBloc) {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'No tienes una cuenta?',
          style: TextStyle(fontSize: 15),
        ),
        Container(
          width: 10,
        ),
        RaisedButton(
          color: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Text(
            'Registro',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/register');
          },
        )
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
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              child: Image.asset(
                'assets/images/iconodatient.png',
                height: 250,
              ),
            ),
            loginForm(bloc),
            buildBtnSubmit(bloc, roomBloc, patientBloc),
            buildRegister()
          ],
        ),
      ),
    );
  }
}
