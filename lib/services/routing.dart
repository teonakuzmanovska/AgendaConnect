import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

List<LatLng> decodePolyline(String polyline) {
  List<LatLng> coordinates = [];
  int index = 0;
  int len = polyline.length;
  int lat = 0;
  int lng = 0;

  while (index < len) {
    int shift = 0;
    int result = 0;
    int b;
    do {
      b = polyline.codeUnitAt(index++) - 63;
      result |= (b & 0x1F) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = polyline.codeUnitAt(index++) - 63;
      result |= (b & 0x1F) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    final double latitude = lat / 1E5;
    final double longitude = lng / 1E5;
    coordinates.add(LatLng(latitude, longitude));
  }

  return coordinates;
}

Future<List<LatLng>> getRouteCoordinates(
    LatLng start, LatLng destination, String apiKey) async {
  final String url =
      'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<LatLng> polylinePoints = [];

    if (data['routes'].isNotEmpty) {
      final String encodedPolyline =
          data['routes'][0]['overview_polyline']['points'];
      polylinePoints.addAll(decodePolyline(encodedPolyline));
    }
    return polylinePoints;
  } else {
    throw Exception('Failed to load directions');
  }
}
