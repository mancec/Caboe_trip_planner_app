import 'package:canoe_trip_planner/components/alert_dialog.dart';
import 'package:canoe_trip_planner/components/roundedButton.dart';
import 'package:canoe_trip_planner/enums/viewstate.dart';
import 'package:canoe_trip_planner/models/canoe_price.dart';
import 'package:canoe_trip_planner/provider/company_map_route_provider.dart';
import 'package:canoe_trip_planner/provider/map_route_provider.dart';
import 'package:canoe_trip_planner/screens/Company/company_map_list_screen.dart';
import 'package:canoe_trip_planner/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:canoe_trip_planner/utils/helper.dart';

import '../../locator.dart';
import 'company_map_route_view_screen.dart';
import 'company_post_edit_screen.dart';

class CompanyPostDetailScreen extends StatefulWidget {
  static const String id = 'company_map_route_detail_screen';
  CompanyPostDetailScreen({this.mapId});

  final int mapId;
  @override
  _CompanyPostDetailScreenState createState() =>
      _CompanyPostDetailScreenState();
}

class _CompanyPostDetailScreenState extends State<CompanyPostDetailScreen> {
  CompanyMapRouteProvider companyMapRouteProvider =
      locator<CompanyMapRouteProvider>();

  @override
  void initState() {
    companyMapRouteProvider.getCompanyMapRoute(widget.mapId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CompanyMapRouteProvider>(
      create: (context) => companyMapRouteProvider,
      child:
          Consumer<CompanyMapRouteProvider>(builder: (context, route, child) {
        return Scaffold(
            appBar: AppBar(),
            backgroundColor: backgroundColor,
            body: companyMapRouteProvider.state == ViewState.Busy
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                        child: Center(
                          child: Text(
                            route.mapRoute.title.capitalizeFirstofEach,
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      Card(
                        color: Color.fromRGBO(61, 90, 254, 192),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 8.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Center(
                                  child: Text(
                                    "Company Information",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                              ),
                              CompanyDetail(
                                hint: "Contact us at: ",
                                text: companyMapRouteProvider
                                    .companyMapRoute.contactEmail,
                              ),
                              CompanyDetail(
                                hint: "Address: ",
                                text: companyMapRouteProvider
                                    .companyMapRoute.address,
                              ),
                              CompanyDetail(
                                hint: "Work hours: ",
                                text: companyMapRouteProvider
                                    .companyMapRoute.workHours,
                              ),
                              CompanyDetail(
                                hint: "Contact number: ",
                                text: companyMapRouteProvider
                                    .companyMapRoute.contactNumber,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Center(
                                  child: Text(
                                    "Canoe prices",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              CompanyPriceDetail(
                                  canoePrice: companyMapRouteProvider
                                      .companyMapRoute.canoePrice)
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Center(
                          child: Text(
                            "Route Information",
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                      Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Text(route.mapRoute.description.inCaps)),
                      Padding(
                          padding:
                              EdgeInsets.only(left: 20, bottom: 20, top: 10),
                          child: Text("By: " + route.mapRoute.author)),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: RoundedButton(
                                title: 'Go To Route',
                                colour: Color.fromRGBO(61, 90, 254, 192),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return CompanyMapRouteViewScreen(
                                        mapId: route.mapRoute.id);
                                  }));
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                    child: Icon(Icons.drive_file_rename_outline),
                    label: "Edit Route",
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CompanyPostEditScreen(
                            route.company, route.mapRoute);
                      }));
                    }),
                SpeedDialChild(
                    child: Icon(Icons.remove),
                    label: "Delete Route",
                    onTap: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (_) =>
                            AlertDialogWidget(title: route.mapRoute.title),
                      );
                      if (result) {
                        await companyMapRouteProvider
                            .deleteCompanyRoute(route.companyMapRoute.id)
                            .then((value) {
                          if (companyMapRouteProvider.response_code == 200) {
                            print("nukreipimas");
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CompanyMapListScreen(
                                message: 'Route: ' +
                                    route.mapRoute.title +
                                    'had been removed',
                              );
                            }));
                          }
                        });
                      }
                    })
              ],
            ));
      }),
    );
  }
}

class CompanyDetail extends StatelessWidget {
  final String hint;
  final String text;

  CompanyDetail({this.text, this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: 8, left: 10),
        child: Row(
          children: [
            Text(hint, style: TextStyle(fontSize: 16)),
            Flexible(child: Text(text, style: TextStyle(fontSize: 16)))
          ],
        ),
      ),
    );
  }
}

class CompanyPriceDetail extends StatelessWidget {
  final List<CanoePrice> canoePrice;

  CompanyPriceDetail({this.canoePrice});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8, left: 10),
      child: Expanded(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              // Let the ListView know how many items it needs to build.
              itemCount: canoePrice.length,
              // Provide a builder function. This is where the magic happens.
              // Convert each item into a widget based on the type of item it is.
              itemBuilder: (context, index) {
                final item = canoePrice[index];

                return Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(item.type.toString() + ":",
                              style: TextStyle(fontSize: 16))),
                      Text(item.price.toString() + "€",
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                );

                // return ListTile(
                //   title: item.buildTitle(context),
                //   subtitle: item.buildSubtitle(context),
                // );
              },
            )
          ],
        ),
      ),
    );
  }
}
