import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:permission_handler/permission_handler.dart';
import 'package:signinsignup/alertmessage/database_alert.dart';



class PhotoAccess extends StatefulWidget {
  static late String id;
  PhotoAccess({required String Id}){
    id=Id;
  }
  @override
  State<PhotoAccess> createState() => _PhotoAccessState();

}

class _PhotoAccessState extends State<PhotoAccess> {
  File? galleryFile;
  final picker = ImagePicker();
  bool load = false;
  late DatabaseReference ref;
  FirebaseAuth auth = FirebaseAuth.instance;
 // late firebase_storage.UploadTask task;
  TextEditingController _description = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var imageUrl;
  @override
  Widget build(BuildContext context) {
    //display image selected from gallery

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery and Camera Access'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (galleryFile == null) {
            alert.toastmessage("you don't have any image select yet");
            alert.toastmessage('Please select image or you can go back');

          } else {
            _uploadimageStorage();
            alert.toastmessage("Uploaded");
          }
          _formKey.currentState?.save();
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.done_outlined,
          size: 30,
        ),
      ),
      body:  SingleChildScrollView(
        child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16,vertical: 20),
                  height: 240.0,
                  width: double.infinity,
                 decoration: BoxDecoration(border: Border.all(color: Colors.black87)),
                  child: galleryFile == null
                      ? Icon(
                      Icons.image,
                      size: 60,
                        )
                      : Center(child: Image.file(galleryFile!,fit: BoxFit.cover,)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextFormField(
                    onSaved: (value) {
                      _description.text = value!;
                    },
                    key: _formKey,
                    controller: _description,
                    style: TextStyle(color: Colors.blue),
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
            prefixIconColor: Colors.black54,
            prefixIcon: Icon(Icons.text_snippet),
            labelText: 'Description',
            labelStyle: TextStyle(
            color: Colors.black, fontSize: 18),
            hintText: 'write something about image',
            hintStyle: TextStyle(
            color: Colors.blue, fontSize: 14)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide description";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          elevation: 7,
                          shadowColor: Colors.purple,
                          maximumSize: Size(250, 45),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(21)),
                              side: BorderSide(color: Colors.white,width: 1.5)),
                          backgroundColor: Colors.deepPurple),
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
                ),
              ],
            ),
    ));

  }

  void _showPicker({
    required BuildContext context,
  }) {
    setState(() {
      load =false;
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
                onTap: () async{
                  if(await _askPermission('Gallery'))
                    getImage(ImageSource.gallery);
                  },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async{
                  if(await _askPermission('Camera'))
                    getImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadimageStorage() async {
    String date = DateTime.now().millisecondsSinceEpoch.toString();
    final reference = firebase_storage.FirebaseStorage.instance.ref().child(
        "${auth.currentUser?.displayName}/$date");
   // task = reference.putFile(galleryFile!.path);
    await reference.putFile(File(galleryFile!.path));
    imageUrl = await reference.getDownloadURL();
    if(imageUrl.isEmpty || imageUrl=='null'){
      alert.toastmessage("No image Path received! Something went Wrong.");
    }
    else {
      ref = FirebaseDatabase.instance.ref('Database of Information');
      Future.value().then((value) async {
        ref.child('${auth.currentUser?.uid}').child('Content').child(
            '${PhotoAccess.id}').update({
          'Image': imageUrl.toString(),
          'Description': _description.text.toString()
        });
      });
    }
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
          //_uploadimageStorage();
        } else {
          ScaffoldMessenger.of(context).showSnackBar( // is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
    Navigator.of(context).pop();
  }

}

Future<bool> _askPermission(String s) async {
  if (s == 'Camera') {
    var cameraAccess = await Permission.camera.status;
    debugPrint('cameraAccess=$cameraAccess');
    if (!cameraAccess.isGranted) {
      await Permission.camera.request();
    }
    if(!cameraAccess.isGranted)
      return true;
  }
  else {
    var galleryAccess = await Permission.storage.status;
    debugPrint('galleryAccess=$galleryAccess');
    if (!galleryAccess.isGranted)
      await Permission.storage.request();
    if (galleryAccess.isGranted)
      return true;
  }

  return false;
}