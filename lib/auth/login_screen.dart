import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:signinsignup/alertmessage/database_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signinsignup/auth/signup_screen.dart';
import '../forgot_screen.dart';
import '../posts/post_screen.dart';
//import 'login_withPhone.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool load = false;
  bool hidden = true;
  bool obsText = true;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void _togglePassword() {
    setState(() {
      hidden = !hidden;
      obsText = !obsText;
    });
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("SignIn")),
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
                          hintStyle:
                              TextStyle(color: Colors.blue, fontSize: 14),
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
                        obscureText: obsText,
                        decoration: InputDecoration(
                          prefixIconColor: Colors.black54,
                          prefixIcon: Icon(Icons.lock_open_rounded),
                          labelText: 'Password',
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                          hintText: 'Your Account Password',
                          hintStyle:
                              TextStyle(color: Colors.blue, fontSize: 14),
                          suffixIcon: InkWell(
                            onTap: _togglePassword,
                            child: Icon(
                              hidden ? Icons.visibility_off : Icons.visibility,
                              color: Colors.black54,
                            ),
                          ),
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
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(21)),
                        side: BorderSide(color: Colors.white)),
                    backgroundColor: Colors.deepPurple),
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    setState(() {
                      load = true;
                    });
                    _auth
                        .signInWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passwordController.text.toString())
                        .then((value) {
                      alert.toastmessage(value.user!.email.toString());
                      setState(() {
                        load = false;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostScreen()));
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
                            'Sign in',
                            style: TextStyle(fontSize: 21, color: Colors.white),
                          )),
              ),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen()));
                  },
                  child:
                      Text("Forgot Password?", style: TextStyle(fontSize: 16)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 7,
                    backgroundColor: Colors.teal[100]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 35.0,
                        width: 30.0,
                        decoration: BoxDecoration(
                          //color: Colors.teal[50],
                          image: DecorationImage(
                              image: AssetImage('assets/google.png'),
                              fit: BoxFit.cover),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text("Sign In with Google",style: TextStyle(color:Colors.black,fontSize: 18),)
                    ],
                  ),
                  onPressed: () {
                    _signin(context);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",
                      style: TextStyle(fontSize: 18)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: Text("Sign up", style: TextStyle(fontSize: 18)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signin(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await _auth.signInWithCredential(authCredential);
      User? user = result.user;

      if (user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => PostScreen()));
      }
      else{
        alert.toastmessage('There is some Signin problem');
      }
    }
  }
}
