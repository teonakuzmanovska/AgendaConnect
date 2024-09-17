import 'package:client_meeting_scheduler/services/location_provider.dart'; // Import LocationProvider
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart'; // For address to coordinates conversion
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart'; // Import provider

class LocationSelectionView extends StatefulWidget {
  @override
  _LocationSelectionViewState createState() => _LocationSelectionViewState();
}

class _LocationSelectionViewState extends State<LocationSelectionView> {
  final TextEditingController _addressController = TextEditingController();
  LatLng? _selectedLocation;
  late GoogleMapController _mapController;
  late Marker _marker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Access LocationProvider and get current location
      final locationProvider =
          Provider.of<LocationProvider>(context, listen: false);
      setState(() {
        _selectedLocation = locationProvider.currentLocation.coordinates;
        _marker = Marker(
          markerId: MarkerId('selected_location'),
          position: _selectedLocation!,
          draggable: true,
          onDragEnd: (LatLng newPosition) {
            setState(() {
              _selectedLocation = newPosition;
            });
            _updateAddressFromLatLng(newPosition);
          },
        );
      });
    });
  }

  void _updateAddressFromLatLng(LatLng position) async {
    try {
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      final placemark = placemarks.first;
      _addressController.text =
          '${placemark.street}, ${placemark.locality}, ${placemark.country}';
    } catch (e) {
      print('Failed to get address from coordinates: $e');
    }
  }

  void _searchAddress() async {
    try {
      final addresses = await locationFromAddress(_addressController.text);
      if (addresses.isNotEmpty) {
        final location = addresses.first;
        setState(() {
          _selectedLocation = LatLng(location.latitude, location.longitude);
          _marker = Marker(
            markerId: MarkerId('selected_location'),
            position: _selectedLocation!,
            draggable: true,
            onDragEnd: (LatLng newPosition) {
              setState(() {
                _selectedLocation = newPosition;
              });
              _updateAddressFromLatLng(newPosition);
            },
          );
        });
        _mapController
            .animateCamera(CameraUpdate.newLatLng(_selectedLocation!));
      }
    } catch (e) {
      print('Failed to search address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _addressController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Address',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchAddress,
                ),
              ),
              onSubmitted: (_) => _searchAddress(),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: locationProvider.currentLocation.coordinates,
                zoom: 14,
              ),
              markers: {_marker},
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              onTap: (LatLng position) {
                setState(() {
                  _selectedLocation = position;
                  _marker = Marker(
                    markerId: MarkerId('selected_location'),
                    position: _selectedLocation!,
                    draggable: true,
                    onDragEnd: (LatLng newPosition) {
                      setState(() {
                        _selectedLocation = newPosition;
                      });
                      _updateAddressFromLatLng(newPosition);
                    },
                  );
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          if (_selectedLocation != null) {
            Navigator.pop(context, _selectedLocation);
          }
        },
      ),
    );
  }
}
