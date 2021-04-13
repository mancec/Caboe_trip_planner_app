import 'package:canoe_trip_planner/screens/RouteMaps/user_map_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:canoe_trip_planner/screens/login_screen.dart';
import 'package:canoe_trip_planner/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'screens/Authentication/login.dart';
import 'screens/login_screen.dart';
import 'screens/Authentication/registration_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/RouteMaps/map_create_screen.dart';
import 'screens/RouteMaps/map_list_screen.dart';
import 'locator.dart';
import 'package:canoe_trip_planner/screens/RouteMaps/map_route_detail_screen.dart';

void main() {
  setupLocator();
  runApp(ChangeNotifierProvider(
    create: (BuildContext context) => AuthProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MapRoute Routes',
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        MapCreateScreen.id: (context) => MapCreateScreen(),
        MapRouteListView.id: (context) => MapRouteListView(),
        MapRouteDetailScreen.id: (context) => MapRouteDetailScreen(),
        UserMapListScreen.id: (context) => UserMapListScreen()
      },
      home: WelcomeScreen(),
    );
  }
}

// void main() {
//   runApp(
//     MultiProvider(
//       providers: providers,
//       child: MyApp(),
//     ),
//   );
// }
//
// List<SingleChildWidget> providers = [
//   ChangeNotifierProvider<PostDataProvider>(create: (_) => PostDataProvider()),
// ];
