import 'package:canoe_trip_planner/locator.dart';
import 'package:canoe_trip_planner/models/company_map_route.dart';
import 'package:canoe_trip_planner/repository/map_route_repository.dart';
import 'package:canoe_trip_planner/models/map_route.dart';
import 'package:canoe_trip_planner/enums/viewstate.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapRouteProvider extends ChangeNotifier {
  MapRouteRepository _api = locator<MapRouteRepository>();

  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  void set state(ViewState newState) {
    _state = newState;
  }

  List<MapRoute> mapRoutes = [];
  int response_code;
  String response_message;

  MapRoute mapRoute;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  Future getMapRoutes() async {
    setState(ViewState.Busy);
    mapRoutes = await _api.fetchMapRouteList();
    setState(ViewState.Idle);
  }

  Future getMapRoute(int id) async {
    setState(ViewState.Busy);
    mapRoute = await _api.fetchMapRoute(id);
    setState(ViewState.Idle);
  }

  Future saveMapRoutes(MapRoute mapRoute) async {
    setState(ViewState.Busy);
    mapRoutes = await _api.saveMapRouteList(mapRoute);
    setState(ViewState.Idle);
  }

  Future getUserMapRoutes() async {
    setState(ViewState.Busy);
    mapRoutes = await _api.fetchUserMapRouteList();
    setState(ViewState.Idle);
  }

  Future shareMapRoute(id) async {
    setState(ViewState.Busy);
    var response = await _api.shareMapRoute(id);
    response_message = response['message'];
    response_code = response['response_code'];
    setState(ViewState.Idle);
  }

  Future getCompanyMapRoutes() async {
    setState(ViewState.Busy);
    mapRoutes = await _api.fetchCompanyMapRouteList();
    setState(ViewState.Idle);
  }

  Future editMapRouteRoute(MapRoute mapRoute) async {
    setState(ViewState.Busy);
    response_code = await _api.editMapRoute(mapRoute);
    setState(ViewState.Idle);
  }

  Future deleteMapRoute(int id) async {
    setState(ViewState.Busy);
    response_code = await _api.deleteMapRoute(id);
    setState(ViewState.Idle);
  }

  Future getTripPlanMapRoutes() async {
    setState(ViewState.Busy);
    mapRoutes = await _api.getTripPlanMapRoutes();
    setState(ViewState.Idle);
  }

  Future removeSharedMapRoute(int id) async {
    setState(ViewState.Busy);
    var response = await _api.removeSharedMapRoute(id);
    response_message = response['message'];
    response_code = response['response_code'];

    setState(ViewState.Idle);
  }
}
