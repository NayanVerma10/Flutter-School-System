import 'package:Schools/Screens/SchoolScreens/setTimeTable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentsTimeTable extends StatefulWidget {
  String cn, sn, scode;
  StudentsTimeTable(this.scode, this.cn, this.sn);
  _StudentsTimeTableState createState() =>
      _StudentsTimeTableState(scode, cn, sn);
}

const List<String> tabNames = const <String>[
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

class _StudentsTimeTableState extends State<StudentsTimeTable> {
  String cn, sn, scode;
  _StudentsTimeTableState(this.scode, this.cn, this.sn);
  List<BottomNavigationBarItem> items;
  DocumentSnapshot doc;
  bool inProcess;
  String index;
  Map<String, List<Widget>> list;
  @override
  void initState() {
    super.initState();
    items = List<BottomNavigationBarItem>();
    list = Map<String, List<Widget>>();
    index = 'Monday';
    tabNames.forEach((element) {
      list[element] = List<Widget>();
      items.add(BottomNavigationBarItem(
          icon: Text(
            element,
            style: TextStyle(
                fontWeight: index.compareTo(element) == 0
                    ? FontWeight.bold
                    : FontWeight.normal),
          ),
          title: Text('')));
    });
    loadData();
    inProcess = true;
  }

  Future<void> loadData() async {
    setState(() {
      inProcess = true;
    });
    await FirebaseFirestore.instance
        .collection('School')
        .doc(scode)
        .collection('Time Table')
        .doc(cn + '-' + sn)
        .get()
        .then((event) {
      if (event != null && event.data() != null) {
        Map<String, List<Widget>> tempList = Map<String, List<Widget>>();

        Map<String, List<String>> tempy1 = Map<String, List<String>>();
        tabNames.forEach((element) {
          tempList[element] = List<Widget>();
          tempy1[element] = List<String>();
        });
        event.data().forEach((key, value) {
          list[key] = List<Widget>();
          value.forEach((lecture) {
            tempList[key].add(_buildListTile(lecture['start time'],
                lecture['end time'], lecture['subject']));
            tempy1[key].add(lecture['start time']);
          });
        });
        // tempy1.forEach((key, value) {
        //   value.forEach((element) {
        //     print(element);
        //   });
        //   for (int i = 0; i < value.length; i++) {
        //     for (int j = 0; j < value.length; j++) {
        //       if (compare(value[i], value[j]) == 0) {
        //         String te = tempy1[key][i];
        //         tempy1[key][i] = tempy1[key][j];
        //         tempy1[key][j] = te;
        //         Card tem = tempList[key][i];
        //         tempList[key][i] = tempList[key][j];
        //         tempList[key][j] = tem;
        //       }
        //     }
        //   }
        //   value.forEach((element) {
        //     print(element);
        //   });
        // });
        setState(() {
          list = tempList;
        });
      }
      setState(() {
        inProcess = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    items = List<BottomNavigationBarItem>();
    tabNames.forEach((element) {
      items.add(BottomNavigationBarItem(
          icon: Text(
            element,
            style: TextStyle(
                fontWeight: index.compareTo(element) == 0
                    ? FontWeight.bold
                    : FontWeight.normal),
          ),
          title: Text('')));
    });
    return Scaffold(
      body: inProcess
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await loadData();
              },
              child: list[index].isNotEmpty
                  ? ListView(children: list[index])
                  : Stack(
                      children: <Widget>[
                        Center(
                          child: Text('Nothing to show here!',
                              style: TextStyle(fontSize: 20)),
                        ),
                        ListView(),
                      ],
                    ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabNames.indexOf(index),
        items: items,
        onTap: (i) {
          setState(() {
            index = tabNames[i];
          });
        },
      ),
    );
  }

  Widget _buildListTile(String st, String et, String subject) {
    return Card(
        elevation: 5,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              ListTile(
                title: Text(
                  subject,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(
                height: 2,
                indent: 20,
                endIndent: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, top: 5, right: 15),
                child: Text(
                  "$st  to  $et",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ]));
  }
}
