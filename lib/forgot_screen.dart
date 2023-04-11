import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signinsignup/alertmessage/database_alert.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool load = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(hintText: 'Email'),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(21)),
                      side: BorderSide(color: Colors.white)),
                  backgroundColor: Colors.deepPurple),
              onPressed: () {
                setState(() {
                  load = true;
                });
                auth
                    .sendPasswordResetEmail(
                        email: emailController.text.toString())
                    .then((value) {
                  setState(() {
                    load = false;
                  });
                  alert.toastmessage(
                      'We have sent you email to recover password, please check email');
                }).onError((error, stackTrace) {
                  setState(() {
                    load = false;
                  });
                  alert.toastmessage(error.toString());
                });
              },
              child: Center(
                  child: load
                      ? CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        )
                      : Text(
                          'Send',
                          style: TextStyle(fontSize: 21, color: Colors.white),
                        )),
            )
          ],
        ),
      ),
    );
  }
}
