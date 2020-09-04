import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_login_ui/utilities/constants.dart';
//void main() =>runApp(LoginScreen());

class SchoolRegistration extends StatefulWidget {
  @override
  _SchoolRegistrationStat createState() => _SchoolRegistrationStat();
}

class _SchoolRegistrationStat extends State<SchoolRegistration> {
  bool _rememberMe = false;
  bool _isEmailUnique = false;
  bool _isMobileUnique = false;
  bool _isSchoolCodeUnique = false;
  String x3, name, id, x2, x1, gpa, board;
  getStudentName(name) {
    this.name = name;
  }

  getStudentBoard(board) {
    this.board = board;
  }

  getStudentx3(x3) {
    this.x3 = x3;
  }

  getStudentId(id) {
    this.id = id;
  }

  getStudentx2(x2) {
    this.x2 = x2;
  }

  getStudentno(x1) {
    this.x1 = x1;
  }

  getStudentgpa(gpa) {
    this.gpa = gpa;
  }

  Future<bool> verifyemail() async {
    await Firestore.instance
        .collection('School')
        .where('schoolemail', isEqualTo: id.toLowerCase())
        .getDocuments()
        .then((value) => {if (value.documents.isEmpty) _isEmailUnique = true});
    return true;
  }

  Future<bool> verifyphone() async {
    await Firestore.instance
        .collection('School')
        .where('schoolno', isEqualTo: x1)
        .getDocuments()
        .then((value) => {if (value.documents.isEmpty) _isMobileUnique = true});
    return true;
  }

  Future<bool> verifyschoolcode() async {
    await Firestore.instance
        .collection('School')
        .document(gpa)
        .get()
        .then((value) => {if (!value.exists) _isSchoolCodeUnique = true});

    return true;
  }

  createData() {
    print("created");

    DocumentReference documentReference =
        Firestore.instance.collection("School").document(gpa);
    Map<String, dynamic> studentsm = {
      "schoolname": name,
      "schoolemail": id.toLowerCase(),
      "schoolcode": gpa,
      "password": x2,
      "schoolno": x1,
      "schoolboard": board
    };
    documentReference.setData(studentsm).whenComplete(() {
      print("$name created");
    });
  }

  readData() {
    DocumentReference documentReference =
        Firestore.instance.collection("School").document(name);
    documentReference.get().then((datasnapshot) {
      print(datasnapshot.data["schoolname"]);
      print(datasnapshot.data["schoolemail"]);
      print(datasnapshot.data["schoolcode"]);
      print(datasnapshot.data["password"]);
      print(datasnapshot.data["schoolno"]);
      print(datasnapshot.data["schoolboard"]);
    });
    print("read");
  }

  updatedata() {
    print("update");
/*DocumentReference documentReference =Firestore.instance.collection("Mystudents").document(name);
 Map< String, dynamic > students=
 {
   "studentname":name, 
   "studentid":id,
   "gpa":gpa,
   "x2":x2
 };
 documentReference.setData(students).whenComplete((){
print("$name updated");
 });
*/
  }

  deletedata() {
/*  DocumentReference documentReference =Firestore.instance.collection("Mystudents").document(name);
  documentReference.delete().whenComplete(()
  {
    print("$name has been delelted");
  });
  print("deleted");
*/
  }
  final _formKey = GlobalKey<FormState>();

