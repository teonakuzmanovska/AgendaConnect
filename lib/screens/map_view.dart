import 'package:client_meeting_scheduler/models/meeting.dart'; // Import your Meeting model
import 'package:client_meeting_scheduler/services/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart'; // Import Provider package for state management

class MapView extends StatefulWidget {
  final List<Meeting>
      meetings; // List of Meeting objects to be displayed on the map.

  const MapView({Key? key, required this.meetings})
      : super(key: key); // Constructor to initialize the meetings list.

  @override
  _MapViewState createState() =>
      _MapViewState(); // Create state for the MapView widget.
}

class _MapViewState extends State<MapView> {
  GoogleMapController?
      _mapController; // Controller to interact with the Google Map.

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.onMapCreated(
        controller); // Notify the provider that the map is created
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: true);

    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<Set<Marker>>(
            future: locationProvider.extractMarkersFromMeetings(
                widget.meetings), // Await the future of markers
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading spinner while waiting for the markers
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Handle any error
                return const Center(child: Text('Error loading map markers'));
              } else if (snapshot.hasData) {
                // Once data is loaded, build the map with markers
                return GoogleMap(
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: locationProvider.currentLocation.coordinates,
                    zoom: 15.0,
                  ),
                  markers:
                      snapshot.data ?? {}, // Use the markers from the future
                  circles: {locationProvider.currentLocationCircle},
                  polylines: locationProvider.routePolyline != null
                      ? {locationProvider.routePolyline!}
                      : {},
                );
              } else {
                return const Center(child: Text('No meetings found'));
              }
            },
          ),
          if (locationProvider.isRouteActive)
            Positioned(
              bottom: 20,
              left: 20,
              child: ElevatedButton(
                onPressed: () {
                  locationProvider.clearRoute();
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Exit Route',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
