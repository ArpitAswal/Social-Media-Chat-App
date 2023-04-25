import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:signinsignup/alertmessage/database_alert.dart';

import '../galleryacess/photo_access.dart';

class AddPostScreen extends StatefulWidget {
  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  bool load1 = false;
  bool load2 = false;
  final textpostController = TextEditingController();
  final idpostController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String  id = '';
  String choice='content_image';

  void initState(){
    id = DateTime.now().millisecond.toString();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('AddPost'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              TextFormField(
                controller: textpostController,
                keyboardType: TextInputType.text,
                maxLines: 5,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.black,
                    )),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.lightBlueAccent,
                    )),
                    hintText: 'Write  your  ideas',
                    hintStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w400)),
              ),
              SizedBox(height: 40),
              ElevatedButton(
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
                      load1 = true;
                    });
                    DatabaseReference databaseRef =
                        FirebaseDatabase.instance.ref('Database of Information');
                    databaseRef.child('${auth.currentUser?.uid}').child('Content').child(id).set({
                      'Text' : textpostController.text.toString(),
                      'ID' : id
                    }).then((value) {
                      alert.toastmessage("Post Submit");
                      setState(() {
                        load1 = false;
                      });
                    }).onError((error, stackTrace) {
                      alert.toastmessage(error.toString());
                      setState(() {
                        load1 = false;
                      });
                    });
                  },
                  child: Center(
                      child: load1
                          ? CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            )
                          : Text(
                              'Post Text',
                              style:
                                  TextStyle(fontSize: 21, color: Colors.white),
                            ))),
              SizedBox(height: 25),
              ElevatedButton(
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
                      load2 = true;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhotoAccess(Id:id,choice:'content_image'))).then((value) {
                      setState(() {
                        load2 = false;
                      });
                    });
                    Navigator.of(context).pop();

                  },
                  child: Center(
                      child: load2
                          ? CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            )
                          : Text(
                              'Upload Image',
                              style:
                                  TextStyle(fontSize: 21, color: Colors.white),
                            ))),
            ],
          ),
        ));
  }
}
