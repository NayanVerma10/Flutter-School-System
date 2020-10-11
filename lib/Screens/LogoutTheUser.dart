import 'package:shared_preferences/shared_preferences.dart';
import 'package:Schools/main.dart';

logoutTheUser() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  main();

}