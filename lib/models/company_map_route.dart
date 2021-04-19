import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:canoe_trip_planner/utils/decoder.dart';

class CompanyMapRoute {
  int id;
  List<LatLng> polyline = [];
  String contactEmail;
  String canoeSeatCount;
  String cost;
  String address;
  String workHours;
  String contactNumber;

  CompanyMapRoute(
      {this.id,
      this.polyline,
      this.canoeSeatCount,
      this.contactEmail,
      this.cost,
      this.address,
      this.workHours,
      this.contactNumber});

  // CompanyMapRoute(int id, String title, List<LatLng> polyline,
  //     String description, String companyName, String contactEmail) {
  //   this.id = id;
  //   this.title = title;
  //   this.polyline = polyline;
  //   this.description = description;
  //   this.companyName = companyName;
  //   this.contactEmail = contactEmail;
  // }

  CompanyMapRoute.addPolyline(LatLng coordinates) {
    polyline.add(coordinates);
  }

  CompanyMapRoute.fromJsonWithoutCoordinates(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    print(json['id']);
    print(json);
  }

  CompanyMapRoute.fromJsonWithoutCoordinatesSingle(Map<String, dynamic> json) {
    id = json['mapRoute']['id'];
    address = json['mapRoute']['address'];
  }

  CompanyMapRoute.fromJsonWithCoordinates(Map<String, dynamic> json) {
    id = json['id'];
    contactEmail = json['contactEmail'];
    canoeSeatCount = json['canoeSeatCount'];
    cost = json['cost'];
    address = json['address'];

    int i = 0;
    while (json['polyline'].asMap().containsKey(i)) {
      polyline.add(LatLng(double.parse(json['polyline'][i]['cLat']),
          double.parse(json['polyline'][i]['cLng'])));
      i++;
    }
  }

  Map<String, dynamic> toJson(String title, String description, String author) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['polyline'] = jsonEncode(this.polyline);
    data['contact_email'] = this.contactEmail;
    data['canoe_seat_count'] = this.canoeSeatCount;
    data['cost'] = this.cost;
    data['address'] = this.address;
    data['work_hours'] = this.workHours;
    data['contact_number'] = this.contactNumber;
    data['title'] = title;
    data['description'] = description;
    data['author'] = author;
    data['polylineName'] = "test";
    return data;
  }
}
