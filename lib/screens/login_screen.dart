import 'package:canoe_trip_planner/components/appBarMenu.dart';
import 'package:flutter/material.dart';
import 'package:canoe_trip_planner/components/roundedButton.dart';
import 'package:canoe_trip_planner/utils/constants.dart';
import 'package:canoe_trip_planner/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({
    Key key,
  }) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _errorMessage = '';

  Future<void> submitForm() async {
    setState(() {
      _errorMessage = '';
    });
    bool result = await Provider.of<AuthProvider>(context, listen: false)
        .login(_email, _password);
    if (result == false) {
      setState(() {
        _errorMessage = 'There was a problem with your credentials.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Canoe planner')),
      drawer: AppBarMenu(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: ListView(
            children: <Widget>[
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
                  child: Text('Login'),
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
