import 'package:flutter/material.dart';
import 'package:signinsignup/posts/post_screen.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signinsignup/alertmessage/database_alert.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool load = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("SignUp")),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIconColor: Colors.black54,
                        prefixIcon: Icon(Icons.email_rounded),
                        labelText: 'E-mail',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        hintText: 'Your E-mail Id',
                        hintStyle: TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                      validator: (value) {
                        if (value!.isEmpty)
                          return "Please Enter the E-mail";
                        else
                          return null;
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIconColor: Colors.black54,
                        prefixIcon: Icon(Icons.lock_open_rounded),
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        hintText: 'Your Account Password',
                        hintStyle: TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                      validator: (value) {
                        if (value!.isEmpty)
                          return "Please Enter the Password";
                        else
                          return null;
                      }),
                ],
              ),
            ),
            SizedBox(height: 35),
            ElevatedButton(
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  setState(() {
                    load = true;
                  });
                  _auth
                      .createUserWithEmailAndPassword(
                          email: emailController.text.toString(),
                          password: passwordController.text.toString())
                      .then((value) {
                    alert.toastmessage('Successfully SignedUp');
                    setState(() {
                      load = false;
                    });
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => PostScreen()));
                  }).onError((error, stackTrace) {
                    setState(() {
                      load = false;
                    });
                    alert.toastmessage(error.toString());
                  });
                }
              },
              child: Center(
                  child: load
                      ? CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        )
                      : Text(
                          'Sign up',
                          style: TextStyle(fontSize: 21, color: Colors.white),
                        )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?",
                    style: TextStyle(fontSize: 18)),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text("Login", style: TextStyle(fontSize: 18)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
