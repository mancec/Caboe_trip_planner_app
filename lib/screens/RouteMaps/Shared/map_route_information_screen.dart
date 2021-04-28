import 'package:canoe_trip_planner/components/alert_dialog.dart';
import 'package:canoe_trip_planner/components/roundedButton.dart';
import 'package:canoe_trip_planner/enums/user_role.dart';
import 'package:canoe_trip_planner/enums/viewstate.dart';
import 'package:canoe_trip_planner/models/canoe_price.dart';
import 'package:canoe_trip_planner/provider/auth_provider.dart';
import 'package:canoe_trip_planner/provider/company_map_route_provider.dart';
import 'package:canoe_trip_planner/provider/map_route_provider.dart';
import 'package:canoe_trip_planner/provider/trip_plan_provider.dart';
import 'package:canoe_trip_planner/screens/Company/company_map_list_screen.dart';
import 'package:canoe_trip_planner/screens/RouteMaps/map_route_detail_screen.dart';
import 'package:canoe_trip_planner/screens/RouteMaps/user_map_list_screen.dart';
import 'package:canoe_trip_planner/screens/RouteMaps/user_map_route_edit_screen.dart';
import 'package:canoe_trip_planner/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:canoe_trip_planner/utils/helper.dart';

import '../../../locator.dart';

class MapRouteInformationScreen extends StatefulWidget {
  static const String id = 'map_route_information_screen';
  MapRouteInformationScreen({this.mapId});

  final int mapId;
  @override
  _MapRouteInformationScreenState createState() =>
      _MapRouteInformationScreenState();
}

class _MapRouteInformationScreenState extends State<MapRouteInformationScreen> {
  MapRouteProvider mapRouteProvider = locator<MapRouteProvider>();
  TripPlanProvider tripPlanProvider = locator<TripPlanProvider>();

  @override
  void initState() {
    mapRouteProvider.getMapRoute(widget.mapId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapRouteProvider>(
      create: (context) => mapRouteProvider,
      child: Consumer<MapRouteProvider>(builder: (context, route, child) {
        return Scaffold(
            appBar: AppBar(),
            backgroundColor: backgroundColor,
            body: mapRouteProvider.state == ViewState.Busy
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                        child: Center(
                          child: Text(
                            route.mapRoute.title.capitalizeFirstofEach,
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Center(
                          child: Text(
                            "Route Information",
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                      Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Text('Description:')),
                      Padding(
                          padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                          child: Text(route.mapRoute.description.inCaps)),
                      Padding(
                          padding:
                              EdgeInsets.only(left: 20, bottom: 20, top: 10),
                          child: Text("By: " + route.mapRoute.author)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, //Center Row contents horizontally,,
                        crossAxisAlignment: CrossAxisAlignment
                            .center, //Center Row contents vertically,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 12,
                            ),
                            child: Center(
                              child: RoundedButton(
                                  title: 'Go To Route',
                                  colour: Color.fromRGBO(61, 90, 254, 192),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return MapRouteDetailScreen(
                                          mapId: route.mapRoute.id);
                                    }));
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            floatingActionButton: Provider.of<AuthProvider>(context)
                    .isAuthenticated
                ? SpeedDial(animatedIcon: AnimatedIcons.menu_close, children: [
                    SpeedDialChild(
                        child: Icon(Icons.add),
                        label: "Add To Trip Plan",
                        onTap: () {
                          tripPlanProvider
                              .addUserTripPlan(route.mapRoute.id)
                              .then((value) {
                            if (tripPlanProvider.response_code == 200) {
                              showSimpleNotification(
                                  Text("Route added to your plan"),
                                  duration: Duration(milliseconds: 2000),
                                  background: kLightBackground);
                            } else {
                              showSimpleNotification(
                                  Text("Route already added to your trip plan"),
                                  duration: Duration(milliseconds: 2000),
                                  background: kLightBackground);
                            }
                          });
                        }),
                  ])
                : null);
      }),
    );
  }
}
