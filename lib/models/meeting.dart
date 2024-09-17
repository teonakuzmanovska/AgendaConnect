import 'package:cloud_firestore/cloud_firestore.dart';

class Meeting {
  final String clientId;
  final FirebaseLocation location;
  final DateTime dateTime;
  final String details;

  Meeting({
    required this.clientId,
    required this.location,
    required this.dateTime,
    required this.details,
  });

  factory Meeting.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Meeting(
      clientId: data['clientId'] as String,
      location: FirebaseLocation(
        latitude: (data['location']['latitude'] as num).toDouble(),
        longitude: (data['location']['longitude'] as num).toDouble(),
        address: data['location']['address'] ?? '',
      ),
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      details: data['details'] as String,
    );
  }
}

class FirebaseLocation {
  final double latitude;
  final double longitude;
  final String address;

  FirebaseLocation(
      {required this.latitude, required this.longitude, required this.address});
}
