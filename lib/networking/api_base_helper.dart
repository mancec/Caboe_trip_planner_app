import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:canoe_trip_planner/networking/api_exceptions.dart';
import 'dart:async';
import 'package:canoe_trip_planner/provider/auth_provider.dart';
import 'package:canoe_trip_planner/locator.dart';

const String baseUrl = "https://7e0d20639349.ngrok.io/api";

class ApiBaseHelper {
  Future<dynamic> get(String url) async {
    AuthProvider auth = locator<AuthProvider>();
    print('Api Get, url $url');
    String token;
    await auth.getToken().then((String result) {
      token = result;
    });
    var responseJson;
    if (token != null) {
      print("su tokenu");
      String Bearer = 'Bearer ' + token;
      try {
        final response =
            await http.get(baseUrl + url, headers: {'Authorization': Bearer});
        responseJson = _returnResponse(response);
      } on SocketException {
        print('No net');
        throw FetchDataException('No Internet connection');
      }
    } else {
      try {
        final response = await http.get(baseUrl + url);
        responseJson = _returnResponse(response);
      } on SocketException {
        print('No net');
        throw FetchDataException('No Internet connection');
      }
    }
    print('api get recieved!');
    return responseJson;
  }

  Future<dynamic> post(String url, dynamic body) async {
    AuthProvider auth = locator<AuthProvider>();
    print('Api Post, url $url');
    String token;
    await auth.getToken().then((String result) {
      token = result;
    });
    var responseJson;
    try {
      print(baseUrl + url);
      print("siuntimas");
      print(body);
      print(token);
      final response = await http.post(baseUrl + url,
          headers: {'Authorization': 'Bearer' + token}, body: body);
      print('issiusta');
      print(response.statusCode);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api post.');
    return responseJson;
  }

  Future<dynamic> put(String url, dynamic body) async {
    AuthProvider auth = locator<AuthProvider>();
    String token;
    await auth.getToken().then((String result) {
      token = result;
    });
    print('Api Put, url $url');
    var responseJson;
    try {
      final response = await http.put(baseUrl + url,
          headers: {'Authorization': 'Bearer' + token}, body: body);
      print('issiusta');
      print(response);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api put.');
    print(responseJson.toString());
    return responseJson;
  }

  Future<dynamic> delete(String url) async {
    AuthProvider auth = locator<AuthProvider>();
    String token;
    await auth.getToken().then((String result) {
      token = result;
    });
    print('Api delete, url $url');
    var apiResponse;
    try {
      final response = await http
          .delete(baseUrl + url, headers: {'Authorization': 'Bearer' + token});
      apiResponse = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api delete.');
    return apiResponse;
  }
}

dynamic _returnResponse(http.Response response) {
  print('kodas');
  print(response.statusCode);
  switch (response.statusCode) {
    case 200:
      if (response.body.isNotEmpty) {
        var responseJson = json.decode(response.body);
        return responseJson;
      }
      return null;
    case 422:
      if (response.body.isNotEmpty) {
        var responseJson = json.decode(response.body);
        return responseJson;
      }
      return null;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}
