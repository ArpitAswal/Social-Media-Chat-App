import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signinsignup/alertmessage/database_alert.dart';
import 'package:signinsignup/auth/verifycode_screen.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool load = false;
  final auth = FirebaseAuth.instance;
  final numberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Login with number')),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 80),
              TextFormField(
                controller: numberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: '+91 2343 455 234'),
              validator: (value){
                  if(value!.isEmpty)
                    return "Please enter the phone number";
                  else
                    return null;
              }
              ),
              SizedBox(height: 80),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(21)),
                        side: BorderSide(color: Colors.white)),
                    backgroundColor: Colors.deepPurple),
                onPressed: () async{
                  setState(() {
                    load = true;
                  });
                  await auth.verifyPhoneNumber(
                      phoneNumber: numberController.text,
                      verificationCompleted: (_) {
                        alert.toastmessage('verified');
                        setState(() {
                          load = false;
                        });
                      },
                      verificationFailed: (e) {
                        alert.toastmessage(e.toString());
                        setState(() {
                          load = false;
                        });
                      },
                      codeSent: (String verificationId, int? token) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifycodeScreen(
                                   verificationId: verificationId,
                                    )));
                        setState(() {
                          load = false;
                        });
                      },
                      codeAutoRetrievalTimeout: (e) {
                        alert.toastmessage(e.toString());
                        setState(() {
                          load = false;
                        });
                      });
                },
                child: Center(
                    child: load
                        ? CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          )
                        : Text(
                            'Verify',
                            style: TextStyle(fontSize: 21, color: Colors.white),
                          )),
              ),
            ],
          ),
        ));
  }
}
