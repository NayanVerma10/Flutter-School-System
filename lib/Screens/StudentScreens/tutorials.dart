import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class TutorialView extends StatefulWidget {
  @override
  _TutorialViewState createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> {
  final String url = "http://www.africau.edu/images/default/sample.pdf";
  PDFDocument _pdf;

  @override
  void initState() {
    super.initState();
    initPdf();
  }

  initPdf() async {
    final doc = await PDFDocument.fromURL(url);
    setState(() {
      _pdf = doc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Test"),
      ),
      body: _pdf == null ? Center(child: CircularProgressIndicator(),) : PDFViewer(document: _pdf,),
    );
  }
}