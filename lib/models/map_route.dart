import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:canoe_trip_planner/utils/decoder.dart';

class MapRoute {
  int id;
  String title;
  String author;
  List<LatLng> polyline = [];
  String description;
  MapRoute({this.id, this.title, this.author, this.polyline, this.description});

  MapRoute.addPolyline(LatLng coordinates) {
    polyline.add(coordinates);
  }

  MapRoute.fromJsonWithoutCoordinates(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    author = json['author'];
  }

  MapRoute.fromJsonWithCoordinates(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    author = json['author'];
    var arr = [];
    var polylines = json['polyline'][0]['cLat'];

    int i = 0;
    while (json['polyline'].asMap().containsKey(i)) {
      polyline.add(LatLng(double.parse(json['polyline'][i]['cLat']),
          double.parse(json['polyline'][i]['cLng'])));
      i++;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['author'] = this.author;
    data['polyline'] = this.polyline;
    return data;
  }
}
