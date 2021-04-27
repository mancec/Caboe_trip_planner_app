import 'package:canoe_trip_planner/enums/viewstate.dart';
import 'package:canoe_trip_planner/models/map_route.dart';
import 'package:canoe_trip_planner/models/trip_plan.dart';
import 'package:canoe_trip_planner/repository/trip_plan_repository.dart';
import 'package:flutter/cupertino.dart';

import '../locator.dart';

class TripPlanProvider extends ChangeNotifier {
  TripPlanRepository _api = locator<TripPlanRepository>();
  ViewState _state = ViewState.Idle;
  ViewState get state => _state;
  int response_code;
  String response_message;

  TripPlan tripPlan;
  List<TripPlan> tripPlans;
  List<MapRoute> mapRoutes = [];

  void set state(ViewState newState) {
    _state = newState;
  }

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void setTripPlan(TripPlan tripPlan) {
    this.tripPlan = tripPlan;
    notifyListeners();
  }

  Future addUserTripPlan(int id) async {
    setState(ViewState.Busy);
    var response;
    response = await _api.addUserTripPlan(id);
    response_message = response['message'];
    response_code = response['response_code'];
    setState(ViewState.Idle);
  }

  Future getTripPlans() async {
    setState(ViewState.Busy);
    var response;
    mapRoutes = await _api.getTripPlans();
    setState(ViewState.Idle);
  }

  Future getTripPlan(int id) async {
    setState(ViewState.Busy);
    var response;
    tripPlan = await _api.getTripPlan(id);
    setState(ViewState.Idle);
  }

  Future addTripPlan(TripPlan tripPlan) async {
    setState(ViewState.Busy);
    var response;
    response = await _api.addTripPlan(tripPlan);
    setState(ViewState.Idle);
  }

  Future deleteTripPlan(int id) async {
    setState(ViewState.Busy);
    var response;
    response = await _api.deleteTripPlan(id);
    setState(ViewState.Idle);
  }

  Future editTripPlan(TripPlan tripPlan) async {
    setState(ViewState.Busy);
    var response;
    response = await _api.editTripPlan(tripPlan);
    setState(ViewState.Idle);
  }
}
