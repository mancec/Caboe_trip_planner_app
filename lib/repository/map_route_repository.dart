import 'package:canoe_trip_planner/networking/api_base_helper.dart';
import 'package:canoe_trip_planner/models/map_route.dart';
import 'dart:convert';

class MapRouteRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<MapRoute>> fetchMapRouteList() async {
    var mapRoutes = List<MapRoute>();

    var response = await _helper.get("/mapRoute");
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

  Future<List<MapRoute>> saveMapRouteList(MapRoute mapRoute) async {
    var mapRoutes = <MapRoute>[];
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

    return mapRoutes;
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
