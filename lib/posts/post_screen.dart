
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:signinsignup/alertmessage/database_alert.dart';
import 'package:signinsignup/auth/login_screen.dart';
import '../auth/login_withPhone.dart';
import '../chatscreen.dart';
import '../galleryacess/photo_access.dart';
import 'addpost_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  
  final searchController = TextEditingController();
  final editTextController = TextEditingController();
  final editDescriptionController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DatabaseReference reference;
  DatabaseReference delref = FirebaseDatabase.instance.ref('Database of Information');
  late CollectionReference firest;
  late String profileId;
  String profileImage = '';
  late String choice;

  @override
  void initState() {
    reference = FirebaseDatabase.instance
        .ref('Database of Information')
        .child('${_auth.currentUser?.uid}')
        .child('Content');
    profileId = delref.child('${_auth.currentUser?.uid}').toString();
    firest= FirebaseFirestore.instance.collection("Chats");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              leading: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5),
                  child: InkWell(
                    onTap: () async {
                      choice = 'profile_image';
                      _updateImage(profileId, choice);
                      Future.delayed(const Duration(minutes: 1));
                      setState(() {
                        debugPrint('setState');
                      });
                    },
                    child: FutureBuilder(
                      future: _profile(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Object> snapshot) {
                        if (snapshot.data == 'null' ||
                            snapshot.data == null) {
                          return Container();
                        } else {
                          return CircleAvatar(
                            radius:30,
                            backgroundImage: NetworkImage('${snapshot.data}',
                            ),
                          );
                        }
                      },
                    ),
                  )),
              centerTitle: true,
              title: const Text(
                "Post Screen",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
              ),
              actions: [
                IconButton(icon:const Icon(Icons.message),onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen(id:'236')));

                },),
                logOut(),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
            floatingActionButton: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddPostScreen()));
                },
                child: const Center(
                    child: Icon(
                  Icons.navigate_next,
                  size: 40,
                )),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () {
                return Future.delayed(const Duration(seconds: 1), () {
                  final snackBar = SnackBar(
                    content: const Text('Screen Refreshed',
                        style: TextStyle(color: Colors.black)),
                    elevation: 4,
                    backgroundColor: Colors.blueGrey.shade50,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  setState(() {});
                });
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 12),
                    child: TextField(
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
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
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Contents-',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w400))),
                  ),
                  Expanded(
                    child: FirebaseAnimatedList(
                        scrollDirection: Axis.vertical,
                        query: reference.orderByChild('Description'),
                        duration: const Duration(seconds: 5),
                        defaultChild: const Center(
                            child: SizedBox(
                                height: 70,
                                width: 70,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Loading',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black54)),
                                    CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.black54)
                                  ],
                                ))),

                        itemBuilder: (BuildContext context,
                            DataSnapshot snapshot,
                            Animation<double> animation,
                            int index) {
                            final desc =
                              snapshot.child('Description').value.toString();
                              final image =
                              snapshot.child('Image').value.toString();
                              final text = snapshot.child('Text').value.toString();
                              var id = snapshot.child('ID').value.toString();
                              if (id == 'null') {
                                id = snapshot.key!;
                              }

                              if (searchController.text.isEmpty) {
                                index = index + 1;
                                return _content(index, desc, text, id, image);
                              } else if (text.toLowerCase().toString().contains(
                                  searchController.text.toLowerCase().toString())) {
                                return _content(index + 1, desc, text, id, image);
                              } else {
                                return Container();
                              }
                            }
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 12),
                    child: SizedBox(
                      width: 160,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 4,
                              backgroundColor: Colors.grey[400],
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(21)),
                                  side: BorderSide(
                                      color: Colors.white, width: 1))),
                          onPressed: () {
                            linkOptions(context: context);
                          },
                          child: const Center(child: Text("Link an Account"))),
                    ),
                  )
                ],
              ),
            )));
  }

  Widget richtext(String key, String value) {
    return RichText(
        softWrap: true,
        text: TextSpan(
            text: '$key- ',
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.redAccent,
                fontStyle: FontStyle.italic),
            children: <InlineSpan>[
              const WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: SizedBox(width: 6)),
              TextSpan(
                  text: value,
                  style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline)),
            ]));
  }

  Future<void> showMyDialog(String option, String text, String id) async {
    var editController = TextEditingController();
    editController.text = text.toString();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update"),
            content: TextFormField(
              controller: editController,
              keyboardType: TextInputType.text,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Edit',
                labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                hintText: 'write new text',
                hintStyle: TextStyle(color: Colors.blue, fontSize: 14),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    reference.child(id).update({
                      option: editController.text.toString(),
                    }).then((value) {
                      alert.toastmessage('$option Updated');
                    }).onError((error, stackTrace) {
                      alert.toastmessage(error.toString());
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Update'))
            ],
          );
        });
  }

  void linkOptions({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            direction: Axis.horizontal,
            children: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 7,
                      backgroundColor: Colors.teal[100],
                      shape: const CircleBorder(
                          side: BorderSide(color: Colors.white, width: 2))),
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/google.png'),
                    radius: 20,
                  ),
                  onPressed: () {
                    linkGoogle(context);
                  }),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 7,
                      //backgroundColor: Colors.teal[100],
                      shape: const CircleBorder(
                          side: BorderSide(color: Colors.white, width: 2))),
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/phone.png'),
                    radius: 20,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const LoginWithPhoneNumber(choice: 'linkin')));
                  }),
            ],
          ),
        );
      },
    );
  }

  Future<void> linkGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      final AuthCredential authCredential =
          GoogleAuthProvider.credential(idToken: googleAuth.idToken);
      final linkauthresult =
          await _auth.currentUser?.linkWithCredential(authCredential);
      if (linkauthresult != null) alert.toastmessage('Linked with Google');
      googleSignIn.signOut();
    }
  }

  Widget _content(
      int index, String desc, String text, String id, String image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                '${index.toString()}.',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              //SizedBox(width: MediaQuery.of(context).size.width-85,),
              IconButton(
                  onPressed: () {
                    reference
                        .child(id)
                        .remove()
                        .then((value) => alert.toastmessage('Deleted'))
                        .onError((error, stackTrace) =>
                            alert.toastmessage(error.toString()));
                  },
                  icon: const Icon(Icons.delete_forever))
            ],
          ),
          (image == 'null' || image.isEmpty)
              ? Container(
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      shape: BoxShape.rectangle,
                      color: Colors.teal[50]),
                  child: Center(
                      child: InkWell(
                    onTap: () {
                      _updateImage(id, 'content_image');
                    },
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: const BorderSide(
                                  color: Colors.deepPurple, width: 2)),
                          elevation: 7,
                          shadowColor: Colors.purple,
                          child: const Icon(Icons.image_search_rounded,
                              size: 48, color: Colors.deepPurple)),
                    ),
                  )))
              : Container(
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      shape: BoxShape.rectangle,
                      color: Colors.teal[50]),
                  child: Image.network(
                    image,
                    fit: BoxFit.contain,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress != null) {
                        return const Center(
                            child: CircularProgressIndicator(
                                color: Colors.deepPurple));
                        //Image.asset('assets/loadimage.png');
                      } else {
                        return child;
                      }
                    },
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stacktrace) {
                      return const Center(
                          child: Text(
                              "This image can't longer be saved on storage"));
                    },
                  )),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (desc == 'null' || desc.isEmpty)
                  ? richtext('Description', 'No description of this image')
                  : Expanded(
                      child: richtext('Description', desc),
                    ),
              IconButton(
                  onPressed: () {
                    showMyDialog('Description', desc, id);
                  },
                  icon: const Icon(Icons.edit_note_rounded))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (text == 'null' || text.isEmpty)
                  ? richtext('Text', 'No post text')
                  : Expanded(child: richtext('Text', text)),
              IconButton(
                  onPressed: () {
                    showMyDialog('Text', text, id);
                  },
                  icon: const Icon(Icons.edit_rounded, size: 18))
            ],
          ),
        ],
      ),
    );
  }

  void _updateImage(String id, String imagechoice) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhotoAccess(Id: id, choice: imagechoice)));

  }

  Future<String> _profile() async {
    DatabaseEvent event = await delref
        .child('${_auth.currentUser?.uid}')
        .child('Current_User_Info')
        .child('ProfileImage')
        .once();
    if (event.snapshot.value.toString()== "null") {
      return 'https://cdn.dribbble.com/users/6295/screenshots/2923288/firebaseload.gif';
    } else {
      return '${event.snapshot.value}';
    }
  }

 Widget logOut() {
    return  PopupMenuButton(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      icon: const Icon(Icons.exit_to_app_outlined),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
              title: const Text('Delete Account'),
              trailing: const Icon(Icons.delete),
              onTap: () async {
                Navigator.pop(context);
                delref.child('${_auth.currentUser?.uid}').remove();
                firest.doc(_auth.currentUser!.displayName).delete().then((value) => debugPrint("User Deleted"))
                    .catchError((error) => debugPrint("Failed to delete user: $error"));
                await _auth.currentUser?.delete().then((value) {
                  alert.toastmessage('Deleted');
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }).onError((error, stackTrace) {
                  alert.toastmessage(error.toString());
                });
              }),
        ),
        PopupMenuItem(
            child: ListTile(
                title: const Text("SignOut"),
                trailing: const Icon(Icons.logout_outlined),
                onTap: () async {
                  Navigator.pop(context);
                  await _auth.signOut().then((value) {
                    alert.toastmessage('Signed out');
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  }).onError((error, stackTrace) {
                    alert.toastmessage(error.toString());
                  });
                }))
      ],
    );
 }

}
