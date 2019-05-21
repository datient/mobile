import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as JSON;
import 'HomePage.dart';
import 'Doctor.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  _showSnackBar() {
    final snackBar = SnackBar(
      content: Text('El Usuario/Correo ingresado son incorrectos'),
      backgroundColor: Colors.red,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final mailcontroller = TextEditingController();
    final pwcontroller = TextEditingController();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextFormField(
                decoration: new InputDecoration(
                    labelText: 'Correo Electronico',
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "Ingrese su correo",
                    fillColor: Colors.white70),
                controller: mailcontroller,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextFormField(
                decoration: new InputDecoration(
                    labelText: 'Contraseña',
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "Ingrese su contraseña",
                    fillColor: Colors.white70),
                obscureText: true,
                controller: pwcontroller,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: RaisedButton(
                      onPressed: () {
                        var doctor = Doctor();
                        doctor.obtainToken(
                            mailcontroller.text, pwcontroller.text);
                            Navigator.of(context).pushReplacementNamed('/home');
                      },
                      child: Text('Iniciar Sesion'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text('Registrarse'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
