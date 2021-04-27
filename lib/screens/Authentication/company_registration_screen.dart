import 'file:///C:/UniStuff/Bakalauras/canoe_trip_planner%20-%20Copy/lib/screens/Company/Profile/company_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import 'package:canoe_trip_planner/screens/welcome_screen.dart';

class CompanyRegistrationScreen extends StatefulWidget {
  static const String id = 'company_registration_screen';
  const CompanyRegistrationScreen({
    Key key,
  }) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<CompanyRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = 'mantas@cece.com';
  String _password = "secret123";
  String _errorMessage = '';
  String _name = "mantas";
  String _confirmedEmail = 'mantas@cece.com';

  Future<void> submitForm() async {
    setState(() {
      _errorMessage = '';
    });
    bool result = await Provider.of<AuthProvider>(context, listen: false)
        .register(_email, _password, _name, _confirmedEmail, true);
    if (result == false) {
      setState(() {
        _errorMessage =
            'There was a problem with your registration credentials.';
      });
    } else if (Provider.of<AuthProvider>(context, listen: false).statusCode ==
        200) {
      bool result = await Provider.of<AuthProvider>(context, listen: false)
          .login(_email, _password);
      if (result == false) {
        setState(() {
          _errorMessage = 'There was a problem with your credentials.';
        });
      } else {
        Navigator.pushNamed(context, CompanyProfileScreen.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Canoe planner')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              TextFormField(
                initialValue: _name ?? '',
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
                initialValue: _email ?? '',
                decoration: InputDecoration(
                    hintText: 'Email',
                    icon: Icon(
                      Icons.mail,
                    )),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value.isEmpty ? 'Please enter an email address' : null,
                onSaved: (value) => _email = value,
              ),
              TextFormField(
                initialValue: _confirmedEmail ?? '',
                decoration: InputDecoration(
                    hintText: 'Email confirmation',
                    icon: Icon(
                      Icons.mail,
                    )),
                validator: (value) =>
                    value.isEmpty ? 'Please confirm your email address' : null,
                onSaved: (value) => _confirmedEmail = value,
              ),
              TextFormField(
                initialValue: _password ?? '',
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
