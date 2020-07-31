import 'package:flutter/material.dart';
import 'package:Schools/widgets/view_announcements.dart';
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
  // Map<String, List<dynamic>> _announcements;
  List<dynamic> _announcements;
  List<AnnouncementModel> allAnnouncements;

  @override
  void initState() {
    super.initState();
    _announcements = [];
    // _selectedAnnouncements = [];
  }

  //  Map<String, List<dynamic>> _listAnnouncements(List<AnnouncementModel> allAnnouncements) {
  //   Map<String, List<dynamic>> data = {};
  //   allAnnouncements.forEach((announcement) {
  //     if (data[title] == null) data[title] = [];
  //     data[title].add(announcement);
  //   });
  //   return data;
  // }


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
              List<AnnouncementModel> allAnnouncements = snapshot.data;
              if (allAnnouncements.isNotEmpty) {
                _announcements = allAnnouncements;
              } else {
                _announcements = [];
                // _selectedAnnouncements = [];
              }
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ..._announcements.map((announcement) => Card(
                      child:ListTile(
                        subtitle: Text(announcement.date.toString()),

                        leading: Icon(Icons.calendar_today),
                        trailing: Icon(Icons.more_vert),



                        title: Text(announcement.title
                          ,style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2),),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AnnouncementDetailsPage(
                                    announcement: announcement,
                                  )));
                        },
                      )),
                  ) ],
              ),
            );
          }),

    );
  }
}
