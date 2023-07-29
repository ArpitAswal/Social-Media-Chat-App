import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:signinsignup/alertmessage/database_alert.dart';

import '../galleryacess/photo_access.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool load1 = false;
  bool load2 = false;
  final textpostController = TextEditingController();
  final idpostController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String  id = '';
  String choice='content_image';

  @override
  void initState(){
    id = DateTime.now().millisecond.toString();
   //firestore();
    super.initState();
  }
   void firestore() async{

     await FirebaseFirestore.instance.collection("users").doc(id).collection("Chats").add({
       "userId":'',
       "userName":'',
        "message":'',
       "timeStamp": 0
     });
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('AddPost'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              TextFormField(
                controller: textpostController,
                keyboardType: TextInputType.text,
                maxLines: 5,
                decoration: const InputDecoration(
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
              const SizedBox(height: 40),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      elevation: 7,
                      shadowColor: Colors.purple,
                      maximumSize: const Size(250, 45),
                      shape: const RoundedRectangleBorder(
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
                      'ID' : id.toString()
                    }).then((value) {
                      alert.toastmessage("Text Submit");
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
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            )
                          : const Text(
                              'Post Text',
                              style:
                                  TextStyle(fontSize: 21, color: Colors.white),
                            ))),
              const SizedBox(height: 25),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      elevation: 7,
                      shadowColor: Colors.purple,
                      maximumSize: const Size(250, 45),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(21)),
                          side: BorderSide(color: Colors.white,width: 1.5)),
                      backgroundColor: Colors.deepPurple),
                  onPressed: () {
                    setState(() {
                      load2 = true;
                    });
                    debugPrint('UploadImage');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhotoAccess(Id:id,choice:'content_image'))).then((value) {
                      Navigator.of(context).pop();
                              setState(() {
                        load2 = false;
                      });
                    });
                  },
                  child: Center(
                      child: load2
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            )
                          : const Text(
                              'Upload Image',
                              style:
                                  TextStyle(fontSize: 21, color: Colors.white),
                            ))),
            ],
          ),
        ));
  }
}
