import 'package:canoe_trip_planner/models/company.dart';
import 'package:canoe_trip_planner/models/company_map_route.dart';
import 'package:canoe_trip_planner/networking/api_base_helper.dart';
import 'package:canoe_trip_planner/models/map_route.dart';
import 'dart:convert';

class CompanyRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  // Future fetchCompanyProfile() async {
  //   var company = Company();
  //
  //   var response = await _helper.get("/company");
  //
  //   company = Company.fromJsonProfile(response);
  //
  //   return company;
  // }
}
