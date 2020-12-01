import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseService {
  String schoolCode,classNumber, section, subject;

  Future<void> addQuizData(Map quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("School")
        .doc(schoolCode)
        .collection("Classes")
        .doc(classNumber + '_' + section + '_' + subject)
        .collection("Quiz")
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> addQuestionData(quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("School")
        .doc(schoolCode)
        .collection("Classes")
        .doc(classNumber + '_' + section + '_' + subject)
        .collection("Quiz")
        .doc(quizId)
        .collection("QandA")
        .add(quizData)
        .catchError((e) {
      print(e);
    });
  }

  getQuizData() async {
    return FirebaseFirestore.instance.collection("School/" + schoolCode + "/Classes/"+classNumber + '_' + section + '_' + subject+"/Quiz").snapshots();
  }

  getQuestionData(String quizId) async{
    return await FirebaseFirestore.instance
        .collection('School')
        .doc(schoolCode)
        .collection('Classes')
        .doc(classNumber + '_' + section + '_' + subject)
        .collection('Quiz')
        .doc(quizId)
        .collection('QandA')
        .get();
  }
}
DatabaseService db=new DatabaseService();
