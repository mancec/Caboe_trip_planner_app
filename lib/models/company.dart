import 'dart:convert';

import 'package:canoe_trip_planner/models/canoe_price.dart';
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

  Company.fromJsonWithoutCoordinates(Map<String, dynamic> json) {
    id = json['id'];
    contactEmail = json['contect_email'];
    address = json['address'];
    workHours = json['work_hours'];
    contactNumber = json['contact_number'];
    canoePrice = json['contect_email'];
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contact_email'] = this.contactEmail;
    data['address'] = this.address;
    data['work_hours'] = this.workHours;
    data['contact_number'] = this.contactNumber;
    data['canoe_price'] =
        jsonEncode(canoePrice.map((e) => e.toJson()).toList());
    print(data);
    return data;
  }
}
