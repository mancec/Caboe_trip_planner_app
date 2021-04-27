import 'dart:convert';

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

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  int _statusCode;

  bool get isAuthenticated => _isAuthenticated;
  int get statusCode => _statusCode;
  UserRole _userRole = UserRole.guest;
  UserRole get userRole => _userRole;
  String name;

  Future<bool> login(String email, String password) async {
    final response = await http.post('$baseUrl/login', body: {
      'email': email,
      'password': password,
      'device_name': await getDeviceId(),
    }, headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      _statusCode = response.statusCode;
      Map<String, dynamic> responseJson = json.decode(response.body);
      Map<String, dynamic> payload = Jwt.parseJwt(responseJson['token']);
      name = payload['name'];
      int i = 0;
      while (payload['roles'].asMap().containsKey(i)) {
        if (payload['roles'][i] == 'company') {
          _userRole = UserRole.company;
          i++;
        } else {
          i++;
        }
      }
      await saveToken(responseJson['token']);
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }

    if (response.statusCode == 422) {
      return false;
    }

    return false;
  }

  Future<bool> register(String email, String password, String name,
      String _confirmedEmail, bool isCompany) async {
    dynamic url = '$baseUrl/register';
    if (isCompany) {
      url = '$baseUrl/registerCompany/1';
    }
    final response = await http.post(url, body: {
      'email': email,
      'password': password,
      'name': name,
      'confirmed_email': _confirmedEmail,
    }, headers: {
      'Accept': 'application/json',
    });
    _statusCode = response.statusCode;
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      await saveToken(responseJson['token']);
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }

    if (response.statusCode == 422) {
      return false;
    }

    return false;
  }

  getDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        return build.androidId;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        return data.identifierForVendor;
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Bearer', token);
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('Bearer');
  }

  logout() async {
    _isAuthenticated = false;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
