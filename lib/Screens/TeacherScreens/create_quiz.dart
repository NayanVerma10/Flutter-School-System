import 'package:flutter/material.dart';
import 'database.dart';
import 'add_question.dart';
import 'package:Schools/widgets/widget.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {

  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {

  DatabaseService databaseService = db;
  final _formKey = GlobalKey<FormState>();

  String quizImgUrl, quizTitle, quizDesc;

  bool isLoading = false;
  String quizId;

  _CreateQuizState();


  createQuiz(){

    quizId = randomAlphaNumeric(16);
    if(_formKey.currentState.validate()){

      setState(() {
        isLoading = true;
      });

      Map<String, String> quizData = {
        "quizImgUrl" : quizImgUrl,
        "quizId":quizId,
        "quizTitle" : quizTitle,
        "quizDesc" : quizDesc
      };

      databaseService.addQuizData(quizData, quizId).then((value){
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) =>  AddQuestion(quizId)
        ));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black54,
        ),
        title: AppLogo(),
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        //brightness: Brightness.li,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24,vertical: 0),
          child: Column(
            children: [
              Spacer(),
            TextFormField(
              validator: (val) => val.isEmpty ? "Enter Quiz Image Url" : null,
              decoration: InputDecoration(
                hintText: "Quiz Image Url (Optional)"
              ),
              onChanged: (val){
                quizImgUrl = val;
              },
            ),
            SizedBox(height: 5,),
            TextFormField(
              validator: (val) => val.isEmpty ? "Enter Quiz Title" : null,
              decoration: InputDecoration(
                hintText: "Quiz Title"
              ),
              onChanged: (val){
                quizTitle = val;
              },
            ),
            SizedBox(height: 5,),
            TextFormField(
              validator: (val) => val.isEmpty ? "Enter Quiz Description" : null,
              decoration: InputDecoration(
                  hintText: "Quiz Description"
              ),
              onChanged: (val){
               quizDesc = val;
              },
            ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  createQuiz();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(
                      horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Create Quiz",
                    style: TextStyle(
                        fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
          ],)
          ,),
      ),
    );
  }
}
