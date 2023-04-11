import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:signinsignup/alertmessage/database_alert.dart';
import '../auth/login_screen.dart';
import 'addpost_screen.dart';

class PostScreen extends StatefulWidget {
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final textController = TextEditingController();
  final editController = TextEditingController();
  DatabaseReference reference = FirebaseDatabase.instance.ref('User_Info');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Post Screen",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
          ),
          actions: [
            IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  alert.toastmessage('Signed Out');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }).onError((error, stackTrace) {
                  alert.toastmessage(error.toString());
                });
              },
              icon: Icon(Icons.logout_outlined),
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddPostScreen()));
          },
          child: Icon(Icons.add),
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              child: TextField(
                controller: textController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple)),
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.black54),
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      color: Colors.black54,
                    )),
                onChanged: (String value) {
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                query: reference,
                duration: Duration(seconds: 5),
                defaultChild: Center(
                    child: Container(
                        height: 70,
                        width: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Loading',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black54)),
                            CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.black54)
                          ],
                        ))),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  final title = snapshot.child('e-mail').value.toString();
                  final id = snapshot.child('id').value.toString();
                  if (textController.text.isEmpty) {
                    return ListTile(
                      title: Text(title),
                      subtitle: Text(id),
                      trailing: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit'),
                              onTap: () {
                                Navigator.pop(context);
                                showMyDialog(title, id);
                              },
                            ),
                          ),
                          PopupMenuItem(
                              child: ListTile(
                            leading: Icon(Icons.delete),
                            title: Text("Delete"),
                            onTap: () {
                              reference
                                  .child(id)
                                  .remove()
                                  .then(
                                      (value) => alert.toastmessage('Deleted'))
                                  .onError((error, stackTrace) =>
                                      alert.toastmessage(error.toString()));
                              Navigator.pop(context);
                            },
                          ))
                        ],
                      ),
                    );
                  } else if (title
                      .toLowerCase()
                      .toString()
                      .contains(textController.text.toLowerCase().toString())) {
                    return ListTile(
                      title: Text(snapshot.child('e-mail').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                      trailing: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit'),
                              onTap: () {
                                Navigator.pop(context);
                                showMyDialog(title, id);
                              },
                            ),
                          ),
                          PopupMenuItem(
                              child: ListTile(
                            leading: Icon(Icons.delete),
                            title: Text("Delete"),
                            onTap: () {
                              reference
                                  .child(id)
                                  .remove()
                                  .then(
                                      (value) => alert.toastmessage('Deleted'))
                                  .onError((error, stackTrace) =>
                                      alert.toastmessage(error.toString()));
                              Navigator.pop(context);
                            },
                          ))
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            )
          ],
        ));
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: InputDecoration(
                  hintText: 'Edit',
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    reference.child(id).update({
                      'e-mail': editController.text.toString()
                    }).then((value) {
                      alert.toastmessage('Post update');
                    }).onError((error, stackTrace) {
                      alert.toastmessage(error.toString());
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Update'))
            ],
          );
        });
  }
}
