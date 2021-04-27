import 'package:canoe_trip_planner/components/appBarMenu.dart';
import 'package:canoe_trip_planner/components/mapRoutelist_item.dart';
import 'package:canoe_trip_planner/components/map_route_list_card.dart';
import 'package:canoe_trip_planner/enums/viewstate.dart';
import 'package:canoe_trip_planner/models/map_route.dart';
import 'package:canoe_trip_planner/provider/map_route_provider.dart';
import 'package:canoe_trip_planner/screens/RouteMaps/user_map_detail_screen.dart';
import 'package:canoe_trip_planner/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../locator.dart';
import 'map_create_screen.dart';
import 'map_route_detail_screen.dart';

class UserMapListScreen extends StatefulWidget {
  static const String id = 'user_map_list_screen';
  final String message;
  UserMapListScreen({this.message});
  @override
  _UserMapListScreenState createState() => _UserMapListScreenState();
}

class _UserMapListScreenState extends State<UserMapListScreen> {
  MapRouteProvider model = locator<MapRouteProvider>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    model.getUserMapRoutes();
    super.initState();
  }

  void _onRefresh() async {
    model.getUserMapRoutes();
    _refreshController.loadComplete();
  }

  void _onLoading() async {
    _refreshController.loadNoData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapRouteProvider>(
      create: (context) => model,
      child: Consumer<MapRouteProvider>(builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            appBar: AppBar(),
            drawer: AppBarMenu(),
            backgroundColor: backgroundColor,
            body: model.state == ViewState.Busy
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 20.0),
                        child: Center(
                          child: Text(
                            'Create Routes',
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      Expanded(child: getPostsUi(model.mapRoutes)),
                    ],
                  ),
            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.add_event,
              onPress: () {
                Navigator.pushNamed(context, MapCreateScreen.id);
              },
            ),
          ),
        );
      }),
    );
  }

  Widget getPostsUi(List<MapRoute> mapRoutes) => SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
            itemCount: mapRoutes.length,
            itemBuilder: (context, index) => MapRouteListCard(
                  mapRoute: mapRoutes[index],
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return UserMapDetailScreen(mapId: mapRoutes[index].id);
                    }));
                  },
                )),
      );
}
