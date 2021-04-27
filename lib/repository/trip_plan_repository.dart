import 'package:canoe_trip_planner/models/map_route.dart';
import 'package:canoe_trip_planner/models/trip_plan.dart';
import 'package:canoe_trip_planner/networking/api_base_helper.dart';

class TripPlanRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future addUserTripPlan(int id) async {
    var response = await _helper.post("/mapRouteTrip/$id", {});

    return response;
  }

  Future<List<MapRoute>> getTripPlans() async {
    var mapRoutes = List<MapRoute>();

    var response = await _helper.get("/tripPlan");
    var parsed = response as List<dynamic>;

    for (var mapRoute in parsed) {
      mapRoutes.add(MapRoute.fromJsonWithoutCoordinates(mapRoute));
    }

    return mapRoutes;
  }

  Future getTripPlan(int id) async {
    var tripPlan = TripPlan();
    var response = await _helper.get("/tripPlan/$id");

    tripPlan = TripPlan.fromJson(response);

    return tripPlan;
  }

  Future addTripPlan(TripPlan tripPlan) async {
    print('send');
    var response = await _helper.post("/tripPlan", tripPlan.toJson());
    print("response");
    print(response);

    return response;
  }

  Future editTripPlan(TripPlan tripPlan) async {
    int id = tripPlan.id;
    var response = await _helper.put("/tripPlan/$id", tripPlan.toJson());

    return response;
  }

  Future deleteTripPlan(int id) async {
    var response = await _helper.delete("/tripPlan/$id");

    return response;
  }
}
