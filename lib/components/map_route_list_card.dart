import 'package:canoe_trip_planner/models/map_route.dart';
import 'package:flutter/material.dart';

import 'map_route_list_tile.dart';

class MapRouteListCard extends StatelessWidget {
  final MapRoute mapRoute;
  final Function onTap;
  final Function onLongPress;
  final Function onTapDown;

  MapRouteListCard(
      {this.mapRoute, this.onTap, this.onLongPress, this.onTapDown});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(88, 89, 80, .9)),
        child: MapRouteListTile(
          mapRoute: mapRoute,
          onTap: onTap,
          onLongPress: onLongPress,
          onTapDown: onTapDown,
        ),
      ),
    );
  }
}
