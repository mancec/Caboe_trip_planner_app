import 'package:canoe_trip_planner/components/roundedButton.dart';
import 'package:canoe_trip_planner/enums/user_role.dart';
import 'package:canoe_trip_planner/enums/viewstate.dart';
import 'package:canoe_trip_planner/models/user.dart';
import 'package:canoe_trip_planner/provider/auth_provider.dart';
import 'package:canoe_trip_planner/provider/user_provider.dart';
import 'file:///C:/UniStuff/Bakalauras/canoe_trip_planner%20-%20Copy/lib/screens/Company/Profile/company_profile_edit_screen.dart';
import 'package:canoe_trip_planner/screens/User/user_profile_edit_screen.dart';
import 'package:canoe_trip_planner/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  static const String id = 'user_profile_screen';
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  User user = User();
  UserProvider userProvider = UserProvider();

  @override
  void initState() {
    userProvider.getUser().then((value) => print(userProvider.user.name));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
        create: (context) => userProvider,
        child: Consumer<UserProvider>(builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(),
            backgroundColor: kLightBackground,
            body: model.state == ViewState.Busy
                ? Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                              AssetImage('assets/profile_image.jpg'),
                        ),
                        Text(
                          model.user.name,
                          style: TextStyle(
                            fontFamily: 'Pacifico',
                            fontSize: 40.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontFamily: 'Source Sans Pro',
                            color: Colors.teal.shade100,
                            fontSize: 20.0,
                            letterSpacing: 2.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                          width: 150.0,
                          child: Divider(
                            color: Colors.teal.shade100,
                          ),
                        ),
                        Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 25.0),
                            child: ListTile(
                              leading: Icon(
                                Icons.email,
                                color: Colors.teal,
                              ),
                              title: Text(
                                model.user.email,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.teal.shade900,
                                    fontFamily: 'Source Sans Pro'),
                              ),
                            )),
                        RoundedButton(
                            title: 'Edit Profile',
                            colour: Colors.blueAccent,
                            onPressed: () => Navigator.pushNamed(
                                context, UserProfileEditScreen.id))
                      ],
                    ),
                  )),
          );
        }));
  }
}