  final kHintTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'OpenSans',
  );
  final kLabelStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );
  final kBoxDecorationStyle = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );
  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      //mainAxisAlignment: MainAxisAlignment,
      children: <Widget>[
        SizedBox(height: 0.0),
        Container(
          alignment: Alignment.centerLeft,
          //decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (String id) {
              getStudentId(id);
            },
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              //border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.black,
              ),
              hintText: 'Email address',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      //mainAxisAlignment: MainAxisAlignment,
      children: <Widget>[
        SizedBox(height: 0.0),
        Container(
          alignment: Alignment.centerLeft,
          //decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextFormField(
            //keyboardType: TextInputType,
            onChanged: (String name) {
              getStudentName(name);
            },

            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              //  border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.people,
                color: Colors.black,
              ),
              hintText: 'School name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCodeTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      //mainAxisAlignment: MainAxisAlignment,
      children: <Widget>[
        SizedBox(height: 0.0),
        Container(
          alignment: Alignment.centerLeft,
          //decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextFormField(
            onChanged: (String gpa) {
              getStudentgpa(gpa);
            },
            keyboardType: TextInputType.phone,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              //  border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.confirmation_number,
                color: Colors.black,
              ),
              hintText: 'School code',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      //mainAxisAlignment: MainAxisAlignment,
      children: <Widget>[
        SizedBox(height: 0.0),
        Container(
          alignment: Alignment.centerLeft,
          //decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextFormField(
            onChanged: (String x1) {
              getStudentno(x1);
            },
            keyboardType: TextInputType.phone,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              //  border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.phone,
                color: Colors.black,
              ),
              hintText: 'Phone number',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBoardTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      //mainAxisAlignment: MainAxisAlignment,
      children: <Widget>[
        SizedBox(height: 0.0),
        Container(
          alignment: Alignment.centerLeft,
          //decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextFormField(
            onChanged: (String board) {
              getStudentBoard(board);
            },
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              //border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.subject,
                color: Colors.black,
              ),
              hintText: 'Board',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 0.0),
        Container(
          alignment: Alignment.centerLeft,
          //decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextFormField(
            onChanged: (String x2) {
              getStudentx2(x2);
            },
            obscureText: true,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              //border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              hintText: 'Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildrePasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 0.0),
        Container(
          alignment: Alignment.centerLeft,
          //decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextFormField(
            onChanged: (String x3) {
              getStudentx3(x3);
            },
            obscureText: true,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              //border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              hintText: 'Confirm Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("School Registration"),
      ),
      body: Builder(
        builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFFFF),
                        Color(0xFFFFFFF),
                        Color(0xFFFFFFF),
                        Color(0xFFFFFFF),
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: Container(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 45.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          /*Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'OpenSans',
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),*/
                          SizedBox(height: 10.0),
                          _buildNameTF(),
                          SizedBox(height: 10.0),
                          _buildEmailTF(),
                          SizedBox(
                            height: 10.0,
                          ),
                          _buildNoTF(),
                          SizedBox(
                            height: 10.0,
                          ),
                          _buildBoardTF(),

                          SizedBox(
                            height: 10.0,
                          ),
                          _buildCodeTF(),

                          SizedBox(
                            height: 10.0,
                          ),
                          _buildPasswordTF(),

                          SizedBox(
                            height: 10.0,
                          ),
                          _buildrePasswordTF(),
                          //     _buildForgotPasswordBtn(),
                          //    _buildRememberMeCheckbox(),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            width: double.infinity,
                            child: RaisedButton(
                              color: Colors.black,
                              elevation: 5.0,
                              onPressed: () async {
                                // It returns true if the form is valid, otherwise returns false
                                print("button pressed");
                                await verifyphone();
                                await verifyemail();
                                await verifyschoolcode();
                                if (x2 == x3 &&
                                    _isMobileUnique &&
                                    _isEmailUnique &&
                                    _isSchoolCodeUnique) {
                                  createData();
                                  final snackBar = SnackBar(
                                      content: Text(
                                          'Data processed successfully!!'));
                                  Scaffold.of(context).showSnackBar(snackBar);
                                  Navigator.pop(context);
                                } else if (x2 != x3) {
                                  final snackBar = SnackBar(
                                      content:
                                          Text('Sorry password don\'t match!'));
                                  Scaffold.of(context).showSnackBar(snackBar);
                                } else if (!_isSchoolCodeUnique) {
                                  final snackBar = SnackBar(
                                      content: Text(
                                          'Sorry School Code aready exists!'));
                                  Scaffold.of(context).showSnackBar(snackBar);
                                } else {
                                  final snackBar = SnackBar(
                                      content: Text(
                                          'Email or Mobile number already exists!'));
                                  Scaffold.of(context).showSnackBar(snackBar);
                                }
                                _isEmailUnique = false;
                                _isMobileUnique = false;
                                _isSchoolCodeUnique = false;
                              },
                              padding: EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              // color: Colors.white,
                              child: Text(
                                " Register".toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                            ),
                          ),
                          //_buildLoginBtn(),
                          //   _buildSocialBtnRow(),
                          //                     _buildSignupBtn(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
/*
  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }
*/
/* Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }
*/

/*
  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: kLabelStyle,
        ),
      ],
    );
  }
*/
/*Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }*/
/*
  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => print('Login with Facebook'),
            AssetImage(
              'assets/logos/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
            () => print('Login with Google'),
            AssetImage(
              'assets/logos/google.jpg',
            ),
          ),
        ],
      ),
    );
  }
*/
/*  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
*/
