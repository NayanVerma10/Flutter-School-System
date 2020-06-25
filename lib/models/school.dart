class School {
  String schoolname;
  String schoolboard;
  String schoolemail;
  String schoolno;
  String schoolpassword;

  School(this.schoolname,this.schoolboard,this.schoolemail,this.schoolno,this.schoolpassword);
  Map<String, dynamic> toJson() => {
    'schoolname':schoolname,
    'schoolboard':schoolboard,
    'schoolemail':schoolemail,
    'schoolno':schoolno,
    'password':schoolpassword
  };


}
