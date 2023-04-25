import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:signinsignup/alertmessage/database_alert.dart';
import '../posts/post_screen.dart';

class EmailVerificationScreen extends StatefulWidget {

 static late String name;
  static late String mail;
  static late String pass;


   EmailVerificationScreen({required String username, required String email,
    required String password}){
    name=username;
    mail=email;
    pass=password;

  }
   bool verified=_EmailVerificationScreenState().isEmailVerified;
  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  FirebaseAuth _auth= FirebaseAuth.instance;
  late DatabaseReference reference;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.currentUser?.sendEmailVerification();
    reference = FirebaseDatabase.instance.ref("Database of Information");
    timer = Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isEmailVerified = _auth.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      // TODO: implement your code after email verification
      alert.toastmessage("Email Successfully Verified");
      timer?.cancel();
      _infoDatabase();
      Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen()));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  void _infoDatabase() async{

    await reference.child('${_auth.currentUser?.uid}').child('Current_User_Info').set({
      'User Name' : EmailVerificationScreen.name,
      'E-mail ID': EmailVerificationScreen.mail,
      'Password' : EmailVerificationScreen.pass,
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Verify your Email',style: TextStyle(fontSize: 28,fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 8),
          Center(child: Text('check your email & click the link to activate your account',style: TextStyle(color:Colors.black45),)),
          const SizedBox(height: 16),
          Image.asset('assets/email.jpg'),
          const SizedBox(height: 15),
          ElevatedButton(
            child: const Text('Resend'),
            onPressed: () {
              try {
                _auth.currentUser
                    ?.sendEmailVerification();
              } catch (e) {
                debugPrint('$e');
              }
            },
          ),
        ],
      ),
    );
  }
}
