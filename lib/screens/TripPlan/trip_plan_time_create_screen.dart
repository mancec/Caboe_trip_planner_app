import 'package:canoe_trip_planner/components/roundedButton.dart';
import 'package:canoe_trip_planner/enums/viewstate.dart';
import 'package:canoe_trip_planner/models/company.dart';
import 'package:canoe_trip_planner/models/trip_plan.dart';
import 'package:canoe_trip_planner/provider/map_route_provider.dart';
import 'package:canoe_trip_planner/provider/trip_plan_provider.dart';
import 'package:canoe_trip_planner/utils/app_colors.dart';
import 'package:canoe_trip_planner/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:canoe_trip_planner/utils/helper.dart';
import 'package:date_time_picker/date_time_picker.dart';

class TripPlanTimeCreateScreen extends StatefulWidget {
  static const String id = 'trip_plan_time_create_screen';
  final int routeId;
  final String description;

  TripPlanTimeCreateScreen({this.routeId, this.description});
  @override
  _TripPlanTimeCreateScreenState createState() =>
      _TripPlanTimeCreateScreenState();
}

class _TripPlanTimeCreateScreenState extends State<TripPlanTimeCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  Company company = Company();
  MapRouteProvider mapRouteProvider = MapRouteProvider();
  TripPlanProvider tripPlanProvider = TripPlanProvider();
  TextEditingController _descriptionEditingController = TextEditingController();
  String startingDate;
  String endingDate;
  TripPlan tripPlan = TripPlan();

  @override
  void initState() {
    // mapRouteProvider.getMapRoute(widget.routeId);
    super.initState();
  }

  saveProfile() {
    tripPlan.description = widget.description;
    tripPlan.startingDate = startingDate;
    tripPlan.endingDate = endingDate;
    tripPlan.routeId = widget.routeId;
    tripPlanProvider.addTripPlan(tripPlan);
  }

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
                                'Time And Date',
                                style: TextStyle(fontSize: 23),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: 15, left: 15, right: 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Starting Date:',
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
                                    DateTimePicker(
                                      type: DateTimePickerType.dateTimeSeparate,
                                      dateMask: 'd MMM, yyyy',
                                      initialValue: DateTime.now().toString(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                      icon: Icon(Icons.event),
                                      dateLabelText: 'Date',
                                      timeLabelText: "Time",
                                      selectableDayPredicate: (date) {
                                        // Disable weekend days to select from the calendar
                                        if (date.weekday == 6 ||
                                            date.weekday == 7) {
                                          return false;
                                        }

                                        return true;
                                      },
                                      onChanged: (val) => startingDate = val,
                                      validator: (val) {
                                        print(val);
                                        return null;
                                      },
                                      onSaved: (val) => print(val),
                                    )
                                  ],
                                )),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: 15, left: 15, right: 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Ending Date:',
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
                                    DateTimePicker(
                                      type: DateTimePickerType.dateTimeSeparate,
                                      dateMask: 'd MMM, yyyy',
                                      initialValue: DateTime.now().toString(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                      icon: Icon(Icons.event),
                                      dateLabelText: 'Date',
                                      timeLabelText: "Time",
                                      onChanged: (val) => endingDate = val,
                                      validator: (val) {
                                        print(val);
                                        return null;
                                      },
                                      onSaved: (val) => print(val),
                                    )
                                  ],
                                )),
                          ),
                          RoundedButton(
                            onPressed: () {
                              saveProfile();
                            },
                            title: 'SAVE',
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
