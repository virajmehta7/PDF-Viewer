import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';

class PdfView extends StatefulWidget {
  final File? selectedFile;
  const PdfView({Key? key, this.selectedFile}) : super(key: key);

  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {

  PDFViewController? controller;
  int? pages = 0;
  int? indexPage = 0;

  @override
  Widget build(BuildContext context) {

    final fileName = basenameWithoutExtension(widget.selectedFile!.path);
    final filePages = '${indexPage! + 1} of $pages';

    return Scaffold(
      appBar: AppBar(
        title: Text(fileName,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300)
        ),
        actions: pages! >= 2 ? [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
                child: Text(filePages,
                    style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w300)
                ),
            ),
          ),
        ] : null,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: PDFView(
        filePath: widget.selectedFile!.path,
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