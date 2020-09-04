import 'package:Schools/models/announcement.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:Schools/models/event.dart';

String s = '69';
void service(String schoolCode) {
  s = schoolCode;
}

DatabaseService<EventModel> eventDBS = DatabaseService<EventModel>(
    "School/" + s + "/events/",
    fromDS: (id, data) => EventModel.fromDS(id, data),
    toMap: (event) => event.toMap());
DatabaseService<AnnouncementModel> annDBS = DatabaseService<AnnouncementModel>(
    "School/" + s + "/announcements/",
    fromDS: (id, data) => AnnouncementModel.fromDS(id, data),
    toMap: (ann) => ann.toMap());
