import 'package:canoe_trip_planner/enums/viewstate.dart';
import 'package:canoe_trip_planner/provider/company_map_route_provider.dart';
import 'package:canoe_trip_planner/provider/map_route_provider.dart';
import 'package:canoe_trip_planner/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CompanyMapRouteViewScreen extends StatefulWidget {
  static const String id = 'company_map_route_view_screen';
  CompanyMapRouteViewScreen({this.mapId});

  final int mapId;

  @override
  _MapRouteScreenState createState() => _MapRouteScreenState();
}

class _MapRouteScreenState extends State<CompanyMapRouteViewScreen> {
  CompanyMapRouteProvider mapRouteProvider = CompanyMapRouteProvider();

  Set<Polyline> _polyline = {};
  Set<Marker> _markers = {};
  int loading = 0;

  @override
  void initState() {
    mapRouteProvider.getCompanyMapRouteCoordinates(widget.mapId).then(
        (value) => addPointToMap(mapRouteProvider.companyMapRoute.polyline));
    print(mapRouteProvider.state);

    // pabandyt po then paleist metoda

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CompanyMapRouteProvider>(
        create: (context) => mapRouteProvider,
        child: Consumer<CompanyMapRouteProvider>(
            builder: (context, mapRouteProvider, child) {
          return Scaffold(
            appBar: AppBar(),
            backgroundColor: backgroundColor,
            body: mapRouteProvider.state == ViewState.Busy
                ? Center(child: CircularProgressIndicator())
                : GoogleMap(
                    polylines: _polyline,
                    markers: _markers,
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: mapRouteProvider.companyMapRoute.polyline.first,
                      zoom: 11.0,
                    ),
                  ),
          );
        }));
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
}
