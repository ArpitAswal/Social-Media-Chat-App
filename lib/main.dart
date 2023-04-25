import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:signinsignup/auth/signup_screen.dart';
import 'package:signinsignup/posts/post_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        splashColor: Colors.pinkAccent
      ),

      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  SplashScreenPage createState() => SplashScreenPage();
}

class SplashScreenPage extends State<MyHomePage> {
  @override
 FirebaseAuth auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    if (auth.currentUser != null) {
      Timer(
          Duration(seconds: 10),
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen())));
    } else {
      Timer(
          Duration(seconds: 10),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUpScreen())));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child:
            FadeInImage.assetNetwork(
              fadeOutCurve: Curves.fastOutSlowIn,
               fadeOutDuration: Duration(seconds: 4),
              placeholder: 'assets/loading.gif',
              placeholderFit: BoxFit.fitHeight,
              image: 'https://cdn.dribbble.com/users/6295/screenshots/2923288/firebaseload.gif',
              fit: BoxFit.contain
            ),
      ),
    );
  }
}
