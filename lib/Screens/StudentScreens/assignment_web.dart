import 'package:flutter/material.dart';
import 'database.dart';
import 'package:Schools/Screens/TeacherScreens/quiz_play.dart';
import 'package:Schools/widgets/widget.dart';

class AssignmentWeb extends StatefulWidget {

  @override
  _AssignmentWebState createState() => _AssignmentWebState();
}

class _AssignmentWebState extends State<AssignmentWeb> {

  Stream quizStream;
  DatabaseService databaseService = db;


  Widget quizList() {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;


    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          StreamBuilder(
            stream: quizStream,
            builder: (context, snapshot) {
              return snapshot.data == null
                  ? Container()
                  : GridView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: (itemWidth / itemHeight),
                    crossAxisSpacing: 3.0,
                    mainAxisSpacing: 3.0,
                  ),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    print(snapshot.data.documents[index].data);
                    Duration(seconds: 2);
                    return QuizTile(
                      noOfQuestions: snapshot.data.documents.length,
                      imageUrl:
                      snapshot.data.documents[index].data['quizImgUrl'],
                      title:
                      snapshot.data.documents[index].data['quizTitle'],
                      description:
                      snapshot.data.documents[index].data['quizDesc'],
                      id: snapshot.data.documents[index].data["quizId"],
                    );
                  });
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    databaseService.getQuizData().then((value) {
      quizStream = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppLogo(),
        centerTitle: true,
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        //brightness: Brightness.li,
      ),
      body: quizList(),



    );
  }
}

class QuizTile extends StatelessWidget {
  final String imageUrl, title, id, description;
  final int noOfQuestions;

  QuizTile(
      {@required this.title,
        @required this.imageUrl,
        @required this.description,
        @required this.id,
        @required this.noOfQuestions});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => QuizPlay(id)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        height: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                color: Colors.black26,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 4,),
                      Text(
                        description,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
