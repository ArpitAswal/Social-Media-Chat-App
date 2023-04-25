import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:signinsignup/alertmessage/database_alert.dart';
import 'package:flutter/material.dart';
import 'package:signinsignup/auth/login_withPhone.dart';
import 'package:signinsignup/auth/signup_screen.dart';
import '../forgot_screen.dart';
import '../posts/post_screen.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  String _email='';
  String _password='';
  bool verified=false;
  @override
  void initState() {
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/login.png'), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
                child: Form(
                 key: _formkey,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 26),
                    children:[
                      SizedBox(height: 150,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Sign In",
                            style: TextStyle(
                                fontSize: 36,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                letterSpacing: 1,
                                wordSpacing: 2))),
              SizedBox(
                height: 70,
              ),
       TextFormField(
      controller: emailController,
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
      prefixIconColor: Colors.black54,
      prefixIcon: Icon(Icons.email_rounded),
      labelText: 'E-mail',
      labelStyle: TextStyle(
      color: Colors.black, fontSize: 18),
      hintText: 'your account E-mail Id',
      hintStyle: TextStyle(
      color: Colors.blue, fontSize: 14),
      ),
      onSaved: (value){
       _email= value!.trim();
      },
      validator: (value) {
      if (value!.isEmpty || value==null)
      return "Please enter the E-mail Id";
      else
      return null;
      }),
      SizedBox(height: 10,),
      TextFormField(
      controller: passwordController,
      focusNode: _passwordFocusNode,
      keyboardType: TextInputType.text,
      obscureText: obsText,
      autocorrect: false,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
      prefixIconColor: Colors.black54,
      prefixIcon: Icon(Icons.lock),
      labelText: 'Password',
      labelStyle: TextStyle(
      color: Colors.black, fontSize: 18),
      hintText: 'Enter your account password',
      hintStyle: TextStyle(
      color: Colors.blue, fontSize: 14),
      suffixIcon: InkWell(
      onTap: _togglePassword,
      child: Icon(
      hidden
      ? Icons.visibility_off
        : Icons.visibility,
      color: Colors.black54,
      ),
      ),),
      onSaved: (value){
      _password = value!.trim();
      },
      validator: (value) {
      if (value!.isEmpty || value==null)
      return "Please enter the Password";
      else
      return null;
      }),
      Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ForgotPasswordScreen()));
                  },
                  child: Text("Forgot Password?",
                      style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  elevation: 5,
                    shadowColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(21)),
                        side: BorderSide(color: Colors.white,width: 1.5)),
                    backgroundColor: Colors.deepPurple),
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    setState(() {
                      load = true;
                    });
                      _auth
                          .signInWithEmailAndPassword(
                          email: emailController.text.toString(),
                          password:
                          passwordController.text.toString())
                          .then((value) {
                        verified = _auth.currentUser!.emailVerified;
                        if(verified){
                           alert
                                  .toastmessage(value.user!.email.toString());
                             alert.toastmessage("Email Successfully Verified");
                               Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => PostScreen()));
                         }
                            else{
                                alert.toastmessage('This account is still not verified, Try again signup and first verify then signin');
                                }
                            setState(() {
                              load = false;
                            });
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
                            'Login',
                            style: TextStyle(
                                fontSize: 21, color: Colors.white),
                          )),
              ),

              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Or Sign in with',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 5,),
                      Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 7,
                        shadowColor: Colors.teal[100],
                        shape: CircleBorder(
                            side: BorderSide(
                                color: Colors.cyan.shade100, width: 2))),
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/google.png'),
                      radius: 30,
                    ),
                    onPressed: () {
                      _signin(context);
                    },
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 7,
                          shadowColor: Colors.grey,
                          shape: CircleBorder(
                              side: BorderSide(
                                  color: Colors.white, width: 2))),
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/phone.png'),
                        radius: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LoginWithPhoneNumber(
                                      choice: 'login',
                                    )));
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",
                      style: TextStyle(fontSize: 18)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: Text("Sign up",
                        style: TextStyle(fontSize: 18)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),)),
    );
  }

  Future<void> _signin(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      UserCredential result = await _auth.signInWithCredential(authCredential);
    }
    // Getting users credential
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => PostScreen()));
    googleSignIn.signOut();
  }
}



