import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:signinsignup/alertmessage/database_alert.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.deepPurple),
      home: const PhotoAccess(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PhotoAccess extends StatefulWidget {
  const PhotoAccess({super.key});

  @override
  State<PhotoAccess> createState() => _PhotoAccessState();
}

class _PhotoAccessState extends State<PhotoAccess> {
  File? galleryFile;
  final picker = ImagePicker();
  bool load = false;
  DatabaseReference reference = FirebaseDatabase.instance.ref('User_Info');
  @override
  Widget build(BuildContext context) {
    //display image selected from gallery

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery and Camera Access'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pop();
        },
        child: Icon(Icons.done_outlined,size: 16,),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 180.0,
                  width: 220.0,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black87)),
                  child: galleryFile == null
                      ? const Center(
                          child: Icon(
                          Icons.image,
                          size: 40,
                        ))
                      : Center(child: Image.file(galleryFile!)),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        maximumSize: MaterialStateProperty.all(Size(180, 50)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurple)),
                    onPressed: () {
                      setState(() {
                        load = true;
                      });
                      _showPicker(context: context);
                    },
                    child: Center(
                        child: load
                            ? CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              )
                            : Text(
                                'Select Image',
                                style: TextStyle(
                                    fontSize: 21, color: Colors.white),
                              ))),

              ],
            ),
          );
        },
      ),
    );
  }

  void _showPicker({
    required BuildContext context,
  }) {
    setState(() {
      load = false;
    });
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future _uploadimageStorage() async {
    final ref = firebase_storage.FirebaseStorage.instance.ref('/User_Info');
    firebase_storage.UploadTask task = ref.putFile(galleryFile!.absolute);

    Future.value(task).then((value) async {
      var newUrl = await ref.getDownloadURL();
      reference.child('1002').update({
        'image': newUrl.toString(),
      }).then((value) {
        setState(() {
          load = false;
        });
        alert.toastmessage('uploaded');
      }).onError((error, stackTrace) {
        alert.toastmessage(error.toString());
        setState(() {
          load = false;
        });
      });
    }).onError((error, stackTrace) {
      alert.toastmessage(error.toString());
      setState(() {
        load = false;
      });
    });
  }

  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
          _uploadimageStorage();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}
