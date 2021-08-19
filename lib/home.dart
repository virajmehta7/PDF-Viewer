import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'pdf_view.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<FileSystemEntity> files;
  List allPdf = [];

  getAllPdf() async {
    await Permission.storage.request();
    Directory dir = Directory('/storage/emulated/0/');
    setState(() {
      files = dir.listSync(recursive: true, followLinks: false);
      for(FileSystemEntity entity in files) {
        String path = entity.path;
        if(path.endsWith('.pdf') && !path.split('/').last.contains('com.'))
          allPdf.add(entity);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getAllPdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Icon(Icons.folder_open, size: 30,),
                    SizedBox(width: 10),
                    Text('Browse more files',
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right, size: 30,)
                  ],
                ),
              ),
              onTap: () async {
                FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
                if (result != null) {
                  File file = File(result.files.single.path);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => PdfView(selectedFile: file)
                    ),
                  );
                } else {
                  print('PDF Not Selected');
                }
              },
            ),
            Divider(
              color: Colors.grey.shade400,
              thickness: 1,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: allPdf.length,
              itemBuilder: (context, index){

                List size = [];
                allPdf.asMap().forEach((key, value) {
                  final file = File('${allPdf.elementAt(key).path}');
                  int len = file.lengthSync();
                  size.add((len/1000).toStringAsFixed(2));
                });

                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(15,10,10,10),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Row(
                          children: [
                            Icon(Icons.picture_as_pdf, size: 28, color: Colors.red,),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(allPdf.elementAt(index).path.split('/').last,
                                  style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
                                ),
                                Text(' ・${size[index]} KB',
                                  style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => PdfView(selectedFile: allPdf.elementAt(index))
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      )
    );
  }
}