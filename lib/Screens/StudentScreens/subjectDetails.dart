import 'package:flutter/material.dart';
import './assignment.dart';
import './attendDetails.dart';
import './discussions.dart';

import './tutorials.dart';
import './grades.dart';

import 'package:pie_chart/pie_chart.dart';

class SubjectDetails extends StatefulWidget {
  final String subjName;
  SubjectDetails({Key key, this.subjName}) : super(key: key);
  @override
  _SubjectDetailsState createState() => _SubjectDetailsState(subjName);
}

class _SubjectDetailsState extends State<SubjectDetails>
    with SingleTickerProviderStateMixin {
  final String subjName;
  _SubjectDetailsState(this.subjName);
  String teacherName = 'Bobin Padoriya';
  List<Color> colorlist = [
    Colors.blue[900],
    Colors.red,
  ];

  Map<String, double> dataMap = new Map();
  @override
  void initState() {
    super.initState();
    dataMap.putIfAbsent("Present", () => 6);
    dataMap.putIfAbsent("Absent", () => 3);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _animationController = AnimationController(duration: Duration(seconds: 1), vsync: this);
  //   _animation = IntTween(begin: 100, end: 0).animate(_animationController);
  //   _animation.addListener(() => setState(() {}));
  //   _animationController.value=1;      // 1 if pehle se full covered ho
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            subjName,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          iconTheme: new IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.chat,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Discussions()));
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(children: [
                new Container(
                  margin: const EdgeInsets.only(
                      left: 15.0, top: 30.0, bottom: 10, right: 15),
                  width: 80.0,
                  height: 80.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          image: ExactAssetImage('assets/images/tutorials.png'),
                          fit: BoxFit.cover)),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 30.0, bottom: 10),
                    height: 70,
                    child: VerticalDivider(color: Colors.grey)),
                Flexible(
                    child: Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  child: ListTile(
                    title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tutorials',
                            style: TextStyle(
                                backgroundColor: Colors.grey[300],
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                          Text(
                            'Completed: 0',
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            'Pending: 0',
                            style: TextStyle(fontSize: 15),
                          )
                        ]),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.black,
                    ),
                    onTap: () {
                      //                                  <-- onTap
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Tutorials()));
                      });
                    },
                    //  leading: Icon(icons[index]),
                    // title: Text(titles[index]),
                  ),
                )),
                // Container(
                //   margin: const EdgeInsets.only(left: 10.0, top: 30.0,bottom: 10,
                //       ),
                //   height: 60,
                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                // Text('Tutorial',
                // style: TextStyle(
                //   backgroundColor: Colors.grey[300],
                //   fontWeight: FontWeight.bold,
                //   fontSize: 17
                //   ),
                // ),
                // Text('Completed:0'),
                // Text('Pending:0')
                // ]),
                //   //color: Colors.blue,
                //   padding: EdgeInsets.all(4),
                //   )
              ]),
              Row(children: [
                new Container(
                  margin: const EdgeInsets.only(
                      left: 15.0, top: 30.0, bottom: 10, right: 15),
                  width: 80.0,
                  height: 80.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          image:
                              ExactAssetImage('assets/images/assignment.png'),
                          fit: BoxFit.cover)),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 30.0, bottom: 10),
                    height: 70,
                    child: VerticalDivider(color: Colors.grey)),
                Flexible(
                    child: Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  child: ListTile(
                    title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Assignments',
                            style: TextStyle(
                                backgroundColor: Colors.grey[300],
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                          Text(
                            'Completed: 0',
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            'Pending: 0',
                            style: TextStyle(fontSize: 15),
                          )
                        ]),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.black,
                    ),
                    onTap: () {
                      //                                  <-- onTap
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Assignments()));
                      });
                    },
                    //  leading: Icon(icons[index]),
                    // title: Text(titles[index]),
                  ),
                )),
              ]),
              Container(
                margin: const EdgeInsets.only(
                  left: 0.0,
                  top: 20,
                ),
                child: Text(
                  'Attendance',
                  style: TextStyle(
                      fontSize: 17,
                      backgroundColor: Colors.grey[300],
                      fontWeight: FontWeight.bold),
                ),
              ),

              Row(children: [
                new Container(
                  margin: const EdgeInsets.only(
                      left: 15.0, top: 10, bottom: 10, right: 15),
                  width: 80.0,
                  height: 80.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          image:
                              ExactAssetImage('assets/images/attendance.jpg'),
                          fit: BoxFit.cover)),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 0.0, bottom: 10),
                    height: 100,
                    child: VerticalDivider(color: Colors.grey)),
                // color: Colors.red,

                // Text('Attendance',
                // style: TextStyle(
                //   fontSize: 17,
                //   backgroundColor: Colors.grey[300],
                //   fontWeight: FontWeight.bold
                // ),
                // ),

                //SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 20.0,
                        top: 0,
                      ),
                      child: Text(
                        'Attendance',
                        style: TextStyle(
                            fontSize: 17,
                            backgroundColor: Colors.grey[300],
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      // color: Colors.yellow,
                      margin: const EdgeInsets.only(
                        left: 5.0,
                        top: 10,
                        bottom: 10,
                      ),
                      height: 110,

                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AttendDetails()));
                            });
                          },
                          child: Row(children: [
                            PieChart(
                              dataMap: dataMap,
                              chartLegendSpacing: 15.0,
                              chartRadius: 110,
                              colorList: colorlist,
                              legendPosition: LegendPosition.right,
                              chartType: ChartType.ring,
                              chartValueBackgroundColor: Colors.grey[200],
                              chartValueStyle: defaultChartValueStyle.copyWith(
                                color: Colors.blueGrey[900].withOpacity(0.9),
                              ),
                              showChartValueLabel: true,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(Icons.keyboard_arrow_right)
                          ])),

                      //color: Colors.blue,
                      padding: EdgeInsets.all(4),
                    ),
                  ],
                ),
              ]),

              //     Container(
              //      // color: Colors.yellow,
              //       margin: const EdgeInsets.only(left: 5.0, top: 10,   bottom: 10,
              //           ),
              //       height: 120,

              //       child: PieChart(
              //     dataMap: dataMap,
              //     chartLegendSpacing: 15.0,
              //     chartRadius: 100,
              //     colorList: colorlist,
              //     legendPosition: LegendPosition.right,
              //     chartType: ChartType.ring,
              //     chartValueBackgroundColor: Colors.grey[200],
              //     chartValueStyle: defaultChartValueStyle.copyWith(
              //   color: Colors.blueGrey[900].withOpacity(0.9),
              // ),
              // showChartValueLabel: true,
              //               ),

              //       //color: Colors.blue,
              //       padding: EdgeInsets.all(4),
              //       ),

              Row(children: [
                new Container(
                  margin: const EdgeInsets.only(
                      left: 15.0, top: 30.0, bottom: 10, right: 15),
                  width: 80.0,
                  height: 80.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          image: ExactAssetImage('assets/images/mteacher.png'),
                          fit: BoxFit.cover)),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 30.0, bottom: 10),
                    height: 70,
                    child: VerticalDivider(color: Colors.grey)),
                Container(
                  margin: const EdgeInsets.only(
                    left: 10.0,
                    top: 50.0,
                    bottom: 10,
                  ),
                  height: 50,
                  child: Text(
                    'Teacher: $teacherName',
                    style: TextStyle(
                        backgroundColor: Colors.grey[300],
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  //color: Colors.blue,
                  padding: EdgeInsets.all(4),
                )
              ]),

              Row(children: [
                new Container(
                  margin: const EdgeInsets.only(
                      left: 15.0, top: 30.0, bottom: 10, right: 15),
                  width: 80.0,
                  height: 80.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          image: ExactAssetImage('assets/images/grades.png'),
                          fit: BoxFit.cover)),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 30.0, bottom: 10),
                    height: 70,
                    child: VerticalDivider(color: Colors.grey)),
                Flexible(
                    child: Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  child: ListTile(
                    title: Text(
                      'Grades',
                      style: TextStyle(
                          backgroundColor: Colors.grey[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),

                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.black,
                    ),
                    onTap: () {
                      //                                  <-- onTap
                      setState(() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Grades()));
                      });
                    },
                    //  leading: Icon(icons[index]),
                    // title: Text(titles[index]),
                  ),
                )),
              ]),
              //     Row(
              //   children: <Widget>[
              //     Expanded(
              //       flex: 100,
              //       child: Container(
              //          margin: EdgeInsets.only(left: 80, top: 30.0, right: 0
              //         ),
              //        // padding: _animationController.value==0? EdgeInsets.fromLTRB(100, 5, 0, 10):
              //        // EdgeInsets.symmetric(),
              //         height: 60,
              //         width: 40,
              //         color: Colors.pink,
              //       child: IconButton(
              //         icon:  Icon(Iconss.user_tie,
              //         size: 50,
              //         ),
              //         onPressed: () {
              //           if (_animationController.value == 0.0) {
              //             _animationController.forward();
              //             print(_animationController.value);

              //           } else {
              //             _animationController.reverse();
              //             print(_animationController.value);
              //           }
              //         },
              //       ),
              //       ),
              //     ),

              //     Expanded(
              //       flex: _animation.value,
              //       // Uses to hide widget when flex is going to 0
              //       child: SizedBox(
              //         width: 0.0,
              //         child: Container(
              //           child: FittedBox(    //Add this
              //             child: Row(
              //               children: [
              //         //          Container(
              //         // margin: EdgeInsets.only(top: 30.0),
              //         // height: 50, child: VerticalDivider(color: Colors.grey)),
              //   Container(
              //     margin: EdgeInsets.only(left: 0, top: 30.0, right: 40.0
              //         ),
              //     height: 50,
              //     child: Text('Teacher: $teacherName',
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       fontSize: 10
              //       ),
              //     ),
              //     //color: Colors.blue,
              //     padding: EdgeInsets.all(4),
              //     )
              //               ]
              //               )
              //           ),

              //         ),
              //       ),
              //     )
              //   ],
              // ),
            ],
          ),
        ));
  }
}
