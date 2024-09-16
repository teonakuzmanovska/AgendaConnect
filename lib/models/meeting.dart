import 'package:client_meeting_scheduler/models/client.dart';
import 'package:client_meeting_scheduler/models/location.dart';

class Meeting {
  late Client client;
  late Location location;
  late DateTime dateTime;
  late String details;

  Meeting(
      {required this.client, required this.location, required this.dateTime});
}
