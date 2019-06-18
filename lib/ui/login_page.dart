import 'package:datient/bloc/datient_bloc.dart';
import 'package:datient/providers/datient_provider.dart';
import 'package:flutter/material.dart';
import 'package:expandable_card/expandable_card.dart';

class Hierarchy {
  const Hierarchy(this.name);
  final String name;
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var hierarchyIndex;
  Hierarchy selectedHierarchy;
  List<Hierarchy> hierarchies = <Hierarchy>[
    const Hierarchy('Jefe del servicio medico'),
    const Hierarchy('Medico del servicio de clinica medica'),
    const Hierarchy('Medico encargado del internado')
  ];
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _regformKey = new GlobalKey<FormState>();
  final _mailController = TextEditingController();
  final _pwController = TextEditingController();
  final _rmailController = TextEditingController();
  final _rfirstnameController = TextEditingController();
  final _rlastnameController = TextEditingController();
  final _rpasswordController = TextEditingController();
  final _rpasswordconfirmController = TextEditingController();

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
      bloc.signIn(mail, password).then((success) {
        if (success == true) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      });
    }
  }

  _register() {
    var doctor = DatientBloc();
    String registerEmail = _rmailController.value.text;
    String registerFirstName = _rfirstnameController.value.text;
    String registerLastName = _rlastnameController.value.text;
    int hierarchy = hierarchyIndex;
    String registerPassword = _rpasswordController.value.text;
    String registerConfirmPassword = _rpasswordconfirmController.value.text;
    doctor.registerDoctor(registerEmail, registerFirstName, registerLastName,
        hierarchy, registerPassword, registerConfirmPassword);
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
                        icon: Icon(Icons.email),
                        labelText: 'Correo Electronico',
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Ingrese su correo",
                        fillColor: Colors.white70,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    DropdownButtonFormField<Hierarchy>(
                      decoration: InputDecoration(
                        icon: Icon(Icons.star),
                      ),
                      hint: Text('Seleccione su jerarquia'),
                      value: selectedHierarchy,
                      onChanged: (Hierarchy newValue) {
                        setState(() {
                          selectedHierarchy = newValue;
                          hierarchyIndex = hierarchies.indexOf(newValue);
                          print(hierarchyIndex);
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
                      padding: EdgeInsets.only(left: 200, top: 20),
                      child: RaisedButton(
                        child: Text('Registrarse'),
                        onPressed: () {
                          _register();
                        },
                        color: Colors.lightBlueAccent,
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ExpandableCardPage(
          page: SafeArea(
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
              ],
            ),
          ),
          expandableCard: buildRegister()),
    );
  }
}
