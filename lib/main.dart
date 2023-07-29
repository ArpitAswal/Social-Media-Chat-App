import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:signinsignup/auth/signup_screen.dart';
import 'package:signinsignup/posts/post_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        splashColor: Colors.pinkAccent
      ),

      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  SplashScreenPage createState() => SplashScreenPage();
}

class SplashScreenPage extends State<MyHomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    if (auth.currentUser != null) {
      Timer(
          const Duration(seconds: 10),
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PostScreen())));
    } else {
      Timer(
          const Duration(seconds: 10),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => const SignUpScreen())));
    }
  }

  @override
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
               fadeOutDuration: const Duration(seconds: 4),
              placeholder: 'assets/loading.gif',
              placeholderFit: BoxFit.fitHeight,
              image: 'https://cdn.dribbble.com/users/6295/screenshots/2923288/firebaseload.gif',
              fit: BoxFit.contain
            ),
      ),
    );
  }
}
