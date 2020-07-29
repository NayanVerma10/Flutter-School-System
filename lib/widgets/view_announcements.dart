import 'package:flutter/material.dart';
import 'package:Schools/models/announcement.dart';

class AnnouncementDetailsPage extends StatelessWidget {
  final AnnouncementModel announcement;

  const AnnouncementDetailsPage({Key key, this.announcement}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
//        title:
      title: RichText(
        text: TextSpan(
          style: TextStyle(
              fontSize: 18
          ),
          children: <TextSpan>[
            TextSpan(text: announcement.date.toString(), style: TextStyle(fontWeight: FontWeight.w600
                , color: Colors.white70,fontFamily:'Montserrat')),
          ],
        ),
      ),
        centerTitle: true,
        backgroundColor: Colors.black87,

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20.0),
            Text(announcement.title, style: Theme.of(context).textTheme.headline4,textAlign: TextAlign.center),
            SizedBox(height: 60.0),

            Text(announcement.description,style:Theme.of(context).textTheme.headline5,textAlign: TextAlign.justify)
          ],
        ),
      ),
    );

  }
}