import 'package:canoe_trip_planner/components/appBarMenu.dart';
import 'package:canoe_trip_planner/components/company_price_fields.dart';
import 'package:canoe_trip_planner/components/company_profile.dart';
import 'package:canoe_trip_planner/components/roundedButton.dart';
import 'package:canoe_trip_planner/enums/viewstate.dart';
import 'package:canoe_trip_planner/models/canoe_price.dart';
import 'package:canoe_trip_planner/models/company.dart';
import 'package:canoe_trip_planner/models/company_map_route.dart';
import 'package:canoe_trip_planner/provider/company_map_route_provider.dart';
import 'package:canoe_trip_planner/provider/map_route_provider.dart';
import 'package:canoe_trip_planner/screens/Company/company_map_list_screen.dart';
import 'package:canoe_trip_planner/screens/TripPlan/trip_plan_time_create_screen.dart';
import 'package:canoe_trip_planner/utils/app_colors.dart';
import 'package:canoe_trip_planner/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';
import 'package:canoe_trip_planner/utils/helper.dart';

class TripPlanCreateScreen extends StatefulWidget {
  static const String id = 'trip_plan_create_screen';
  final int routeId;

  TripPlanCreateScreen({this.routeId});
  @override
  _TripPlanCreateScreenState createState() => _TripPlanCreateScreenState();
}

class _TripPlanCreateScreenState extends State<TripPlanCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  Company company = Company();
  MapRouteProvider mapRouteProvider = MapRouteProvider();
  TextEditingController _descriptionEditingController = TextEditingController();
  String description = '';

  @override
  void initState() {
    mapRouteProvider.getMapRoute(widget.routeId);
    super.initState();
  }

  saveForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // submitForm();
      description = _descriptionEditingController.text;
      _formKey.currentState.reset();
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return TripPlanTimeCreateScreen(
            routeId: mapRouteProvider.mapRoute.id, description: description);
      }));
      // setState(() {
      //   canoePrices = [CanoePrice()];
      //   lowPrice = [MoneyMaskedTextController()];
      // });
    }
  }

  saveProfile() {}

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapRouteProvider>(
        create: (context) => mapRouteProvider,
        child: Consumer<MapRouteProvider>(builder: (context, route, child) {
          return Scaffold(
            appBar: AppBar(title: Text('Canoe planner')),
            backgroundColor: backgroundColor,
            body: route.state == ViewState.Busy
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                'Trip Plan',
                                style: TextStyle(fontSize: 26),
                              ),
                            ),
                          ),
                          Divider(),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                'Location',
                                style: TextStyle(fontSize: 23),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Route Information:',
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('Route Title:',
                                            style: TextStyle(
                                              fontSize: 18,
                                            )),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child:
                                              Text(route.mapRoute.title.inCaps,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  )),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          Text('Route Author:',
                                              style: TextStyle(
                                                fontSize: 18,
                                              )),
                                          Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                                route.mapRoute.author.inCaps,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                )),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: 15, left: 15, right: 15),
                              child: Text(
                                'Description',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(25),
                            child: Container(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  route.mapRoute.description,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          new Form(
                              key: _formKey,
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  child: Theme(
                                    data: new ThemeData(
                                      primaryColor: Colors.indigoAccent,
                                      primaryColorDark: Colors.indigoAccent,
                                    ),
                                    child: TextFormField(
                                      maxLines: 3,
                                      maxLength: 130,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(8.0),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                      controller: _descriptionEditingController,
                                    ),
                                  ),
                                ),
                              )),
                          RoundedButton(
                            onPressed: saveForm,
                            title: 'NEXT',
                            colour: Colors.indigoAccent,
                          )
                        ],
                      ),
                    ),
                  ),
          );
        }));
  }
}
