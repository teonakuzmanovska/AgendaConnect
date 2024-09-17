import 'package:client_meeting_scheduler/models/client.dart';
import 'package:client_meeting_scheduler/models/meeting.dart';
import 'package:client_meeting_scheduler/repo/client_repository.dart';
import 'package:client_meeting_scheduler/repo/meeting_repository.dart';
import 'package:client_meeting_scheduler/screens/maps/select_location.dart';
import 'package:client_meeting_scheduler/services/location_provider.dart'; // Import LocationProvider
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import provider

class CreateMeetingForm extends StatefulWidget {
  @override
  _CreateMeetingFormState createState() => _CreateMeetingFormState();
}

class _CreateMeetingFormState extends State<CreateMeetingForm> {
  final ClientRepository _clientRepo = ClientRepository();
  final MeetingRepository _meetingRepo = MeetingRepository();

  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  LatLng? _selectedLocation;
  String? _selectedClientId;

  List<Client> _clients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    try {
      final clients = await _clientRepo.fetchAllClients();
      setState(() {
        _clients = clients;
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to load clients: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectLocation() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    final location = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationSelectionView(),
      ),
    );

    if (location != null && location is LatLng) {
      setState(() {
        _selectedLocation = location;
        _addressController.text =
            '${location.latitude}, ${location.longitude}'; // Displaying coordinates

        // Get the address from coordinates and update the addressController
        locationProvider.currentLocation.coordinates = location;
        locationProvider
            .getAddressFromCoordinates(locationProvider.currentLocation)
            .then((_) {
          setState(() {
            _addressController.text = locationProvider.currentLocation.address;
          });
        });
      });
    }
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _saveMeeting() async {
    if (_selectedClientId == null || _selectedLocation == null) {
      // Handle error: client or location not selected
      return;
    }

    final meeting = Meeting(
      clientId: _selectedClientId!,
      location: FirebaseLocation(
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
        address: _addressController.text,
      ),
      dateTime: _selectedDate,
      details: _detailsController.text,
    );

    try {
      await _meetingRepo.addMeeting(meeting);
      // Handle success: Navigate back or show a success message
      Navigator.pop(context);
    } catch (e) {
      print('Failed to save meeting: $e');
      // Handle error: Show an error message
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Meeting'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // Wrap with SingleChildScrollView
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedClientId,
                    onChanged: (value) {
                      setState(() {
                        _selectedClientId = value;
                      });
                    },
                    items: _clients.map((client) {
                      return DropdownMenuItem<String>(
                        value: client.id,
                        child: Text(client.name),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Select Client',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null ? 'Please select a client' : null,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _detailsController,
                    decoration: const InputDecoration(
                      labelText: 'Meeting Details',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    minLines: 1,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _addressController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: _selectLocation,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Date and Time',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: _selectDateTime,
                      ),
                    ),
                    controller: TextEditingController(
                      text: DateFormat('yyyy-MM-dd – HH:mm')
                          .format(_selectedDate),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveMeeting,
                    child: Text('Save Meeting'),
                  ),
                ],
              ),
            ),
    );
  }
}
