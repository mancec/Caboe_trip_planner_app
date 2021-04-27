import 'package:canoe_trip_planner/models/user.dart';
import 'package:canoe_trip_planner/networking/api_base_helper.dart';
import 'package:canoe_trip_planner/models/map_route.dart';
import 'dart:convert';

class UserRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<User> fetchUser() async {
    User user = User();

    var response = await _helper.get("/user");

    user = User.fromJson(response);

    return user;
  }
}
