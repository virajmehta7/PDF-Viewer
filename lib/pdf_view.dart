import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfView extends StatefulWidget {
  final File selectedFile;
  const PdfView({Key key, this.selectedFile}) : super(key: key);

  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {

  PDFViewController controller;
  int pages = 0;
  int indexPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedFile.path.split('/').last.split('.').first,
            style: TextStyle(color: Colors.black)
        ),
        actions: pages >= 2 ? [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text('${indexPage + 1} of $pages',
                  style: TextStyle(fontSize: 16, color: Colors.black)
              ),
            ),
          ),
        ] : null,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: PDFView(
        filePath: widget.selectedFile.path,
        onRender: (pages) {
          setState(() => this.pages = pages);
        },
        onViewCreated: (controller) {
          setState(() => this.controller = controller);
        },
        onPageChanged: (indexPage,_) {
          setState(() => this.indexPage = indexPage);
        }
      ),
    );
  }
}