import 'dart:convert';

import 'package:canoe_trip_planner/models/canoe_price.dart';
import 'package:canoe_trip_planner/models/company_map_route.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:canoe_trip_planner/utils/decoder.dart';

class Company {
  int id;
  String contactEmail;
  String address;
  String workHours;
  String contactNumber;
  List<CanoePrice> canoePrice = [];

  Company(
      {this.id,
      this.contactEmail,
      this.address,
      this.workHours,
      this.contactNumber,
      this.canoePrice});

  Company.fromJsonProfile(Map<String, dynamic> json) {
    id = json['id'];
    contactEmail = json['contact_email'];
    address = json['address'];
    workHours = json['work_hours'];
    contactNumber = json['contact_number'];

    int i = 0;
    while (json['canoe_cost'].asMap().containsKey(i)) {
      canoePrice.add(CanoePrice.fromJson(json['canoe_cost'][i]));
      i++;
    }
  }

  Company.fromJsonWithoutCoordinatesSingle(Map<String, dynamic> json) {
    id = json['mapRoute']['id'];
    address = json['mapRoute']['address'];
  }

  Company.fromJsonWithCoordinates(Map<String, dynamic> json) {
    id = json['id'];
    contactEmail = json['contactEmail'];
    address = json['address'];

    int i = 0;
    // while (json['polyline'].asMap().containsKey(i)) {
    //   polyline.add(LatLng(double.parse(json['polyline'][i]['cLat']),
    //       double.parse(json['polyline'][i]['cLng'])));
    //   i++;
    // }
  }
  Company.fromMapRoute(CompanyMapRoute companyMapRoute) {
    this.contactEmail = companyMapRoute.contactEmail;
    this.address = companyMapRoute.address;
    this.workHours = companyMapRoute.workHours;
    this.canoePrice = companyMapRoute.canoePrice;
    this.contactNumber = companyMapRoute.contactNumber;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contact_email'] = this.contactEmail;
    data['address'] = this.address;
    data['work_hours'] = this.workHours;
    data['contact_number'] = this.contactNumber;
    data['canoe_price'] =
        jsonEncode(this.canoePrice.map((e) => e.toJson()).toList());
    print(data);
    return data;
  }
}
