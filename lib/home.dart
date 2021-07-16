import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'pdf_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Select PDF',
              style: TextStyle(fontSize: 20)
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              elevation: 5,
              padding: EdgeInsets.all(10)
          ),
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
            if (result != null) {
              File file = File(result.files.single.path!);
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => PdfView(selectedFile: file)
                ),
              );
            } else {
              setState(() {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: Text('No file selected'),
                        actions: [
                          CupertinoDialogAction(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
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