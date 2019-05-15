import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as JSON;
import 'Home.dart' as home;

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _token = 'token';

  Future _getDoctors() async {
    await http.get('http://10.0.2.2:8000/api/doctor/',
        headers: {'Authorization': 'JWT ${_token}'}).then((res) {
      print(res.body);
    });
  }

  Future _getToken(email, password) async {
    await http
        .post('http://10.0.2.2:8000/token/',
            headers: {'Content-Type': 'application/json'},
            body: JSON.jsonEncode({'email': email, 'password': password}))
        .then((res) {
      setState(() {
        _token = JSON.jsonDecode(res.body)['token'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mailcontroller = TextEditingController();
    final pwcontroller = TextEditingController();
    return Scaffold(
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
                        _getToken(mailcontroller.text, pwcontroller.text);
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => home.HomePage(),
                          ),
                        );
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
