import 'package:canoe_trip_planner/components/appBarMenu.dart';
import 'package:canoe_trip_planner/utils/constants.dart';
import 'package:flutter/material.dart';
import 'Authentication/company_registration_screen.dart';
import 'RouteMaps/user_map_list_screen.dart';
import 'login_screen.dart';
import 'Authentication/registration_screen.dart';
import 'package:canoe_trip_planner/components/roundedButton.dart';
import 'RouteMaps/map_create_screen.dart';
import 'RouteMaps/Shared/map_list_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[Text('Kayaking planner')])),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Hero(
                      tag: 'logo',
                      child: Container(
                        child: Image(
                            color: kLogoColor,
                            image: AssetImage(
                                'assets/logo/outline_kayaking_black_48.png')),
                        height: 90.0,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Kayaking Planner',
                      style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ]),
              SizedBox(
                height: 48.0,
              ),
              RoundedButton(
                  title: 'Paddling Routes',
                  colour: Colors.blueAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, MapRouteListView.id);
                  }),
              RoundedButton(
                title: 'Log In',
                colour: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        child: Text(
                          "Register as a user",
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 17),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, RegistrationScreen.id);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        child: Text("Register as a company",
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 17)),
                        onTap: () {
                          Navigator.pushNamed(
                              context, CompanyRegistrationScreen.id);
                        },
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
