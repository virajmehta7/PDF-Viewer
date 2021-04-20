import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void openPdf(BuildContext context, File file) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PdfView(file: file)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Select PDF',
              style: TextStyle(
                fontSize: 20
              )),
          style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              elevation: 10,
              padding: EdgeInsets.all(15)
          ),
          onPressed: () async {
            FilePickerResult result = await FilePicker.platform
                .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
            if (result != null) {
              File file = File(result.files.single.path);
              openPdf(context, file);
            } else {
              setState(() {
                showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Theme(
                      data: ThemeData(dialogBackgroundColor: Colors.white),
                      child: CupertinoAlertDialog(
                        title: Text('No file selected'),
                        actions: [
                          CupertinoDialogAction(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                  }
                );
              });
            }
          },
        ),
      ),
    );
  }
}

class PdfView extends StatefulWidget {
  final File file;

  const PdfView({
    Key key,
    @required this.file,
  }) : super(key: key);

  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  PDFViewController controller;
  int pages = 0;
  int indexPage = 0;

  @override
  Widget build(BuildContext context) {
    final filename = basename(widget.file.path);
    final text = '${indexPage + 1} of $pages';
    return Scaffold(
      appBar: AppBar(
          title: Text(filename,
              style: TextStyle(fontSize: 18)),
          actions: pages >= 2 ? [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                  child: Text(text,
                      style: TextStyle(fontSize: 15))
              ),
            )
          ] : null
      ),
      body: PDFView(
        filePath: widget.file.path,
        onRender: (pages) => setState(() => this.pages = pages),
        onViewCreated: (controller) =>
            setState(() => this.controller = controller),
        onPageChanged: (indexPage, _) =>
            setState(() => this.indexPage = indexPage),
      ),
    );
  }
}