import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import 'package:canoe_trip_planner/screens/welcome_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  const RegistrationScreen({
    Key key,
  }) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _errorMessage = '';
  String _name;
  String _confirmed_email;
  String _surname;

  Future<void> submitForm() async {
    setState(() {
      _errorMessage = '';
    });
    bool result = await Provider.of<AuthProvider>(context, listen: false)
        .register(_email, _password, _name, _surname, _confirmed_email);
    print("statusas" +
        Provider.of<AuthProvider>(context, listen: false)
            .statusCode
            .toString());
    if (result == false) {
      setState(() {
        _errorMessage = 'There was a problem with your credentials.';
      });
    } else if (Provider.of<AuthProvider>(context, listen: false).statusCode ==
        200) {
      print("naujas langas");
      Navigator.pushNamed(context, WelcomeScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Name',
                    icon: Icon(
                      Icons.assignment_ind_rounded,
                    )),
                validator: (value) =>
                    value.isEmpty ? 'Please enter a name' : null,
                onSaved: (value) => _name = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Surname',
                    icon: Icon(
                      Icons.assignment_ind_rounded,
                    )),
                validator: (value) =>
                    value.isEmpty ? 'Please enter a surname' : null,
                onSaved: (value) => _surname = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Email',
                    icon: Icon(
                      Icons.mail,
                    )),
                validator: (value) =>
                    value.isEmpty ? 'Please enter an email address' : null,
                onSaved: (value) => _email = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Email confirmation',
                    icon: Icon(
                      Icons.mail,
                    )),
                validator: (value) =>
                    value.isEmpty ? 'Please confirm your email address' : null,
                onSaved: (value) => _confirmed_email = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
                  icon: Icon(
                    Icons.lock,
                  ),
                ),
                obscureText: true,
                validator: (value) =>
                    value.isEmpty ? 'Please enter a password' : null,
                onSaved: (value) => _password = value,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: RaisedButton(
                  elevation: 5.0,
                  child: Text('Register'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      submitForm();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
