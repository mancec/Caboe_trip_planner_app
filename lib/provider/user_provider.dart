import 'package:canoe_trip_planner/enums/viewstate.dart';
import 'package:canoe_trip_planner/models/user.dart';
import 'package:canoe_trip_planner/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:canoe_trip_planner/utils/constants.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:canoe_trip_planner/networking/api_base_helper.dart';
import 'package:canoe_trip_planner/enums/user_role.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../locator.dart';

class UserProvider extends ChangeNotifier {
  UserRepository _api = locator<UserRepository>();
  User user;
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  void set state(ViewState newState) {
    _state = newState;
  }

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  Future<bool> getUser() async {
    setState(ViewState.Busy);
    user = await _api.fetchUser();
    setState(ViewState.Idle);
  }
}
