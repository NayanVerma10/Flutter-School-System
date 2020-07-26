import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseService {
  String schoolCode,classNumber, section, subject;

  Future<void> addQuizData(Map quizData, String quizId) async {
    await Firestore.instance
        .collection("School")
        .document(schoolCode)
        .collection("Classes")
        .document(classNumber + '_' + section + '_' + subject)
        .collection("Quiz")
        .document(quizId)
        .setData(quizData)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> addQuestionData(quizData, String quizId) async {
    await Firestore.instance
        .collection("School")
        .document(schoolCode)
        .collection("Classes")
        .document(classNumber + '_' + section + '_' + subject)
        .collection("Quiz")
        .document(quizId)
        .collection("QandA")
        .add(quizData)
        .catchError((e) {
      print(e);
    });
  }

  getQuizData() async {
    return Firestore.instance.collection("School/" + schoolCode + "/Classes/"+classNumber + '_' + section + '_' + subject+"/Quiz").snapshots();
  }

  getQuestionData(String quizId) async{
    return await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Classes')
        .document(classNumber + '_' + section + '_' + subject)
        .collection('Quiz')
        .document(quizId)
        .collection('QandA')
         .getDocuments();
  }
}
DatabaseService db=new DatabaseService();
