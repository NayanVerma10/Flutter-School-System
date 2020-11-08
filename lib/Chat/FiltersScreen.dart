import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'CreateGroupUsersList.dart';

class FiltersScreen extends StatefulWidget {
  final List<dynamic> oldUsers;
  final Map<String, bool> classes, section, subject, gender;
  final String rollno;
  FiltersScreen(
      {this.oldUsers,
      this.classes,
      this.section,
      this.subject,
      this.gender,
      this.rollno});

  @override
  _FiltersScreenState createState() => _FiltersScreenState(
      oldUsers: oldUsers,
      classes: classes,
      section: section,
      subject: subject,
      gender: gender,
      rollno: rollno);
}

class _FiltersScreenState extends State<FiltersScreen> {
  int count = 0;
  List<dynamic> oldUsers, newUsers;
  List<Widget> classesList, sectionsList, subjectList, genderList;
  Map<String, bool> classes, section, subject, gender;
  int classesSelected = 0,
      sectionSelected = 0,
      subjectSelected = 0,
      genderSelected = 0;
  bool isRollNoSelected = false;
  String rollno = "";

  _FiltersScreenState(
      {this.oldUsers,
      this.classes,
      this.section,
      this.subject,
      this.gender,
      this.rollno});
  @override
  void initState() {
    super.initState();

    classesSelected = classes.values.where((element) => element).length;
    sectionSelected = section.values.where((element) => element).length;
    subjectSelected = subject.values.where((element) => element).length;
    genderSelected = gender.values.where((element) => element).length;
    if (rollno.length > 0) {
      isRollNoSelected = true;
    }
    count =
        classesSelected + sectionSelected + genderSelected + subjectSelected;
  }

  @override
  Widget build(BuildContext context) {
    classesList = List();
    sectionsList = List();
    subjectList = List();
    genderList = List();
    for (String s in classes.keys) {
      if (s != '') {
        classesList.add(FilterChip(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(color: Colors.black, width: 1.2)),
          label: Text(
            s,
          ),
          labelStyle: TextStyle(
              fontSize: 20, color: classes[s] ? Colors.white : Colors.black),
          onSelected: (val) {
            if (val == true) {
              count++;
              classesSelected++;
            } else {
              count--;
              classesSelected--;
            }
            setState(() {
              classes[s] = val;
            });
          },
          selected: classes[s],
          backgroundColor: Colors.white,
          selectedColor: Colors.black,
          checkmarkColor: Colors.white,
        ));
      }
    }
    for (String s in section.keys) {
      if (s != '') {
        sectionsList.add(FilterChip(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(color: Colors.black, width: 1.2)),
          label: Text(
            s,
          ),
          labelStyle: TextStyle(
              fontSize: 20, color: section[s] ? Colors.white : Colors.black),
          onSelected: (val) {
            if (val == true) {
              count++;
              sectionSelected++;
            } else {
              count--;
              sectionSelected--;
            }
            setState(() {
              section[s] = val;
            });
          },
          selected: section[s],
          backgroundColor: Colors.white,
          selectedColor: Colors.black,
          checkmarkColor: Colors.white,
        ));
      }
    }
    for (String s in subject.keys) {
      if (s != '') {
        subjectList.add(FilterChip(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(color: Colors.black, width: 1.2)),
          label: Text(
            s,
          ),
          labelStyle: TextStyle(
              fontSize: 20, color: subject[s] ? Colors.white : Colors.black),
          onSelected: (val) {
            if (val == true) {
              count++;
              subjectSelected++;
            } else {
              count--;
              subjectSelected--;
            }
            setState(() {
              subject[s] = val;
            });
          },
          selected: subject[s],
          backgroundColor: Colors.white,
          selectedColor: Colors.black,
          checkmarkColor: Colors.white,
        ));
      }
    }
    gender.forEach((key, value) {
      genderList.add(FilterChip(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(color: Colors.black, width: 1.2)),
        label: Text(
          key,
        ),
        labelStyle:
            TextStyle(fontSize: 20, color: value ? Colors.white : Colors.black),
        onSelected: (val) {
          setState(() {
            if (val == true) {
              count++;
              genderSelected++;
            } else {
              count--;
              genderSelected--;
            }
            gender[key] = val;
          });
        },
        selected: value,
        backgroundColor: Colors.white,
        selectedColor: Colors.black,
        checkmarkColor: Colors.white,
      ));
    });
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Filter",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          actions: [
            FlatButton(
              child: Text(
                "Reset",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              onPressed: () {
                setState(() {
                  classes.forEach((key, value) {
                    classes[key] = false;
                  });
                  section.forEach((key, value) {
                    section[key] = false;
                  });
                  subject.forEach((key, value) {
                    subject[key] = false;
                  });
                  gender.forEach((key, value) {
                    gender[key] = false;
                  });
                  isRollNoSelected = false;
                  count = 0;
                  genderSelected = 0;
                  classesSelected = 0;
                  sectionSelected = 0;
                  subjectSelected = 0;
                  rollno = "";
                });
              },
            ),
          ],
        ),

