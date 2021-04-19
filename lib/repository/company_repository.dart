import 'package:canoe_trip_planner/models/company.dart';
import 'package:canoe_trip_planner/models/company_map_route.dart';
import 'package:canoe_trip_planner/networking/api_base_helper.dart';
import 'package:canoe_trip_planner/models/map_route.dart';
import 'dart:convert';

class CompanyRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future saveCompanyProfile(Company companyProfile) async {
    print("company profile post");
    companyProfile.toJson();
    // printWrapped(
    //     jsonEncode(companyMapRoute.polyline.map((e) => e.toJson()).toList()));
    // print("to json");
    // var response = await _helper.post(
    //     "/companyProfile", companyMapRoute.toJson(title, description, author));
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
