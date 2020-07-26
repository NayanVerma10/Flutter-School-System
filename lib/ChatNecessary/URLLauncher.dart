import 'package:url_launcher/url_launcher.dart';

Future<void> URLLauncher(String url) async{
  if (await canLaunch(url)) {
    await launch(url ,enableDomStorage: true,enableJavaScript: true);
  } else {
    throw 'Could not launch $url';
  }
}