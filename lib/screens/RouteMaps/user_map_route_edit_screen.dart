import 'package:canoe_trip_planner/components/map_create_dialog.dart';
import 'package:canoe_trip_planner/screens/RouteMaps/user_map_list_screen.dart';
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

class UserMapEditScreen extends StatefulWidget {
  static const String id = 'user_map_edit_screen';
  final MapRoute mapRoute;

  UserMapEditScreen({this.mapRoute});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<UserMapEditScreen> {
  MapRouteProvider mapRouteProvider = locator<MapRouteProvider>();
  MapRoute mapRoute = MapRoute();
  String errorMessage;
  //Form controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _authorEditingController =
      TextEditingController();
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController =
      TextEditingController();
  //End

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController controller;
  List<LatLng> plineCoordinates = [];
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  bool isLoaded = false;
  LatLng currentLocation;

  @override
  void initState() {
    _getLocation();
    mapRoute = widget.mapRoute;
    addPointToMap(mapRoute.polyline);
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

  void addPointToMap(List<LatLng> LatLngList) {
    _polyline.add(Polyline(
      polylineId: PolylineId('line1'),
      visible: true,
      points: LatLngList,
      width: 2,
      color: Colors.blue,
    ));

    _markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(LatLngList.first.toString()),
      //_lastMapPosition is any coordinate which should be your default
      //position when map opens up
      position: LatLngList.first,
      infoWindow: InfoWindow(
        title: '',
        snippet: 'This is a snippet',
      ),
    ));

    _markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(LatLngList.last.toString()),
      //_lastMapPosition is any coordinate which should be your default
      //position when map opens up
      position: LatLngList.last,
      infoWindow: InfoWindow(
        title: '',
        snippet: 'This is a snippet',
      ),
    ));
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
    // mapRouteProvider.saveMapRoutes(mapRoute);
    await showInformationDialog(context)
        .then((value) => Navigator.of(context).pop());
  }

  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _titleEditingController
                          ..text = mapRoute.title,
                        validator: (value) {
                          return value.isNotEmpty ? null : "Enter a title";
                        },
                        decoration: InputDecoration(
                            hintText: "Please enter a title",
                            labelText: 'Title'),
                      ),
                      TextFormField(
                        controller: _descriptionEditingController
                          ..text = mapRoute.description,
                        validator: (value) {
                          return value.isNotEmpty
                              ? null
                              : "Enter a short description";
                        },
                        decoration: InputDecoration(
                            hintText: "Please leave a short description",
                            labelText: 'Description'),
                      ),
                    ],
                  )),
              title: Text('Additional Route information'),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: InkWell(
                    child: Text('Save', style: TextStyle(fontSize: 16)),
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        mapRoute.title = _titleEditingController.text;
                        mapRoute.description =
                            _descriptionEditingController.text;

                        // Do something like updating SharedPreferences or User Settings etc.
                        mapRouteProvider
                            .editMapRouteRoute(mapRoute)
                            .then((value) {
                          if (mapRouteProvider.response_code == 200) {
                            Navigator.pushNamed(context, UserMapListScreen.id);
                          } else {
                            errorMessage = "Map route was not saved";
                          }
                        });
                      }
                    },
                  ),
                ),
              ],
            );
          });
        });
  }
}
