import 'package:canoe_trip_planner/components/map_route_list_card.dart';
import 'file:///C:/UniStuff/Bakalauras/canoe_trip_planner%20-%20Copy/lib/screens/Company/Shared/company_map_route_detail_shared.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:canoe_trip_planner/enums/viewstate.dart';
import 'package:canoe_trip_planner/models/map_route.dart';
import 'package:canoe_trip_planner/provider/map_route_provider.dart';
import 'package:canoe_trip_planner/locator.dart';
import 'package:canoe_trip_planner/utils/app_colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../map_route_detail_shared_screen.dart';
import 'map_route_information_screen.dart';

class MapRouteListView extends StatefulWidget {
  static const String id = 'map_list_screen';
  @override
  _MapRouteListViewState createState() => _MapRouteListViewState();
}

class _MapRouteListViewState extends State<MapRouteListView> {
  MapRouteProvider model = locator<MapRouteProvider>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    model.getMapRoutes();
    super.initState();
  }

  void _onRefresh() async {
    model.mapRoutes = [];
    model.currentPage = 1;
    print(model.currentPage);
    model.getMapRoutes();
    controller.clear();
    _refreshController.loadComplete();
  }

  void _onLoading() async {
    if (controller.text.isNotEmpty) {
      model.getMapRoutes(search: controller.text);
    } else {
      model.getMapRoutes();
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
    model.getMapRoutes(search: text);
    print(controller.text);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapRouteProvider>(
      create: (context) => model,
      child: Consumer<MapRouteProvider>(builder: (context, model, child) {
        return Scaffold(
            appBar: AppBar(),
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
                            'Paddling Routes',
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
                  ));
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
                    mapRoutes[index].isCompany != 1
                        ? Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                            return MapRouteInformationScreen(
                                mapId: mapRoutes[index].id);
                          }))
                        : Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                            return CompanyMapDetailSharedScreen(
                                mapId: mapRoutes[index].id);
                          }));
                  },
                )),
      );
}
