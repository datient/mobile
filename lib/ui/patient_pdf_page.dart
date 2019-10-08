import 'package:datient/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class PatientPdfPage extends StatefulWidget {
  final Patient patient;
  PatientPdfPage({Key key, this.patient}) : super(key: key);

  @override
  _PatientPdfState createState() => _PatientPdfState();
}

class _PatientPdfState extends State<PatientPdfPage> {
  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(
        "http://10.0.2.2:8000/pdf/${widget.patient.dni}");
    setState(() => _isLoading = false);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(document: document)),
    );
  }
}
