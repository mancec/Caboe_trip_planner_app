import 'package:canoe_trip_planner/models/company.dart';
import 'package:canoe_trip_planner/models/company_map_route.dart';
import 'package:canoe_trip_planner/networking/api_base_helper.dart';
import 'package:canoe_trip_planner/models/map_route.dart';
import 'dart:convert';

class MapRouteRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<MapRoute>> fetchMapRouteList() async {
    var mapRoutes = List<MapRoute>();

    var response = await _helper.get("/mapRouteUser");
    var parsed = response as List<dynamic>;

    for (var mapRoute in parsed) {
      mapRoutes.add(MapRoute.fromJsonWithoutCoordinates(mapRoute));
    }

    return mapRoutes;
  }

  Future<List<MapRoute>> fetchUserMapRouteList() async {
    var mapRoutes = List<MapRoute>();

    var response = await _helper.get("/mapRouteUser");
    var parsed = response as List<dynamic>;

    for (var mapRoute in parsed) {
      mapRoutes.add(MapRoute.fromJsonWithoutCoordinates(mapRoute));
    }

    return mapRoutes;
  }

  Future<MapRoute> fetchMapRoute(int id) async {
    var mapRoute = MapRoute();

    var response = await _helper.get("/mapRoute/$id");

    mapRoute = (MapRoute.fromJsonWithCoordinates(response));

    return mapRoute;
  }

  Future saveMapRouteList(MapRoute mapRoute) async {
    // print(jsonEncode(mapRoute.polyline.map((e) => e.toJson()).toList()));
    printWrapped(jsonEncode(mapRoute.polyline.map((e) => e.toJson()).toList()));
    var response = await _helper.post("/mapRoute", {
      // 'polyline': jsonEncode(mapRoute.polyline.map((e) => e.toJson()).toList()),
      'polyline': jsonEncode(mapRoute.polyline),
      'title': mapRoute.title,
      'author': mapRoute.author,
      'description': mapRoute.description,
      'pName': 'default'
    });
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future saveCompanyMapRoute(CompanyMapRoute companyMapRoute, String title,
      String description, String author) async {
    printWrapped(
        jsonEncode(companyMapRoute.polyline.map((e) => e.toJson()).toList()));
    print("to json");
    print(companyMapRoute.toJson(title, description, author));
    var response = await _helper.post(
        "/companyMapRoute", companyMapRoute.toJson(title, description, author));
  }

  Future<List<CompanyMapRoute>> fetchCompanyMapRouteList() async {
    var mapRoutes = List<CompanyMapRoute>();

    var response = await _helper.get("/companyMapRoute");
    var parsed = response as List<dynamic>;

    for (var mapRoute in parsed) {
      mapRoutes.add(CompanyMapRoute.fromJsonWithoutCoordinates(mapRoute));
    }

    return mapRoutes;
  }

  Future<CompanyMapRoute> fetchCompanyMapRoute(int id) async {
    var companyMapRoute = CompanyMapRoute();

    var response = await _helper.get("/companyMapRoute/$id");

    companyMapRoute =
        CompanyMapRoute.fromJsonWithoutCoordinatesSingle(response);

    return companyMapRoute;
  }

  Future<CompanyMapRoute> fetchCompanyMapRouteCoordinates(int id) async {
    var companyMapRoute = CompanyMapRoute();

    var response = await _helper.get("/companyMapRoute/$id");

    companyMapRoute = CompanyMapRoute.fromJsonWithCoordinates(response);

    return companyMapRoute;
  }

  Future saveCompanyProfile(Company company) async {
    print("to json");
    company.toJson();
    var response = await _helper.post("/company", company.toJson());
  }

  Future<Company> getCompanyProfile() async {
    var company = Company();

    var response = await _helper.get("/company");

    company = Company.fromJsonWithoutCoordinates(response);

    return company;
  }
}
