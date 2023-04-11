import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signinsignup/alertmessage/database_alert.dart';
import '../posts/post_screen.dart';
import 'package:pinput/pinput.dart';

class VerifycodeScreen extends StatefulWidget {
  final String verificationId;

  const VerifycodeScreen({Key? key, required this.verificationId})
      : super(key: key);
  @override
  State<VerifycodeScreen> createState() => _VerifycodeScreenState();
}

class _VerifycodeScreenState extends State<VerifycodeScreen> {
  @override
  bool load = false;
  final auth = FirebaseAuth.instance;
  final verifyController = TextEditingController();

  static var defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
    borderRadius: BorderRadius.circular(8),
  );

  final submittedPinTheme = defaultPinTheme.copyWith(
    decoration: defaultPinTheme.decoration?.copyWith(
      color: Color.fromRGBO(234, 239, 243, 1),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Verifycode'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              Text('Phone Verification',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 40),
              Pinput(
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(21)),
                        side: BorderSide(color: Colors.white)),
                    backgroundColor: Colors.deepPurple),
                onPressed: () async {
                  setState(() {
                    load = true;
                  });
                  final cred = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: verifyController.text.toString());
                  try {
                    await auth.signInWithCredential(cred);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PostScreen()));
                  } catch (e) {
                    setState(() {
                      load = false;
                    });
                    alert.toastmessage(e.toString());
                  }
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
              SizedBox(height: 30),
              Text("Don't receive code",style:TextStyle(color: Colors.lightBlueAccent)),
            SizedBox(height: 5),
              InkWell(
                  onTap:(){

                  },
                  child:
                  Text("resend?",style:TextStyle(color: Colors.lightBlueAccent))),

            ],
          ),
        ));
  }
}
