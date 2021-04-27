import 'package:canoe_trip_planner/models/map_route.dart';
import 'package:flutter/material.dart';

class MapRouteListTile extends StatelessWidget {
  final MapRoute mapRoute;
  final Function onTap;
  final Function onLongPress;
  final Function onTapDown;

  MapRouteListTile(
      {this.mapRoute, this.onTap, this.onLongPress, this.onTapDown});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onLongPress: onLongPress,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.map, color: Colors.white),
        ),
        title: Text(
          mapRoute.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  child: LinearProgressIndicator(
                      backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                      value: 0.9,
                      valueColor: AlwaysStoppedAnimation(Colors.red)),
                )),
            Expanded(
              flex: 4,
              child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(mapRoute.author,
                      style: TextStyle(color: Colors.white))),
            )
          ],
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: onTap,
      ),
    );
  }
}
