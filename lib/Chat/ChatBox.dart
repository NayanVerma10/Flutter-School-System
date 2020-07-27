import 'package:flutter/material.dart';


class ChatBox extends StatefulWidget {
  String schoolCode,sender_docId,reciever_docId;
  bool sender_isTeacher,reciever_isTeacher;
  ChatBox(this.schoolCode,this.sender_docId,this.sender_isTeacher,this.reciever_docId,this.reciever_isTeacher);

  @override
  _ChatBoxState createState() => _ChatBoxState(schoolCode,sender_docId,sender_isTeacher,reciever_docId,reciever_isTeacher);
}

class _ChatBoxState extends State<ChatBox> {

  String schoolCode,sender_docId,reciever_docId;
  bool sender_isTeacher,reciever_isTeacher;
  _ChatBoxState(this.schoolCode,this.sender_docId,this.sender_isTeacher,this.reciever_docId,this.reciever_isTeacher);
  
  
  Future<void> loadData()
  {

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(schoolCode);
  
    loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text('')
          ],
        ),
      ),
      body: Center(child: Text('TODO'),),
      
    );
  }
}