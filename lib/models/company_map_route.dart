import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:canoe_trip_planner/utils/decoder.dart';

import 'canoe_price.dart';

class CompanyMapRoute {
  int id;
  List<LatLng> polyline = [];
  String contactEmail;
  String canoeSeatCount;
  String cost;
  String address;
  String workHours;
  String contactNumber;
  List<CanoePrice> canoePrice = [];

  CompanyMapRoute(
      {this.id,
      this.polyline,
      this.contactEmail,
      this.cost,
      this.address,
      this.workHours,
      this.contactNumber,
      this.canoePrice});

  CompanyMapRoute.addPolyline(LatLng coordinates) {
    polyline.add(coordinates);
  }

  CompanyMapRoute.fromJsonWithoutCoordinates(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    contactEmail = json['address'];
    workHours = json['address'];
    contactNumber = json['address'];
    print(json['id']);
    print(json);
  }

  CompanyMapRoute.fromJsonWithoutCoordinatesSingle(Map<String, dynamic> json) {
    id = json['companyRoute']['id'];
    address = json['companyRoute']['address'];
    contactEmail = json['companyRoute']['contact_email'];
    workHours = json['companyRoute']['work_hours'];
    contactNumber = json['companyRoute']['contact_number'];

    int i = 0;
    while (json['companyRoute']['canoe_cost'].asMap().containsKey(i)) {
      canoePrice
          .add(CanoePrice.fromJson(json['companyRoute']['canoe_cost'][i]));
      i++;
    }
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
