
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signinsignup/auth/email_verification_screen.dart';
import 'login_screen.dart';
import 'package:signinsignup/alertmessage/database_alert.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  bool load = false;
  bool hidden = true;
  bool obsText = true;
  String _email = "";
  String _username = "";
  String _password = "";

  late final FocusNode _emailFocusNode;
  late final FocusNode _usernameFocusNode;
  late final FocusNode _passwordFocusNode;

  FirebaseAuth _auth =FirebaseAuth.instance;
  @override
  void initState() {
    _emailFocusNode = FocusNode();
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    emailController.dispose();
    userController.dispose();
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
                          children: [
                            SizedBox(height: 150),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Sign Up",
                                    style: TextStyle(
                                        fontSize: 38,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic,
                                        letterSpacing: 1,
                                        wordSpacing: 2))),
                            SizedBox(height: 70,),
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
                                  hintText: 'your personal E-mail Id',
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
                                controller: userController,
                                focusNode: _usernameFocusNode,
                                keyboardType: TextInputType.name,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  prefixIconColor: Colors.black54,
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'Name',
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  hintText: 'what name you want to call your account  ',
                                  hintStyle: TextStyle(
                                      color: Colors.blue, fontSize: 14),
                                ),
                                onSaved: (value){
                                  _username= value!.trim();
                                },
                                validator: (value) {
                                  if (value!.isEmpty || value==null)
                                    return "Please enter the Name";
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
                                  hintText: "please don't use space in Password",
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

                            SizedBox(height: 35),
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
                                  _formkey.currentState!.save();
                                  _auth
                                      .createUserWithEmailAndPassword(
                                      email: emailController.text.toString(),
                                      password: passwordController.text.toString())
                                      .then((value) async{
                                    await _auth.currentUser!.updateDisplayName(_username);
                                    Navigator.push(context,MaterialPageRoute(builder: (context)=>EmailVerificationScreen(username:_username,email:_email,password:_password)));
                                    setState(() {
                                      load=false;
                                    });
                                      }).onError((error, stackTrace) {
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
                                    style: TextStyle(
                                        fontSize: 21, color: Colors.white),
                                  )),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an account?",
                                    style: TextStyle(fontSize: 18)),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginScreen()));
                                  },
                                  child:
                                  Text("Login", style: TextStyle(fontSize: 18)),
                                ),
                              ],
                            )
                          ],
                        ),
            ),
                )
          )),
    );
  }
}