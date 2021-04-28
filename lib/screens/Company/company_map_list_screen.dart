import 'package:canoe_trip_planner/components/appBarMenu.dart';
import 'package:canoe_trip_planner/components/map_route_list_card.dart';
import 'package:canoe_trip_planner/enums/viewstate.dart';
import 'package:canoe_trip_planner/models/map_route.dart';
import 'package:canoe_trip_planner/provider/map_route_provider.dart';
import 'package:canoe_trip_planner/screens/Company/company_post_detail_screen.dart';
import 'package:canoe_trip_planner/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../locator.dart';
import 'company_post_create_screen.dart';

class CompanyMapListScreen extends StatefulWidget {
  final String message;

  CompanyMapListScreen({this.message});
  static const String id = 'company_map_list_screen';
  @override
  _CompanyMapListScreenState createState() => _CompanyMapListScreenState();
}

class _CompanyMapListScreenState extends State<CompanyMapListScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  MapRouteProvider model = locator<MapRouteProvider>();
  final Widget emptyWidget = new Container(width: 0, height: 0);
  String message;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    message = widget.message;
    model.getCompanyMapRoutes();
    super.initState();
  }

  void _onRefresh() async {
    message = 'helo';
    model.currentPage = 1;
    model.getCompanyMapRoutes();
    controller.clear();
    _refreshController.loadComplete();
  }

  void _onLoading() async {
    if (controller.text.isNotEmpty) {
      model.getCompanyMapRoutes(search: controller.text);
    } else {
      model.getCompanyMapRoutes();
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
    model.getCompanyMapRoutes(search: text);
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
            key: scaffoldKey,
            appBar: AppBar(),
            drawer: AppBarMenu(),
            backgroundColor: backgroundColor,
            body: model.state == ViewState.Busy
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Center(
                          child: Text(
                            'Created Offers',
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
                      message != null
                          ? showSimpleNotification(Text(message),
                              duration: Duration(milliseconds: 2000),
                              background: kLightBackground)
                          : emptyWidget
                    ],
                  ),
            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.add_event,
              onPress: () {
                Navigator.pushNamed(context, CompanyPostCreateScreen.id);
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
                      return CompanyPostDetailScreen(
                          mapId: mapRoutes[index].id);
                    }));
                  },
                )),
      );
}
