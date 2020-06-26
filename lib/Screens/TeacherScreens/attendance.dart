import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import 'package:intl/intl.dart';
class Pagin1 extends StatefulWidget {
  @override
  _Pagin1State createState() => _Pagin1State();
}

class _Pagin1State extends State<Pagin1> {
String name;
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:ListPage(),
       
    );
  }
}
String schoolname;
String classTeacher;
/*readData ()
{
   DocumentReference documentReference =Firestore.instance.collection("School").document("0147");
documentReference.get().then((datasnapshot)
{   
  schoolname=datasnapshot.data["schoolname"];
  classTeacher=datasnapshot.data["schoolboard"];
  print(datasnapshot.data["schoolname"]);
  print(datasnapshot.data["schoolemail"]);
  print(datasnapshot.data["schoolcode"]);
  print(datasnapshot.data["password"]);
  print(datasnapshot.data["schoolno"]);
  print(datasnapshot.data["schoolboard"]);
}
);
}*/


class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}
class _ListPageState extends State<ListPage> {
  //final GlobalKey<RefreshIndicatorState> _refreshIndicatorkey=new GlobalKey<RefreshIndicatorState>();
  bool selectedRadioTile,v;
 final GlobalKey<RefreshIndicatorState> _refreshIndicatorkey=new GlobalKey<RefreshIndicatorState>();
 String dt=(new DateFormat.yMMMMd('en_US').format(new DateTime.now()))+' '
    +(new DateFormat.Hm().format(new DateTime.now()));
  
