class School {
  String schoolname;
  String schoolboard;
  String schoolemail;
  String schoolno;
  String schoolpassword;
  String about;

  School(this.schoolname, this.schoolboard, this.schoolemail, this.schoolno,
      this.schoolpassword, this.about);
  Map<String, dynamic> toJson() => {
        'schoolname': schoolname,
        'schoolboard': schoolboard,
        'schoolemail': schoolemail,
        'schoolno': schoolno,
        'password': schoolpassword,
        'about': about
      };
}
