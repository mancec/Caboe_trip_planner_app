import 'package:canoe_trip_planner/models/company.dart';
import 'package:canoe_trip_planner/models/company_map_route.dart';
import 'package:canoe_trip_planner/networking/api_base_helper.dart';
import 'package:canoe_trip_planner/models/map_route.dart';
import 'dart:convert';

class MapRouteRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future fetchMapRouteList(String page) async {
    var response = await _helper.getWithParam("/mapRoute", page);
    return response;
  }

  Future fetchUserMapRouteList(String page) async {
    var response = await _helper.getWithParam("/mapRouteUser", page);
    return response;
  }

  Future<MapRoute> fetchMapRoute(int id) async {
    var mapRoute = MapRoute();

    var response = await _helper.get("/mapRoute/$id");

    mapRoute = (MapRoute.fromJsonWithCoordinates(response));

    return mapRoute;
  }

  Future saveMapRouteList(MapRoute mapRoute) async {
    var response = await _helper.post("/mapRoute", {
      'polyline': jsonEncode(mapRoute.polyline),
      'title': mapRoute.title,
      'author': mapRoute.author,
      'description': mapRoute.description,
      'polylineName': 'default'
    });
  }

  Future editMapRoute(MapRoute mapRoute) async {
    int id = mapRoute.id;
    var response = await _helper.put("/mapRoute/$id", {
      'polyline': jsonEncode(mapRoute.polyline),
      'title': mapRoute.title,
      'author': mapRoute.author,
      'description': mapRoute.description,
      'polylineName': 'default'
    });

    return response;
  }

  Future deleteMapRoute(id) async {
    var response = await _helper.delete("/mapRoute/$id");
    return response;
  }

  // Company api calls

  Future fetchCompanyMapRouteList(String page) async {
    var response = await _helper.getWithParam("/companyMapRoute", page);
    return response;
  }

  Future saveCompanyMapRoute(CompanyMapRoute companyMapRoute, String title,
      String description, String author) async {
    print(companyMapRoute.toJson(title, description, author));
    var response = await _helper.post(
        "/companyMapRoute", companyMapRoute.toJson(title, description, author));
  }

  Future saveCompanyRoute(MapRoute mapRoute, Company company) async {
    var response = await _helper.post("/companyMapRoute", {
      'polyline': jsonEncode(mapRoute.polyline),
      'title': mapRoute.title,
      'author': mapRoute.author,
      'description': mapRoute.description,
      'pName': 'default',
      'contact_email': company.contactEmail,
      'address': company.address,
      'work_hours': company.workHours,
      'contact_number': company.contactNumber,
      'canoe_price': jsonEncode(company.canoePrice),
    });

    return response;
  }

  Future editCompanyRoute(MapRoute mapRoute, Company company) async {
    int id = mapRoute.id;
    var response = await _helper.put("/companyMapRoute/$id", {
      'polyline': jsonEncode(mapRoute.polyline),
      'title': mapRoute.title,
      'author': mapRoute.author,
      'description': mapRoute.description,
      'pName': 'default',
      'contact_email': company.contactEmail,
      'address': company.address,
      'work_hours': company.workHours,
      'contact_number': company.contactNumber,
      'canoe_price': jsonEncode(company.canoePrice),
    });

    return response;
  }

  Future deleteCompanyRoute(id) async {
    var response = await _helper.delete("/companyMapRoute/$id");
    return response;
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

  Future shareMapRoute(int id) async {
    var response = await _helper.post("/mapRouteShare/$id", {});
    return response;
  }

  Future removeSharedMapRoute(int id) async {
    var response = await _helper.delete("/mapRouteShare/$id");
    return response;
  }

  Future saveCompanyProfile(Company company) async {
    var response = await _helper.post("/company", company.toJson());
  }

  Future editCompanyProfile(Company company) async {
    var response = await _helper.put("/company", company.toJson());
  }

  Future<Company> getCompanyProfile() async {
    var company = Company();

    var response = await _helper.get("/company");
    print(response);

    company = Company.fromJsonProfile(response);

    return company;
  }

  //trip plans

  Future<List<MapRoute>> getTripPlanMapRoutes() async {
    var mapRoutes = List<MapRoute>();

    var response = await _helper.get("/tripPlanMapRoute");
    print(response['trip_plan']);
    var parsed = response['trip_plan'] as List<dynamic>;

    for (var mapRoute in parsed) {
      print("ciklas");
      mapRoutes.add(MapRoute.fromJsonTripPlans(mapRoute));
    }

    return mapRoutes;
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
