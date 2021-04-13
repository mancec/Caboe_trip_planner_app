import 'package:canoe_trip_planner/components/mapRoutelist_item.dart';
import 'package:canoe_trip_planner/enums/viewstate.dart';
import 'package:canoe_trip_planner/models/map_route.dart';
import 'package:canoe_trip_planner/provider/map_route_provider.dart';
import 'package:canoe_trip_planner/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';
import 'map_route_detail_screen.dart';

class UserMapListScreen extends StatefulWidget {
  static const String id = 'user_map_list_screen';
  @override
  _UserMapListScreenState createState() => _UserMapListScreenState();
}

class _UserMapListScreenState extends State<UserMapListScreen> {
  MapRouteProvider model = locator<MapRouteProvider>();

  @override
  void initState() {
    model.getUserMapRoutes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapRouteProvider>(
      create: (context) => model,
      child: Consumer<MapRouteProvider>(builder: (context, model, child) {
        return Scaffold(
            appBar: AppBar(),
            backgroundColor: backgroundColor,
            body: model.state == ViewState.Busy
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Center(
                          child: Text(
                            'River Maps',
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      Expanded(child: getPostsUi(model.mapRoutes)),
                    ],
                  ));
      }),
    );
  }

  Widget getPostsUi(List<MapRoute> mapRoutes) => ListView.builder(
      itemCount: mapRoutes.length,
      itemBuilder: (context, index) => mapRouteListItem(
            mapRoute: mapRoutes[index],
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MapRouteDetailScreen(mapId: mapRoutes[index].id);
              }));
            },
          ));
}
