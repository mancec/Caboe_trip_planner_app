import 'package:canoe_trip_planner/screens/Authentication/company_registration_screen.dart';
import 'package:canoe_trip_planner/screens/Company/Profile/company_profile_edit_screen.dart';
import 'package:canoe_trip_planner/screens/Company/company_map_create_screen.dart';
import 'package:canoe_trip_planner/screens/Company/company_map_list_screen.dart';
import 'file:///C:/UniStuff/Bakalauras/canoe_trip_planner%20-%20Copy/lib/screens/Company/Shared/company_map_route_detail_shared.dart';
import 'package:canoe_trip_planner/screens/Company/company_post_create_screen.dart';
import 'package:canoe_trip_planner/screens/RouteMaps/Shared/map_route_information_screen.dart';
import 'file:///C:/UniStuff/Bakalauras/canoe_trip_planner%20-%20Copy/lib/screens/Company/Profile/company_profile_screen.dart';
import 'package:canoe_trip_planner/screens/RouteMaps/map_route_detail_shared_screen.dart';
import 'package:canoe_trip_planner/screens/RouteMaps/user_map_list_screen.dart';
import 'package:canoe_trip_planner/screens/TripPlan/trip_plan_create_screen.dart';
import 'package:canoe_trip_planner/screens/TripPlan/trip_plan_list_screen.dart';
import 'package:canoe_trip_planner/screens/TripPlan/trip_plan_saved_list_Screen.dart';
import 'package:canoe_trip_planner/screens/TripPlan/trip_plan_time_create_screen.dart';
import 'package:canoe_trip_planner/screens/User/user_profile_screen.dart';
import 'package:canoe_trip_planner/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:canoe_trip_planner/screens/login_screen.dart';
import 'package:canoe_trip_planner/provider/auth_provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/Authentication/registration_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/RouteMaps/map_create_screen.dart';
import 'screens/RouteMaps/Shared/map_list_screen.dart';
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
    return OverlaySupport.global(
        child: MaterialApp(
      title: 'MapRoute Routes',
      theme: ThemeData(
          dividerTheme: DividerThemeData(
              color: kLightBackground,
              thickness: 2,
              indent: 25,
              endIndent: 25)),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        MapCreateScreen.id: (context) => MapCreateScreen(),
        MapRouteListView.id: (context) => MapRouteListView(),
        MapRouteDetailScreen.id: (context) => MapRouteDetailScreen(),
        UserMapListScreen.id: (context) => UserMapListScreen(),
        CompanyPostCreateScreen.id: (context) => CompanyPostCreateScreen(),
        CompanyMapCreateScreen.id: (context) => CompanyMapCreateScreen(),
        CompanyMapListScreen.id: (context) => CompanyMapListScreen(),
        CompanyProfileScreen.id: (context) => CompanyProfileScreen(),
        UserProfileScreen.id: (context) => UserProfileScreen(),
        CompanyMapDetailSharedScreen.id: (context) =>
            CompanyMapDetailSharedScreen(),
        MapRouteDetailSharedScreen.id: (context) =>
            MapRouteDetailSharedScreen(),
        CompanyRegistrationScreen.id: (context) => CompanyRegistrationScreen(),
        CompanyProfileEditScreen.id: (context) => CompanyProfileEditScreen(),
        TripPlanListScreen.id: (context) => TripPlanListScreen(),
        MapRouteInformationScreen.id: (context) => MapRouteInformationScreen(),
        TripPlanCreateScreen.id: (context) => TripPlanCreateScreen(),
        TripPlanTimeCreateScreen.id: (context) => TripPlanTimeCreateScreen(),
        TripPlanSavedListScreen.id: (context) => TripPlanSavedListScreen(),
      },
      home: WelcomeScreen(),
    ));
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
