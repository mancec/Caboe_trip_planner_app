import 'package:canoe_trip_planner/components/appBarMenu.dart';
import 'package:canoe_trip_planner/components/map_route_list_card.dart';
import 'package:canoe_trip_planner/components/roundedButton.dart';
import 'package:canoe_trip_planner/components/trip_plan_meniu_items.dart';
import 'package:canoe_trip_planner/enums/viewstate.dart';
import 'package:canoe_trip_planner/models/map_route.dart';
import 'package:canoe_trip_planner/provider/map_route_provider.dart';
import 'package:canoe_trip_planner/provider/trip_plan_provider.dart';
import 'package:canoe_trip_planner/screens/Company/Shared/company_map_route_detail_shared.dart';
import 'package:canoe_trip_planner/screens/RouteMaps/map_route_detail_shared_screen.dart';
import 'package:canoe_trip_planner/screens/TripPlan/trip_plan%20_detail_screen.dart';
import 'package:canoe_trip_planner/screens/TripPlan/trip_plan_create_screen.dart';
import 'package:canoe_trip_planner/screens/TripPlan/trip_plan_edit_screen.dart';
import 'package:canoe_trip_planner/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../locator.dart';

class TripPlanSavedListScreen extends StatefulWidget {
  static const String id = 'trip_plan_saved_list_screen';
  @override
  _TripPlanSavedListScreenState createState() =>
      _TripPlanSavedListScreenState();
}

class _TripPlanSavedListScreenState extends State<TripPlanSavedListScreen> {
  MapRouteProvider model = locator<MapRouteProvider>();
  TripPlanProvider _tripPlanProvider = TripPlanProvider();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var _tapPosition;

  @override
  void initState() {
    _tripPlanProvider.getTripPlans();
    _tapPosition = Offset(0.0, 0.0);
    super.initState();
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TripPlanProvider>(
      create: (context) => _tripPlanProvider,
      child: Consumer<TripPlanProvider>(builder: (context, model, child) {
        return Scaffold(
            appBar: AppBar(),
            drawer: AppBarMenu(),
            backgroundColor: backgroundColor,
            body: model.state == ViewState.Busy
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            'Saved Trip Plans',
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      Expanded(child: getPostsUi(model.mapRoutes)),
                    ],
                  ));
      }),
    );
  }

  Widget getPostsUi(List<MapRoute> mapRoutes) => ListView.builder(
      itemCount: mapRoutes.length,
      itemBuilder: (context, index) => MapRouteListCard(
          mapRoute: mapRoutes[index],
          onTap: () {
            mapRoutes[index].isCompany != 1
                ? Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MapRouteDetailSharedScreen(
                        mapId: mapRoutes[index].id);
                  }))
                : Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CompanyMapDetailSharedScreen(
                        mapId: mapRoutes[index].id);
                  }));
          },
          onTapDown: _storePosition,
          onLongPress: () {
            final RenderBox overlay =
                Overlay.of(context).context.findRenderObject();
            showMenu(
              context: context,
              position: RelativeRect.fromRect(
                  _tapPosition & Size(40, 40), // smaller rect, the touch area
                  Offset.zero & overlay.size // Bigger rect, the entire screen
                  ),
              items: [
                PopupMenuItem(
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Text('View Trip Plan'),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return TripPlanDetailScreen(
                                routeId: mapRoutes[index].id);
                          }));
                        },
                      )
                    ],
                  ),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Text('Edit Trip Plan'),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return TripPlanEditScreen(
                                routeId: mapRoutes[index].id);
                          }));
                        },
                      )
                    ],
                  ),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Text('Delete'),
                        onTap: () {
                          Navigator.pop(context);
                          _tripPlanProvider
                              .deleteTripPlan(mapRoutes[index].id)
                              .then(
                                  (value) => _tripPlanProvider.getTripPlans());
                        },
                      )
                    ],
                  ),
                ),
              ],
              elevation: 8.0,
            );
          }));
}