/*--------------------------------Main Body-----------------------------------*/

        body: ListView(
          padding: EdgeInsets.all(15),
          children: [
            Center(
              child: Text(
                "Class",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                children: classesList,
              ),
            ),
            Center(
              child: Text("Section", style: TextStyle(fontSize: 30)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                children: sectionsList,
              ),
            ),
            Center(
              child: Text("Subject", style: TextStyle(fontSize: 30)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 15,
                children: subjectList,
              ),
            ),
            Center(
              child: Text("Roll Number", style: TextStyle(fontSize: 30)),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: isRollNoSelected
                  ? InputChip(
                      label: Text(
                        rollno,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onDeleted: () {
                        setState(() {
                          rollno = "";
                          isRollNoSelected = false;
                        });
                      },
                      deleteIcon: Icon(Icons.cancel),
                      deleteIconColor: Colors.white,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(color: Colors.black, width: 1.2)),
                      selected: true,
                      showCheckmark: true,
                      checkmarkColor: Colors.white,
                      selectedColor: Colors.black,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 290,
                          height: 37,
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                            onSubmitted: (value) {
                              if (rollno.length > 0) {
                                setState(() {
                                  isRollNoSelected = true;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              prefix: SizedBox(
                                width: 20,
                              ),
                              suffixIcon: rollno.length > 0
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.done,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        if (rollno.length > 0) {
                                          setState(() {
                                            isRollNoSelected = true;
                                          });
                                        }
                                      },
                                    )
                                  : null,
                              contentPadding: EdgeInsets.only(bottom: 10),
                              hintText: "Enter some part of roll number",
                              hintStyle: TextStyle(
                                  color: Colors.black54, fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.black,
                                      style: BorderStyle.solid)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.black,
                                      style: BorderStyle.solid)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.black,
                                      style: BorderStyle.solid)),
                            ),
                            onChanged: (text) {
                              setState(() {
                                rollno = text;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
            ),
            Center(
              child: Text("Gender", style: TextStyle(fontSize: 30)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                children: genderList,
              ),
            ),
          ],
        ),
        floatingActionButton:
            FloatingActionButton(child: Icon(Icons.done), onPressed: done));
  }

  void done() {
    newUsers = List();
    if (count == 0) {
      Navigator.pop(
          context, [oldUsers, classes, section, subject, gender, rollno]);
      return;
    }
    if (isRollNoSelected) {
      newUsers = oldUsers
          .whereType<Student>()
          .where((element) => ((rollnomatcher(element.rollno)) &&
              (classesSelected == 0 || classes[element.classNumber]) &&
              (genderSelected == 0 || gender[element.gender]) &&
              (subjectSelected == 0 || doesContain(element.subjects)) &&
              (sectionSelected == 0 || section[element.section])))
          .toList();
    } else {
      newUsers = oldUsers
          .where((element) => (genderSelected == 0 || gender[element.gender]))
          .toList();
      newUsers.retainWhere((element) {
        if (element.runtimeType == Teacher) {
          if (classesSelected != 0 ||
              sectionSelected != 0 ||
              subjectSelected != 0) {
            bool done1 = false, done2 = false, done3 = false;
            element.classes.forEach((classs) {
              if (classs != null) {
                if (classesSelected == 0 || classes[classs['Class']]) {
                  done1 = true;
                }
                if (sectionSelected == 0 || section[classs['Section']]) {
                  done2 = true;
                }
                if (subjectSelected == 0 || subject[classs['Subject']]) {
                  done3 = true;
                }
              }
            });
            if (element.classNumber != '' && classes[element.classNumber]) {
              done1 = true;
            }
            if (element.section != '' && section[element.section]) {
              done2 = true;
            }
            return (done1 && done2 && done3);
          } else {
            return true;
          }
        } else {
          return ((classesSelected == 0 || classes[element.classNumber]) &&
              (subjectSelected == 0 || doesContain(element.subjects)) &&
              (sectionSelected == 0 || section[element.section]));
        }
      });
    }

    Navigator.pop(
        context, [newUsers, classes, section, subject, gender, rollno]);
  }

  bool doesContain(List<dynamic> subjects) {
    for (int i = 0; i < subjects.length; i++) {
      if (subject[subjects[i]]) {
        return true;
      }
    }
    return false;
  }

  bool rollnomatcher(String rollNo) {
    Map<String, int> map1 = Map(), map2 = Map();
    rollNo.characters.forEach((element) {
      map1[element] = 0;
    });
    rollno.characters.forEach((element) {
      map2[element] = 0;
    });
    rollNo.characters.forEach((element) {
      map1[element]++;
    });
    rollno.characters.forEach((element) {
      map2[element]++;
    });
    for (String s in map2.keys) {
      if (map1[s] != map2[s]) {
        return false;
      }
    }
    return true;
  }
}
