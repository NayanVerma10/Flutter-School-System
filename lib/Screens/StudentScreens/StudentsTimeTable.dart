import 'package:flutter/material.dart';

class StudentsTimeTable extends StatefulWidget {
  final Color color;
  final bool edit;

  StudentsTimeTable({this.color, this.edit = false});

  _StudentsTimeTableState createState() => _StudentsTimeTableState();
}

const List<String> tabNames = const <String>[
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thrusday',
  'Friday',
  'Saturday'
];

class _StudentsTimeTableState extends State<StudentsTimeTable>  with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool edit = false;
  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(vsync: this, initialIndex: 0, length: tabNames.length);
  }
  @override
  Widget build(BuildContext context) {
    edit = widget.edit;
    return Scaffold(
      backgroundColor: widget.color ?? Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListView.builder(
          itemCount: 8,
          itemBuilder: (context, index) => buildListTile(index),
        ),

      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Container(),
          AnimatedCrossFade(
            firstChild: Material(
              color: Theme.of(context).primaryColor,
              child: TabBar(
                indicatorColor: Colors.white,
                controller: _tabController,
                isScrollable: true,
                tabs: List.generate(tabNames.length, (index) {
                  return Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        tabNames[index].toUpperCase(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                }),
              ),
            ),
            secondChild: Container(),
            crossFadeState: CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Card buildListTile(int index) {
    return Card(
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          ListTile(
            title: !edit
                ? Text(
              'Lecture ${index + 1}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
                : TextField(
              maxLines: 1,
              expands: false,
              controller: TextEditingController(text: 'Subject name'),
              enableInteractiveSelection: true,
              keyboardType: TextInputType.text,
              autocorrect: true,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Lecture ${index + 1}',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onLongPress: () {
              edit = !edit;
              setState(() {});
            },
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 6,
                ),
                !edit
                    ? Text(
                  "Teacher ${index + 1}",
                  style: TextStyle(fontWeight: FontWeight.w500),
                )
                    : TextField(
                  maxLines: 1,
                  expands: false,
                  controller: TextEditingController(text: 'Teacher name'),
                  enableInteractiveSelection: true,
                  keyboardType: TextInputType.text,
                  autocorrect: true,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Teacher name',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 2,
            indent: 20,
            endIndent: 20,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: !edit ? 25 : 15, top: 5, right: !edit ? 25 : 15),
            child: !edit
                ? Text(
              "$index:00 A.M  to  ${index + 1}:30 A.M",
              style: TextStyle(fontWeight: FontWeight.bold
                // fontFamily: 'Ninto',
              ),
            )
                : Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    maxLines: 1,
                    expands: false,
                    controller:
                    TextEditingController(text: '$index:00 A.M'),
                    enableInteractiveSelection: true,
                    keyboardType: TextInputType.datetime,
                    autocorrect: true,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Start time',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Text(
                  " to ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Expanded(
                  child: TextField(
                    maxLines: 1,
                    expands: false,
                    controller: TextEditingController(
                        text: '${index + 1}:30 A.M'),
                    enableInteractiveSelection: true,
                    keyboardType: TextInputType.datetime,
                    autocorrect: true,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'End time',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          edit
              ? FlatButton(
            onPressed: () {},
            child: Text(
              'Save',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}
