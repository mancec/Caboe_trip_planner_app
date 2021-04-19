import 'package:canoe_trip_planner/components/map_create_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:canoe_trip_planner/utils/constants.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:location/location.dart';
import 'package:canoe_trip_planner/locator.dart';
import 'package:canoe_trip_planner/provider/map_route_provider.dart';
import 'package:canoe_trip_planner/models/map_route.dart';
import 'package:provider/provider.dart';
import 'package:canoe_trip_planner/provider/auth_provider.dart';
import 'package:canoe_trip_planner/screens/Authentication/login.dart';

class CompanyMapCreateScreen extends StatefulWidget {
  static const String id = 'company_map_create_screen';
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<CompanyMapCreateScreen> {
  MapRouteProvider mapRouteProvider = locator<MapRouteProvider>();
  MapRoute mapRoute = MapRoute();

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController controller;

  List<LatLng> plineCoordinates = [];
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  static LatLng _lat1 = LatLng(13.035606, 77.562381);
  LatLng currentLocation;
  bool isLoaded = false;

  @override
  void initState() {
    _getLocation();
    mapRoute.polyline = List();
    super.initState();
  }

  _getLocation() async {
    var location = new Location();
    try {
      var tempLocation = await location.getLocation();
      setState(() {
        currentLocation = LatLng(tempLocation.latitude, tempLocation.longitude);
        isLoaded = true;
      }); //rebuild the widget after getting the current location of the user
    } on Exception {
      currentLocation = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          switch (auth.isAuthenticated) {
            case true:
              return new Scaffold(
                  body: !isLoaded
                      ? Center(child: CircularProgressIndicator())
                      : GoogleMap(
                          polylines: _polyline,
                          markers: _markers,
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          initialCameraPosition: CameraPosition(
                            target: currentLocation,
                            zoom: 11.0,
                          ),
                          onTap: _addPointToMap,
                        ),
                  floatingActionButton: SpeedDial(
                    animatedIcon: AnimatedIcons.menu_close,
                    children: [
                      SpeedDialChild(
                          child: Icon(Icons.add_location_alt_rounded),
                          label: "Start drawing",
                          onTap: () => print("Start")),
                      SpeedDialChild(
                          child: Icon(Icons.autorenew_rounded),
                          label: "Clear route",
                          onTap: _clearRoute),
                      SpeedDialChild(
                          child: Icon(Icons.wrong_location_rounded),
                          label: "End route",
                          onTap: _closingMarker),
                      SpeedDialChild(
                          child: Icon(Icons.where_to_vote_sharp),
                          label: "Save map",
                          onTap: _saveMap),
                      SpeedDialChild(
                          child: Icon(Icons.clear),
                          label: "Remove Last",
                          onTap: _clearLast)
                    ],
                  ));
            default:
              return LoginForm();
          }
        },
      ),
    );
  }

  void _addPointToMap(LatLng) {
    if (mapRoute.polyline.length > 0) {
      mapRoute.polyline.add(LatLng);
      setState(() {
        _polyline.add(Polyline(
          polylineId: PolylineId('line1'),
          visible: true,
          points: mapRoute.polyline,
          width: 2,
          color: Colors.blue,
        ));
      });
    } else {
      mapRoute.polyline.add(LatLng);
      setState(() {
        _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(LatLng.toString()),
          //_lastMapPosition is any coordinate which should be your default
          //position when map opens up
          position: LatLng,
          infoWindow: InfoWindow(
            title: '',
            snippet: 'This is a snippet',
          ),
        ));
      });
    }
  }

  void _closingMarker() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(mapRoute.polyline.last.toString()),
        //_lastMapPosition is any coordinate which should be your default
        //position when map opens up
        position: mapRoute.polyline.last,
        infoWindow: InfoWindow(
          title: '',
          snippet: 'This is a snippet',
        ),
      ));
    });
  }

  void _clearLast() {
    setState(() {
      if (mapRoute.polyline.length == 2) {
        _markers.clear();
        mapRoute.polyline.clear();
      } else if (mapRoute.polyline.length > 2) {
        mapRoute.polyline.removeLast();
        if (_markers.length > 1) {
          _markers.remove(_markers.last);
        }
      }
    });
  }

  void _clearRoute() {
    setState(() {
      mapRoute.polyline.clear();
      _markers.clear();
    });
  }

  void _saveMap() async {
    Navigator.pop(context, mapRoute.polyline);
  }
}
