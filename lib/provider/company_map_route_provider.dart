import 'package:canoe_trip_planner/locator.dart';
import 'package:canoe_trip_planner/models/company.dart';
import 'package:canoe_trip_planner/models/company_map_route.dart';
import 'package:canoe_trip_planner/repository/company_repository.dart';
import 'package:canoe_trip_planner/repository/map_route_repository.dart';
import 'package:canoe_trip_planner/models/map_route.dart';
import 'package:canoe_trip_planner/enums/viewstate.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CompanyMapRouteProvider extends ChangeNotifier {
  MapRouteRepository _api = locator<MapRouteRepository>();

  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  void set state(ViewState newState) {
    _state = newState;
  }

  int response_code;

  List<CompanyMapRoute> companyMapRoutes = [];

  CompanyMapRoute companyMapRoute;
  MapRoute mapRoute;
  Company company;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  Future getCompanyMapRoute(int id) async {
    setState(ViewState.Busy);
    companyMapRoute = await _api.fetchCompanyMapRoute(id);
    company = Company.fromMapRoute(companyMapRoute);
    mapRoute = await _api.fetchMapRoute(id);
    print("return");
    print(mapRoute.author);
    setState(ViewState.Idle);
  }

  Future getCompanyMapRouteCoordinates(int id) async {
    setState(ViewState.Busy);
    companyMapRoute = await _api.fetchCompanyMapRouteCoordinates(id);
    setState(ViewState.Idle);
  }

  Future saveCompanyProfile(Company companyProfile) async {
    setState(ViewState.Busy);
    company = await _api.saveCompanyProfile(companyProfile);
    setState(ViewState.Idle);
  }

  Future getCompanyProfile() async {
    setState(ViewState.Busy);
    company = await _api.getCompanyProfile();
    setState(ViewState.Idle);
  }

  Future editCompanyProfile(company) async {
    setState(ViewState.Busy);
    company = await _api.editCompanyProfile(company);
    setState(ViewState.Idle);
  }

  Future saveCompanyRoute(MapRoute mapRoute, Company company) async {
    setState(ViewState.Busy);
    response_code = await _api.saveCompanyRoute(mapRoute, company);
    setState(ViewState.Idle);
  }

  Future editCompanyRoute(MapRoute mapRoute, Company company) async {
    setState(ViewState.Busy);
    response_code = await _api.editCompanyRoute(mapRoute, company);
    setState(ViewState.Idle);
  }

  Future deleteCompanyRoute(int id) async {
    setState(ViewState.Busy);
    response_code = await _api.deleteCompanyRoute(id);
    print('provider');
    print(response_code);
    setState(ViewState.Idle);
  }
}
