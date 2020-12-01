import 'package:Schools/Screens/StudentScreens/attendDetails.dart';
import 'package:Schools/widgets/AlertDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'attendance.dart' as at;

class EditAttendance extends StatefulWidget {
  final DocumentSnapshot snapshot;
  final String path;
  EditAttendance(this.path, this.snapshot);

  @override
  _EditAttendanceState createState() => _EditAttendanceState(path, snapshot);
}

class _EditAttendanceState extends State<EditAttendance> {
  DocumentSnapshot snapshot;
  String path;

  Map<String, bool> map;
  int count = 0;
  bool editMode = false;
  List<String> keys;
  _EditAttendanceState(this.path, this.snapshot);
  @override
  void initState() {
    super.initState();
    map = Map<String, bool>();
    keys = List();
    snapshot.data().forEach((key, value) {
      map[key] = value;
      if (value) count++;
    });
    keys = map.keys.toList();
    mergeSort<String>(keys);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = List<Widget>();
    List<Widget> list1 = List<Widget>();
    list.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 10,
        spacing: 20,
        children: [
          RaisedButton(
            child: Text(
              count == map.length ? 'Unselect All' : 'Select All',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              bool val = (!(count == map.length));
              setState(() {
                map.forEach((key, value) {
                  setState(() {
                    map[key] = val;
                  });
                });
                count = val ? map.length : 0;
              });
            },
            color: Colors.black,
          ),
          RaisedButton(
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () {
                setState(() {
                  editMode = false;
                });
              },
              color: Colors.black),
          RaisedButton(
              disabledColor: Colors.black,
              child: Text('Selected : $count',
                  style: TextStyle(color: Colors.white)),
              onPressed: null,
              color: Colors.black),
        ],
      ),
    ));
    keys.forEach((key) {
      list.add(Card(
        child: ListTile(
          leading: Checkbox(
            value: map[key],
            onChanged: (val) {
              setState(() {
                if (map[key]) {
                  count--;
                } else {
                  count++;
                }
                map[key] = val;
              });
            },
          ),
          title: Text(key.split('#')[1]),
          subtitle: Text(key.split('#')[0]),
          onTap: () {
            setState(() {
              if (map[key]) {
                count--;
              } else {
                count++;
              }
              map[key] = (!map[key]);
            });
          },
        ),
      ));
      list1.add(Card(
        child: ListTile(
          title: Text(key.split('#')[1]),
          subtitle: Text(key.split('#')[0]),
          trailing: Text(
            map[key] ? 'Present' : 'Absent',
            style: TextStyle(
                color: map[key] ? Colors.green[500] : Colors.red[500],
                fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AttendDetails(path, key.split('#')[0],
                        key.split('#')[1], key.split('#')[2], false)));
          },
        ),
      ));
    });
    list.add(SizedBox(
      height: 50,
    ));
    list1.add(SizedBox(
      height: 50,
    ));
    return Scaffold(
      appBar: AppBar(
        title: Text(at.stringToTime(snapshot.id)[0]),
        
      ),
      body: ListView(
        children: editMode ? list : list1,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          editMode ? Icons.done : Icons.edit,
        ),
        backgroundColor: Colors.black,
        onPressed: () async {
          if (editMode) {
            showLoaderDialog(context, 'Updating data....');
            await snapshot.reference
                .set(map)
                .catchError((error) =>
                    Toast.show('Error while updating data....', context))
                .whenComplete(
                    () => Toast.show('Updated Successfully', context));
            Navigator.of(context).pop();
          }
          setState(() {
            editMode = (!editMode);
          });
        },
      ),
    );
  }
}
