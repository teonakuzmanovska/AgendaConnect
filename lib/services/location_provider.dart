import 'package:client_meeting_scheduler/models/Location.dart'
    as location_model;
import 'package:client_meeting_scheduler/models/client.dart';
import 'package:client_meeting_scheduler/models/meeting.dart';
import 'package:client_meeting_scheduler/repo/client_repository.dart';
import 'package:client_meeting_scheduler/services/routing.dart'; // Importing custom Location model.
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart'; // For drawing polylines (routes) on the map.
import 'package:geocoding/geocoding.dart'; // For reverse geocoding (getting address from coordinates).
import 'package:geolocator/geolocator.dart'; // For getting the device's current location.
import 'package:google_maps_flutter/google_maps_flutter.dart'; // For Google Maps in Flutter.

// The LocationProvider class is a state management class using ChangeNotifier.
// It handles location-related tasks, such as fetching current location, updating markers, circles, and handling map interactions.
class LocationProvider with ChangeNotifier {
  GoogleMapController? mapController; // Make mapController nullable
  bool isLoading = true; // Flag to track if location data is loading.
  bool isRouteActive = false; // Track if a route is currently active
  final clientRepo = ClientRepository();

  late location_model.Location currentLocation;
  late location_model.Location selectedLocation;

  late Marker locationMarker;
  late Circle currentLocationCircle;

  late List<PolylineWayPoint> polylineWayPoints;
  late Polyline routePolyline;

  LocationProvider() {
    currentLocation =
        location_model.Location(coordinates: const LatLng(0, 0), address: "");
    selectedLocation =
        location_model.Location(coordinates: const LatLng(0, 0), address: "");

    currentLocationCircle = Circle(
      circleId: const CircleId('initial-location'),
      center: currentLocation.coordinates,
      radius: 4000,
    );

    locationMarker = Marker(
      markerId: const MarkerId('initial-location'),
      position: currentLocation.coordinates,
    );

    polylineWayPoints = [];

    routePolyline = const Polyline(
      polylineId: PolylineId('route_polyline'),
      color: Colors.black,
      width: 5,
      points: [],
    );

    getCurrentLocation();
    updateCurrentLocationCircle(currentLocation);
    updatePickedLocationMarker(currentLocation);
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isLoading = false;
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        isLoading = false;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      isLoading = false;
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLocation.coordinates =
          LatLng(position.latitude, position.longitude);
      await getAddressFromCoordinates(currentLocation);

      // Safely check if mapController is initialized
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLng(currentLocation.coordinates),
        );
      }
    } catch (e) {
      print("Error getting current location: $e");
    }

    isLoading = false;
    notifyListeners();
    updatePickedLocationMarker(currentLocation);
  }

  Future<void> getAddressFromCoordinates(
      location_model.Location location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.coordinates.latitude,
        location.coordinates.longitude,
      );
      location.address = placemarks.first.name ?? '';
    } catch (e) {
      print("Error getting address from coordinates: $e");
    }
  }

  Future<LatLng?> _getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        // Return the first location's coordinates as a LatLng object.
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      print("Error getting coordinates from address: $e");
    }
    return null; // Return null if no valid location is found.
  }

  void updatePickedLocationMarker(location_model.Location location) async {
    locationMarker = Marker(
      markerId: const MarkerId('picked-location'),
      position: location.coordinates,
      infoWindow: InfoWindow(
        title: 'Selected Location',
        snippet: location.address,
      ),
    );

    notifyListeners();
  }

  void updateCurrentLocationCircle(location_model.Location location) async {
    currentLocationCircle = Circle(
      circleId: const CircleId("current_location"),
      center: currentLocation.coordinates,
      radius: 4000,
    );

    notifyListeners();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (!isLoading) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(currentLocation.coordinates),
      );
    }
  }

  void onMapTap(LatLng location) {
    selectedLocation.coordinates = location;
    selectedLocation.address = '';
    getAddressFromCoordinates(selectedLocation);

    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(location),
      );
    }

    updatePickedLocationMarker(selectedLocation);
  }

  void onMarkerTap() {
    // Handle marker tap
  }

  Future<Set<Marker>> showMeetingLocation(Meeting meeting) async {
    Set<Marker> markers = {};

    var meetingLocation = meeting.location;
    Client? client = await clientRepo.getById(meeting.clientId);
    var clientName = client?.name;

    markers.add(
      Marker(
        markerId: MarkerId('marker_${markers.length + 1}'),
        position: LatLng(meetingLocation.latitude, meetingLocation.longitude),
        infoWindow: InfoWindow(
          title: 'Meeting with $clientName}',
          snippet: 'at ${meetingLocation.address}',
          onTap: () async {
            await drawRouteToMeeting(
                LatLng(meetingLocation.latitude, meetingLocation.longitude));
          },
        ),
      ),
    );

    print(markers);

    return markers;
  }

  Future<Set<Marker>> extractMarkersFromMeetings(List<Meeting> meetings) async {
    Set<Marker> markers = {};

    for (var meeting in meetings) {
      var meetingLocation = meeting.location;

      // Fetch client details asynchronously
      Client? client = await clientRepo.getById(meeting.clientId);
      var clientName = client?.name ?? 'Unknown Client';

      print(LatLng(meetingLocation.latitude,
          meetingLocation.longitude)); // Debugging the meeting location

      // Add marker to the set
      markers.add(
        Marker(
          markerId: MarkerId('marker_${markers.length + 1}'),
          position: LatLng(meetingLocation.latitude, meetingLocation.longitude),
          infoWindow: InfoWindow(
            title: 'Meeting with $clientName',
            snippet: 'at ${meetingLocation.address}',
            onTap: () async {
              await drawRouteToMeeting(
                LatLng(meetingLocation.latitude, meetingLocation.longitude),
              );
            },
          ),
        ),
      );
    }

    return markers;
  }

  location_model.Location selectLocation(BuildContext context) {
    return location_model.Location(
      coordinates: selectedLocation.coordinates,
      address: selectedLocation.address,
    );
  }

  Future<void> drawRouteToMeeting(LatLng destination) async {
    List<LatLng> routePoints = await getRouteCoordinates(
        currentLocation.coordinates, destination, 'YOUR_API_KEY');

    if (routePoints.isNotEmpty) {
      routePolyline = Polyline(
        polylineId: const PolylineId('route_polyline'),
        color: Colors.blue,
        width: 5,
        points: routePoints,
      );

      isRouteActive = true; // Set route active

      notifyListeners(); // Notify listeners to update the map
    }
  }

  void clearRoute() {
    routePolyline = const Polyline(
      polylineId: PolylineId('empty_polyline'),
      color: Colors.transparent,
      width: 0,
      points: [],
    );
    isRouteActive = false; // Set route inactive
    notifyListeners(); // Notify listeners to update the map and UI
  }
}
