import 'package:canoe_trip_planner/locator.dart';
import 'package:canoe_trip_planner/repository/map_route_repository.dart';
import 'package:canoe_trip_planner/models/map_route.dart';
import 'package:canoe_trip_planner/enums/viewstate.dart';
import 'package:flutter/cupertino.dart';

class MapRouteProvider extends ChangeNotifier {
  MapRouteRepository _api = locator<MapRouteRepository>();

  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  void set state(ViewState newState) {
    _state = newState;
  }

  List<MapRoute> mapRoutes;

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
}
