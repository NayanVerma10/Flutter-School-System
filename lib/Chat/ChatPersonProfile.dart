import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPersonProfile extends StatefulWidget {
  String schoolCode, userId;
  bool isTeacher;
  ChatPersonProfile(this.schoolCode, this.userId, this.isTeacher);

  @override
  _ChatPersonProfileState createState() => _ChatPersonProfileState();
}

class _ChatPersonProfileState extends State<ChatPersonProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Profile"),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection("School")
            .document(widget.schoolCode)
            .collection(widget.isTeacher ? "Teachers" : "Student")
            .document(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            DocumentSnapshot snap = snapshot.data;
            return ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.topCenter,
                  child: snap['url'] != null && snap['url'] != ""
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(snap['url']),
                          radius: 60,
                        )
                      : CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black54,
                          child: Text(snap['first name'][0].toUpperCase() +
                              snap['last name'][0].toUpperCase()),
                        ),
                ),
                ListTile(
                  title: Title("Name"),
                  subtitle:
                      Subtitle(snap['first name'] + " " + snap['last name']),
                ),
                seperator(),
                ListTile(
                  title: Title("Email Id"),
                  subtitle: Subtitle(snap['email']),
                ),
                seperator(),
                ListTile(
                  title: Title("Mobile"),
                  subtitle: Subtitle(snap['mobile']),
                ),
                seperator(),
                ListTile(
                  title: Title("Name"),
                  subtitle:
                      Subtitle(snap['first name'] + " " + snap['last name']),
                ),
                seperator(),
                ListTile(
                  title: Title("Father 's Name"),
                  subtitle: Subtitle(snap['father \'s name']),
                ),
                seperator(),
                ListTile(
                  title: Title("Mother 's Name"),
                  subtitle: Subtitle(snap['mother \'s name']),
                ),
                seperator(),
                ListTile(
                  title: Title("Roll Number"),
                  subtitle: Subtitle(snap['rollno']),
                ),
                seperator(),
                Container(
                  height: 80,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Title("Class"),
                          subtitle: Subtitle(snap['class']),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Title("Section"),
                          subtitle: Subtitle(snap['section']),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    child: Row(
                  children: [
                    Expanded(child: seperator()),
                    Expanded(child: seperator()),
                  ],
                )),
                ListTile(
                  title: Title("Gender"),
                  subtitle: Subtitle(snap['gender']),
                ),
                seperator(),
              ],
            );
          }
        },
      ),
    );
  }
}

Widget Title(String str) {
  return Text(
    str,
    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
  );
}

Widget Subtitle(String str) {
  return str != null && str.compareTo("") != 0 ? Text("\n"+str) : notavl();
}

Widget notavl() {
  return Text(
    "\nNot Available",
    style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
  );
}

Widget seperator() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Divider(
      color: Colors.black54,
      thickness: 0.8,
    ),
  );
}
