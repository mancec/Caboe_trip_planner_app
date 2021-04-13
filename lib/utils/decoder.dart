///return [List]
List<PointLatLng> decodeEncodedPolyline(String encoded) {
  List<PointLatLng> poly = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;
    PointLatLng p =
        new PointLatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
    poly.add(p);
  }
  return poly;
}

/// Note instead of using the class,
/// you can use Google LatLng() by importing it from their library.
class PointLatLng {
  /// Creates a geographical location specified in degrees [latitude] and
  /// [longitude].
  ///
  const PointLatLng(double latitude, double longitude)
      : assert(latitude != null),
        assert(longitude != null),
        this.latitude = latitude,
        this.longitude = longitude;

  /// The latitude in degrees.
  final double latitude;

  /// The longitude in degrees
  final double longitude;

  @override
  String toString() {
    return "lat: $latitude / longitude: $longitude";
  }
}
