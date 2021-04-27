import 'package:canoe_trip_planner/provider/company_map_route_provider.dart';
import 'package:canoe_trip_planner/provider/trip_plan_provider.dart';
import 'package:canoe_trip_planner/repository/company_repository.dart';
import 'package:canoe_trip_planner/repository/trip_plan_repository.dart';
import 'package:canoe_trip_planner/repository/user_repository.dart';
import 'package:get_it/get_it.dart';
import 'repository/map_route_repository.dart';
import 'package:canoe_trip_planner/provider/map_route_provider.dart';
import 'package:canoe_trip_planner/provider/auth_provider.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => MapRouteRepository());
  locator.registerLazySingleton(() => CompanyRepository());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => AuthProvider());
  locator.registerLazySingleton(() => TripPlanRepository());

  locator.registerFactory(() => MapRouteProvider());
  locator.registerFactory(() => CompanyMapRouteProvider());
  locator.registerFactory(() => TripPlanProvider());
}
