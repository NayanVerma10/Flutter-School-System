import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:Schools/widgets/view_event.dart';
import 'package:Schools/models/announcement.dart';
import 'package:Schools/Screens/service.dart';

class Announcements extends StatefulWidget {
  final schoolCode;
  Announcements(this.schoolCode);
  @override
  _AnnouncementsState createState() => _AnnouncementsState(schoolCode);
}

class _AnnouncementsState extends State<Announcements> {
  _AnnouncementsState(schoolCode);
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  @override
void initState() {
    super.initState();
    _events = {};
    _selectedEvents = [];
  }
  
   Map<DateTime, List<dynamic>> _groupEvents(List<AnnouncementModel> allEvents) {
    Map<DateTime, List<dynamic>> data = {};
    allEvents.forEach((event) {
      DateTime date = DateTime(
          event.date.year, event.date.month, event.date.day, 12);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      
      appBar: AppBar(
        title: Text('Announcements'),
      ),
      
      body: StreamBuilder<List<AnnouncementModel>>(
          stream: annDBS.streamList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<AnnouncementModel> allEvents = snapshot.data;
              if (allEvents.isNotEmpty) {
                _events = _groupEvents(allEvents);
              } else {
                _events = {};
                _selectedEvents = [];
              }
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ..._selectedEvents.map((event) => ListTile(
                        title: Text(event.title),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EventDetailsPage(
                                        event: event,
                                      )));
                        },
                      )),
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, 'add_announcement'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
     );
  }
}
