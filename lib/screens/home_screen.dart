import 'package:client_meeting_scheduler/authentication/logout_prompt.dart';
import 'package:client_meeting_scheduler/models/client.dart';
import 'package:client_meeting_scheduler/models/meeting.dart';
import 'package:client_meeting_scheduler/repo/client_repository.dart';
import 'package:client_meeting_scheduler/repo/meeting_repository.dart';
import 'package:client_meeting_scheduler/screens/map_view.dart';
import 'package:client_meeting_scheduler/services/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import provider

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ClientRepository clientRepo = ClientRepository();
  final MeetingRepository meetingRepo = MeetingRepository();

  List<Client> _clients = [];
  List<Meeting> _meetings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Fetch clients and meetings
      List<Client> clients = await clientRepo.fetchAllClients();
      List<Meeting> meetings = await meetingRepo.fetchAllMeetings();

      setState(() {
        _clients = clients;
        _meetings = meetings;
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to load data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          'assets/images/black_logo.png',
          fit: BoxFit.contain,
          height: 32,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Upcoming Meetings Section
                  const Text(
                    "Upcoming Meetings",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 150,
                    child: _meetings.isEmpty
                        ? Center(child: Text("No meetings for today"))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _meetings.length,
                            itemBuilder: (context, index) {
                              final meeting = _meetings[index];
                              final client = _clients.firstWhere(
                                (client) => client.id == meeting.clientId,
                                orElse: () => Client(
                                  id: 'unknown',
                                  name: 'Unknown',
                                  email: 'N/A',
                                  phone: 'N/A',
                                ),
                              );
                              return Card(
                                child: Container(
                                  width: 180,
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Client: ${client.name}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                          "Date: ${DateFormat('yyyy-MM-dd').format(meeting.dateTime)}"),
                                      Text(
                                          "Time: ${DateFormat('HH:mm').format(meeting.dateTime)}"),
                                      Text(
                                        "Location: ${meeting.location.address}",
                                        maxLines: 2, // Limit to 2 lines
                                        overflow: TextOverflow
                                            .ellipsis, // Add ellipsis if it overflows
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Quick Actions Section
                  const Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to CreateMeetingForm screen
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             const CreateMeetingForm()));
                          },
                          icon: Icon(Icons.add),
                          label: const Text("New Meeting"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to Calendar screen
                          },
                          icon: Icon(Icons.calendar_today),
                          label: const Text("View Calendar"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Map Overview Section
                  const Text(
                    "Map Overview",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 100,
                    color: Colors.grey[200],
                    child: Consumer<LocationProvider>(
                      builder: (context, locationProvider, child) {
                        if (locationProvider.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target:
                                locationProvider.currentLocation.coordinates,
                            zoom: 12,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            // Additional map configuration can go here
                          },
                          onTap: (LatLng position) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapView(
                                  meetings: _meetings,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Recent Activity Section
                  const Text(
                    "Recent Activity",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.update, color: Colors.brown),
                        title: Text("Rescheduled meeting with XYZ Co."),
                        subtitle: Text("2 hours ago"),
                      ),
                      ListTile(
                        leading: Icon(Icons.update, color: Colors.brown),
                        title: Text("New meeting with ABC Corp."),
                        subtitle: Text("Yesterday"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Client Directory Section
                  const Text(
                    "Client Directory",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: _clients
                        .map((client) => ListTile(
                              leading: Icon(Icons.person, color: Colors.brown),
                              title: Text(client.name),
                              subtitle: Text(client.email),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
    );
  }
}
