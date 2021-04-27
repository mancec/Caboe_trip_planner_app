import 'package:canoe_trip_planner/components/appBarMenu.dart';
import 'package:canoe_trip_planner/enums/viewstate.dart';
import 'package:canoe_trip_planner/models/company.dart';
import 'package:canoe_trip_planner/provider/trip_plan_provider.dart';
import 'package:canoe_trip_planner/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TripPlanDetailScreen extends StatefulWidget {
  static const String id = 'trip_plan_edit_screen';
  final int routeId;

  TripPlanDetailScreen({this.routeId});
  @override
  _TripPlanDetailScreenState createState() => _TripPlanDetailScreenState();
}

class _TripPlanDetailScreenState extends State<TripPlanDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  Company company = Company();
  TripPlanProvider tripPlanProvider = TripPlanProvider();
  String description = '';

  @override
  void initState() {
    tripPlanProvider.getTripPlan(widget.routeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TripPlanProvider>(
        create: (context) => tripPlanProvider,
        child: Consumer<TripPlanProvider>(
            builder: (context, tripPlanProvider, child) {
          return Scaffold(
            appBar: AppBar(title: Text('Canoe planner')),
            drawer: AppBarMenu(),
            backgroundColor: backgroundColor,
            body: tripPlanProvider.state == ViewState.Busy
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
                                'Time And Date',
                                style: TextStyle(fontSize: 23),
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
                                        Text('Starting Date:',
                                            style: TextStyle(
                                              fontSize: 18,
                                            )),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                              tripPlanProvider
                                                  .tripPlan.startingDate,
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
                                          Text('Ending Date:',
                                              style: TextStyle(
                                                fontSize: 18,
                                              )),
                                          Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                                tripPlanProvider
                                                    .tripPlan.endingDate,
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
                                  tripPlanProvider.tripPlan.description,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        }));
  }
}
