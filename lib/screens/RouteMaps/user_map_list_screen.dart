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
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    model.getUserMapRoutes();
    super.initState();
  }

  void _onRefresh() async {
    model.currentPage = 1;
    print(model.currentPage);
    model.getUserMapRoutes();
    controller.clear();
    _refreshController.loadComplete();
  }

  void _onLoading() async {
    if (controller.text.isNotEmpty) {
      model.getUserMapRoutes(search: controller.text);
    } else {
      model.getUserMapRoutes();
    }
    _refreshController.loadComplete();
  }

  onSearchTextChanged(String text) async {
    model.mapRoutes = [];
    model.currentPage = 1;
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    model.getUserMapRoutes(search: text);
    print(controller.text);

    setState(() {});
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
                        padding: const EdgeInsets.only(top: 20, left: 20.0),
                        child: Center(
                          child: Text(
                            'Created Routes',
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 0, left: 5.0, right: 5),
                        child: Card(
                          child: new ListTile(
                            leading: new Icon(Icons.search),
                            title: new TextField(
                              controller: controller,
                              decoration: new InputDecoration(
                                  hintText: 'Search', border: InputBorder.none),
                              // onChanged: onSearchTextChanged,
                              onSubmitted: onSearchTextChanged,
                            ),
                            trailing: new IconButton(
                              icon: new Icon(Icons.cancel),
                              onPressed: () {
                                controller.clear();
                                // onSearchTextChanged('');
                              },
                            ),
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
