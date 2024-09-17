import 'package:client_meeting_scheduler/models/meeting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Meeting>> fetchAllMeetings() async {
    try {
      final querySnapshot = await _firestore.collection('meetings').get();
      return querySnapshot.docs
          .map((doc) => Meeting.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Failed to fetch all meetings: $e');
      return [];
    }
  }

  Future<void> addMeeting(Meeting meeting) async {
    try {
      await _firestore.collection('meetings').add(meeting.toFirestore());
      print('Meeting added successfully');
    } catch (e) {
      print('Failed to add meeting: $e');
    }
  }
}
