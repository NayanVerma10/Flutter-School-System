import 'package:flutter/material.dart';
import 'package:Schools/models/announcement.dart';

class AnnouncementDetailsPage extends StatelessWidget {
  final AnnouncementModel announcement;

  const AnnouncementDetailsPage({Key key, this.announcement}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcement'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(announcement.title, style: Theme.of(context).textTheme.headline4,),
            SizedBox(height: 20.0),
            Text(announcement.description)
          ],
        ),
      ),
    );
  }
}