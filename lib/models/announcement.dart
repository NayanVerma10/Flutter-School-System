import 'package:firebase_helpers/firebase_helpers.dart';

class AnnouncementModel extends DatabaseItem{
  final String id;
  final String title;
  final String description;
  final DateTime date;

  AnnouncementModel({this.id,this.title, this.description, this.date}):super(id);

  factory AnnouncementModel.fromMap(Map data) {
    return AnnouncementModel(
      title: data['title'],
      description: data['description'],
      date: data['date'],
    );
  }

  factory AnnouncementModel.fromDS(String id, Map<String,dynamic> data) {
    return AnnouncementModel(
      id: id,
      title: data['title'],
      description: data['description'],
      date: data['date'].toDate(),
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "title":title,
      "description": description,
      "date":date,
      "id":id,
    };
  }
}
