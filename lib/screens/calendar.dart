import 'package:client_meeting_scheduler/models/meeting.dart';
import 'package:client_meeting_scheduler/repo/meeting_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MonthlyCalendarView extends StatefulWidget {
  @override
  _MonthlyCalendarViewState createState() => _MonthlyCalendarViewState();
}

class _MonthlyCalendarViewState extends State<MonthlyCalendarView> {
  final MeetingRepository meetingRepo = MeetingRepository();
  Map<DateTime, List<Meeting>> _meetings = {};
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadMeetings();
  }

  Future<void> _loadMeetings() async {
    try {
      List<Meeting> meetings = await meetingRepo.fetchAllMeetings();
      print('Fetched meetings: $meetings');

      final Map<DateTime, List<Meeting>> meetingsMap = {};
      for (var meeting in meetings) {
        // Create a DateTime without time part for storing in the map
        final DateTime date = DateTime(meeting.dateTime.year,
            meeting.dateTime.month, meeting.dateTime.day);
        if (meetingsMap[date] == null) {
          meetingsMap[date] = [];
        }
        meetingsMap[date]!.add(meeting);
      }

      setState(() {
        _meetings = meetingsMap;
      });
    } catch (e) {
      print('Failed to load meetings: $e');
    }
  }

  List<Meeting> _getMeetingsForDay(DateTime day) {
    // Create a DateTime without time part for comparison
    final DateTime startOfDay = DateTime(day.year, day.month, day.day);
    print(
        'Fetching meetings for: ${DateFormat('yyyy-MM-dd').format(startOfDay)}');
    print(
        'Available dates: ${_meetings.keys.map((date) => DateFormat('yyyy-MM-dd').format(date))}');
    return _meetings[startOfDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Calendar View'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(DateTime.now().year - 1, 1, 1),
            lastDay: DateTime.utc(DateTime.now().year + 1, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              print(
                  'Selected Day: ${DateFormat('yyyy-MM-dd').format(selectedDay)}');
              print(
                  'Meetings for Selected Day: ${_getMeetingsForDay(selectedDay)}');
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.month,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleTextStyle:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.red),
              weekdayStyle: TextStyle(color: Colors.black),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: _getMeetingsForDay(_selectedDay).isEmpty
                ? Center(child: Text('No meetings for selected day'))
                : ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: _getMeetingsForDay(_selectedDay).map((meeting) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          title: Text(meeting.details),
                          subtitle: Text(
                            '${DateFormat('yyyy-MM-dd').format(meeting.dateTime)} ${DateFormat('HH:mm').format(meeting.dateTime)}',
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
