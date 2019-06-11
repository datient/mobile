import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _mailController = TextEditingController();
  final _pwController = TextEditingController();

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
                        return 'Por favor, ingrese su correo electronico';
                      }
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Correo Electronico',
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "Ingrese su correo",
                      fillColor: Colors.white70,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    controller: _pwController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor, ingrese su correo contraseña';
                      }
                    },
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

  _validateAndSubmit(DatientBloc bloc) {
    if (_formKey.currentState.validate()) {
      String mail = _mailController.value.text;
      String password = _pwController.value.text;
      bloc.signIn(mail, password).then((_) {
        Navigator.of(context).pushReplacementNamed('/home');
      });
    }
  }

  Widget _buildBtnSubmit(bloc) {
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
            _validateAndSubmit(bloc);
          },
          child: Text(
            'Iniciar Sesion',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = DatientProvider.of(context).bloc;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                loginForm(bloc),
              ],
            ),
            Positioned(
              top: 250,
              left: 85,
              child: _buildBtnSubmit(bloc),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Tooltip(
                  message: "Registrarse",
                  child: FloatingActionButton(
                    onPressed: () {},
                    child: Icon(Icons.person_add),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
