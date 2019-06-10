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
          SizedBox(height: 60),
          TextFormField(
            controller: _mailController,
            validator: (value) {
              if (value.isEmpty || !value.contains('@')) {
                return 'Por favor, ingrese su correo electronico';
              }
            },
            decoration: InputDecoration(
              labelText: 'Correo Electronico',
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: "Ingrese su correo",
              fillColor: Colors.white70,
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 18),
          TextFormField(
            controller: _pwController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Por favor, ingrese su correo contraseña';
              }
            },
            decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: "Ingrese su contraseña",
                fillColor: Colors.white70),
            obscureText: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: RaisedButton(
                  onPressed: () {
                    _validateAndSubmit(bloc);
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

  @override
  Widget build(BuildContext context) {
    final bloc = DatientProvider.of(context).bloc;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Builder(builder: (BuildContext context) {
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 15),
            children: <Widget>[
              loginForm(bloc),
            ],
          );
        }),
      ),
    );
  }
}
