class School {
  String schoolname;
  String schoolboard;
  String schoolemail;
  String schoolno;

  School(this.schoolname,this.schoolboard,this.schoolemail,this.schoolno);
  Map<String, dynamic> toJson() => {
    'schoolname':schoolname,
    'schoolboard':schoolboard,
    'schoolemail':schoolemail,
    'schoolno':schoolno,
  };


}
