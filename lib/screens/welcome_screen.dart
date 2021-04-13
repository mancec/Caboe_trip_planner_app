import 'package:canoe_trip_planner/components/appBarMenu.dart';
import 'package:flutter/material.dart';
import 'RouteMaps/user_map_list_screen.dart';
import 'login_screen.dart';
import 'Authentication/registration_screen.dart';
import 'package:canoe_trip_planner/components/roundedButton.dart';
import 'RouteMaps/map_create_screen.dart';
import 'RouteMaps/map_list_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Canoe planner')),
      drawer: AppBarMenu(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    // child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                Text(
                  'Canoe Planner',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Log In',
              colour: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              title: 'Register',
              colour: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
            RoundedButton(
              title: 'Map',
              colour: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, MapCreateScreen.id);
              },
            ),
            RoundedButton(
              title: 'MapList',
              colour: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, MapRouteListView.id);
              },
            ),
            RoundedButton(
              title: 'UserMapList',
              colour: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, UserMapListScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
