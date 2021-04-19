import 'package:canoe_trip_planner/enums/user_role.dart';
import 'package:canoe_trip_planner/screens/Authentication/registration_screen.dart';
import 'package:canoe_trip_planner/screens/Company/company_map_list_screen.dart';
import 'package:canoe_trip_planner/screens/Company/company_post_create_screen.dart';
import 'package:canoe_trip_planner/screens/Company/company_profile_screen.dart';
import 'package:canoe_trip_planner/screens/RouteMaps/map_create_screen.dart';
import 'package:canoe_trip_planner/screens/RouteMaps/map_list_screen.dart';
import 'package:canoe_trip_planner/screens/RouteMaps/user_map_list_screen.dart';
import 'package:canoe_trip_planner/screens/login_screen.dart';
import 'package:canoe_trip_planner/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:canoe_trip_planner/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class AppBarMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              // image: DecorationImage(
              //   fit: BoxFit.fill,
              //    image: AssetImage('assets/images/cover.jpg'),
              // ),
            ),
          ),
          if (Provider.of<AuthProvider>(context).userRole == UserRole.company)
            ListTile(
              leading: Icon(Icons.add_location_alt_rounded),
              title: Text('Create a company route'),
              onTap: () => {
                Navigator.pushNamed(context, CompanyPostScreen.id),
              },
            ),
          ListTile(
            leading: Icon(Icons.add_location_alt_rounded),
            title: Text('Company profile'),
            onTap: () => {
              Navigator.pushNamed(context, CompanyProfileScreen.id),
            },
          ),
          if (Provider.of<AuthProvider>(context).userRole == UserRole.company)
            ListTile(
              leading: Icon(Icons.add_location_alt_rounded),
              title: Text('My company offers'),
              onTap: () => {
                Navigator.pushNamed(context, CompanyMapListScreen.id),
              },
            ),
          if (Provider.of<AuthProvider>(context).isAuthenticated)
            ListTile(
              leading: Icon(Icons.add_location_alt_rounded),
              title: Text('Create paddling route'),
              onTap: () => {
                Navigator.pushNamed(context, MapCreateScreen.id),
              },
            ),
          if (Provider.of<AuthProvider>(context).isAuthenticated)
            ListTile(
              leading: Icon(Icons.article),
              title: Text('My paddling routes'),
              onTap: () => {
                Navigator.pushNamed(context, UserMapListScreen.id),
              },
            ),
          if (Provider.of<AuthProvider>(context).isAuthenticated)
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () => {
                Navigator.pushNamed(context, 'doctor_list_screen'),
              },
            ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Canoe paddling routes'),
            onTap: () => {Navigator.pushNamed(context, MapRouteListView.id)},
          ),
          if (!Provider.of<AuthProvider>(context).isAuthenticated)
            ListTile(
              leading: Icon(Icons.assignment_turned_in_sharp),
              title: Text('Log in'),
              onTap: () => {Navigator.pushNamed(context, LoginScreen.id)},
            ),
          if (!Provider.of<AuthProvider>(context).isAuthenticated)
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Registration'),
              onTap: () =>
                  {Navigator.pushNamed(context, RegistrationScreen.id)},
            ),
          if (Provider.of<AuthProvider>(context).isAuthenticated)
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () => {
                Provider.of<AuthProvider>(context, listen: false).logout(),
                Navigator.pushNamed(context, LoginScreen.id),
              },
            ),
        ],
      ),
    );
  }
}
