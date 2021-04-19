import 'package:canoe_trip_planner/enums/viewstate.dart';
import 'package:canoe_trip_planner/provider/company_map_route_provider.dart';
import 'package:canoe_trip_planner/provider/map_route_provider.dart';
import 'package:canoe_trip_planner/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';
import 'company_map_route_screen.dart';

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
    companyMapRouteProvider
        .getCompanyMapRoute(widget.mapId)
        .then((value) => print(companyMapRouteProvider.mapRoute.title));

    print(companyMapRouteProvider.state);

    // pabandyt po then paleist metoda

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CompanyMapRouteProvider>(
      create: (context) => companyMapRouteProvider,
      child: Consumer<CompanyMapRouteProvider>(
          builder: (context, companyMapRouteProvider, child) {
        return Scaffold(
            appBar: AppBar(),
            backgroundColor: backgroundColor,
            body: companyMapRouteProvider.state == ViewState.Busy
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Center(
                          child: Text(
                            'Created Maps',
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.person),
                        title: new Text(companyMapRouteProvider.mapRoute.title),
                        subtitle:
                            new Text(companyMapRouteProvider.mapRoute.author),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CompanyMapRouteDetailScreen(
                                mapId:
                                    companyMapRouteProvider.companyMapRoute.id);
                          }));
                        },
                      ),

                      // new ListTile(
                      //   leading: const Icon(Icons.phone),
                      //   subtitle: new Text(companyMapRouteProvider
                      //       .companyMapRoute.companyName),
                      // ),
                      // new ListTile(
                      //   leading: const Icon(Icons.email),
                      //   title: new TextField(
                      //     decoration: new InputDecoration(
                      //       hintText: "Email",
                      //     ),
                      //   ),
                      // ),
                    ],
                  ));
      }),
    );
  }
}