  @override
  void initState() {
  super.initState();
 // loadData();
  //print(users.length);
  //users = User.getUsers();
  //selectedRadio = 0;
  
   reset();
   v=false;
   selectedRadioTile = false;
}
setSelectedUser(bool val) {
  setState(() {
    selectedRadioTile = val;
 v=val;
  });
}
  Future getPosts() async
  {
    var firestore=Firestore.instance;
    QuerySnapshot qn= await firestore.collection("School").document('69').collection('Student').getDocuments();
    return qn.documents;
  }
 showAlertDialog(BuildContext context) 
 {  
  // Create button  
  Widget okButton = FlatButton(  
    child: Text("OK"),  
    onPressed: () {  
      Navigator.of(context).pop();  
    },  
  );  
  // Create AlertDialog  
  AlertDialog alert = AlertDialog(  
    title: Text("Summary:"),  
    content: Text( dt+"\nPresent Students: "+selectlist.length.toString()+'\n'
    +'Total Students: '+len.toString()+
    '\nPresent Ratio:'+((selectlist.length/len)*100).toInt().toString()+"%"),
    actions: [  
      okButton,  
    ],  
  );   
  // show the dialog  
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
}  

void reset() async
 {
 var snapshots =Firestore.instance.collection("School").document('69').collection('Student').getDocuments().then((value)
 => value.documents.forEach((element) {
 element.reference.updateData(<String,dynamic>{
 'id':false,
});
})
).then((value){
setState(() {
   print('reseted all checkboxes');
});
});
selectlist.removeRange(0, selectlist.length);
 }
Future updateId(String number,bool val) async
  {
final CollectionReference brew=Firestore.instance.collection("School").document('69').collection('Student');
 return await brew.document(number).setData({
  'id':val,
},merge: true); 
  }
//String subject='phy';
String subject='ENG';
int atl;
Future getattcount(BuildContext context,String number,String name)
{
String sub=subject+'attendance';
DocumentReference documentReference =Firestore.instance.collection("School").document('69').collection('Student').
document(number);
documentReference.get().then((datasnapshot)
{
 // print(datasnapshot.data["schoolno"]);
print(datasnapshot.data[subject+"attendance"]);
atl=datasnapshot.data[subject+"attendance"];
return showAlertDialog2(context,atl,name);    
}
);
}

int countAtt(int number)
{
String sub=subject+'_attendance';
DocumentReference documentReference =Firestore.instance.collection("dummy").document("141");
documentReference.get().then((datasnapshot)
{ 
 // print(datasnapshot.data["schoolno"]);
return 7;
}
);  
}
Future updateCount(bool val,String number) async
{
  
String sub=subject+'_attendance';
  //Map<String,dynamic> classteacher={"count":4, "subject":subject,};  
  if(val==true){
    String s=dt;
  return await Firestore.instance.collection("School").document('69').collection('Student').document(number).updateData(
    {
   sub:FieldValue.arrayUnion([s])
    });
  }
  else
  {
    String s=dt;
    return await Firestore.instance.collection("School").document('69').collection('Student').document(number).updateData(
    {
      sub:FieldValue.arrayRemove([s])
  });
  }
  //return await brew.document(selectlist[i]).updateData({
}

void datapush(String number,bool val)
{
 
String sub=subject+'attendance';
 if(val==true){
 setState(() {
 print("select");
  Firestore.instance.collection("School").document('69').collection('Student').document(
  number).setData({
  sub:FieldValue.increment(1)
  },merge:true);
 }  );
 }
else
{
 setState(() {
    print("select");
  Firestore.instance.collection("School").document('69').collection('Student').document(number).setData({
  sub:FieldValue.increment(-1)
  },merge:true);
 });
}
}
int len;
List selectlist=List();
void onCategorySelect(String number,bool val)
{
  if(val==true)
 {
     setState((){
     selectlist.add(number);
     });
 }
  else
  {
     setState((){
     selectlist.remove(number);
     });
  }
}
Future<Null> _refreshLocalGallery() async
{
   print('refreshing....');
   setState(() {
   getPosts();
   });
   return null;
}
List liststamp=List();
List getlist(String number)
{
DocumentReference documentReference =Firestore.instance.collection("School").document('69').collection('Student').document(number);
documentReference.get().then((datasnapshot)
{
String sub=subject+'_attendance';
  setState(() {
  for(int i=0;i<=9;i++)
  {
  print(datasnapshot.data["sub"][i]);
  liststamp.add(datasnapshot.data["sub"][i]);
  }  
  });
 // print(datasnapshot.data["schoolno"]);
  print(datasnapshot.data["first name"]);
}
);
 return liststamp; 
}

showAlertDialog2(BuildContext context,int number,String name) {  
  // Create button  
  Widget okButton = FlatButton(  
    child: Text("OK"),  
    onPressed: () {  
      Navigator.of(context).pop();  
    },  
  );  
  
  // Create AlertDialog  
  AlertDialog alert = AlertDialog(  
    title: Text("$name"),  
    content: 
    Text( "Total class attended: $number "   ),  
    /*SingleChildScrollView(
          child: FutureBuilder(
       future: getlist(number),
                      child: Container(
        height: 50,
        child: ListView.builder(
  padding: const EdgeInsets.all(8),
  itemCount: number,
  itemBuilder: (_, int index) {
        return Container(
            //height: 50,
            //color: Colors.black,
            child: Center(child: Text('Entry $index ')),
        );
  }
),
      )
          ),
    ),*/
    actions: [  
      okButton,  
    ],  
  );  
  
  // show the dialog  
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
}   
  @override
  Widget build(BuildContext context) {
        return Container(
          child: Column(
          children: <Widget>[
           Container(
            height: MediaQuery.of(context).size.height*0.2,
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
               Padding
               (
                   padding: const EdgeInsets.all(8.0),
                   child: RaisedButton(color:Colors.black,onPressed:reset ,child:Text("Reset  ".toUpperCase(),
                   style: TextStyle(color: Colors.white,)),),
                 ),
                 Padding (
                   padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(child:Text('Submit'.toUpperCase(),
                  style: TextStyle(color: Colors.white),),color:Colors.black,
                  onPressed: (){
                  //update ho jaye
                 showAlertDialog(context);
                 reset();
                  },
                  ),
                  ),
               Container(
                 padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                 //height: 30,
                 decoration: BoxDecoration(color:Colors.black,border: Border.all(color:Colors.black)  ),
                 child:RichText(
                 text: TextSpan(
                 //text: 'Hello ',
                 style: DefaultTextStyle.of(context).style,
                 children: <TextSpan>[
                 TextSpan(text: 'Selected:'.toUpperCase(), style: TextStyle(color: Colors.white )),
                 TextSpan(text: ' '+selectlist.length.toString(),
                 style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white ,)),  
    ],
  ),
),
                 ),
                 ],
              ),
           ),
          Container(      
height: MediaQuery.of(context).size.height*.60,
//height: 500,
              child:FutureBuilder(
              future: getPosts(),
              builder: (_,snapshot){
                if(snapshot.connectionState==ConnectionState.waiting)
  {
    return Center(
    child:Text("Please wait...",style: TextStyle(fontSize: 20,color: Colors.black),),
  );
  }
  else{
              return RefreshIndicator(
                    key:_refreshIndicatorkey,
  onRefresh: _refreshLocalGallery,

                              child: ListView.builder(
          itemCount: snapshot.data.length,  
          //separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.black38,),
          itemBuilder: (_,index){
          return Card(
            elevation: 5.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),              
            child: CheckboxListTile(
            title:  Row(
                children: <Widget>[
                  Text(snapshot.data[index].data["first name"],style: TextStyle(
                    fontSize: 17,
                  )),
                ],
            ),
            value: snapshot.data[index].data["id"],
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Colors.green,        
            onChanged: (value)
            {
                print("Current User ${snapshot.data[index].data["first name"]}");
                setState(() {
                timeDilation = value ? 2.0 : 1.0;
                snapshot.data[index].data["id"]=value;
                 //print(selectlist.length);
                updateId(snapshot.data[index].documentID,value);
                  //           updateCount('phy');
                datapush(snapshot.data[index].documentID,value);
                updateCount(value,snapshot.data[index].documentID);
                });
                onCategorySelect(snapshot.data[index].documentID,value); 
                len=snapshot.data.length;
            },
            selected: snapshot.data[index].data["id"],
            secondary: RaisedButton( 
            //hoverColor: Colors.white,
            color: Colors.black
            ,onPressed: (){
            getattcount(context,(snapshot.data[index].documentID),snapshot.data[index].data["first name"]);
            getlist(snapshot.data[index].documentID);
             print('Detailed Info!');},
                child:Text('Detailed Info!',style: TextStyle(color: Colors.white),),
                ),
  ),
          ); 
            /*ListTile(
                  //hoverColor: Colors.blue,
                 //isThreeLine: true  
                  title:Text((snapshot.data[index].data["first name"]),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),
                  ),
                  leading: CircleAvatar(      
                  backgroundColor: Colors.black,  
                  child: Icon(Icons.person,color: Colors.white,),
                  ),
                  onTap: ()
             {
             print("pressed");
             //readData();
//           funcButton(snapshot.data[index]);
            },        
                  subtitle: Text(snapshot.data[index].data["designation"],
                  style: TextStyle(color: Colors.black,),
                  ),
                  trailing: Icon(Icons.arrow_right,size: 40,color: Colors.black,
                  ),
                  );*/
          },
          ),
              );
                   }     }
            )
          ),
             
            ],
    ),
        );
  }
}

/*
ListView _buildListView(BuildContext context)
{
  return ListView.builder(
    itemCount: 10,

    
    itemBuilder: (_,index){
      return Container(
           child: ListTile(
          //hoverColor: Colors.blue,
         //isThreeLine: true,
    
            onTap: ()
            {
            print("pressed");
            readData();
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
            );
           },        

          title:Text("$schoolname",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),
          ),
          leading: CircleAvatar(      
          backgroundColor: Colors.black,
          child: Icon(Icons.person,color: Colors.white,),
          ),
          subtitle: Text("$classTeacher",style: TextStyle(color: Colors.black,),
          ),
          trailing: Icon(Icons.arrow_right,size: 40,color: Colors.black,
          ),
          ),
      );
    },
    );
}
*/






//profile


