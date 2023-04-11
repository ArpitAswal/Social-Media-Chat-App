import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signinsignup/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:signinsignup/posts/post_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class MyHomePage extends StatefulWidget{
  SplashScreenPage createState()=> SplashScreenPage();
}
class SplashScreenPage extends State<MyHomePage>{
  @override
 FirebaseAuth auth=FirebaseAuth.instance;


  void initState() {
    super.initState();

    if (auth.currentUser != null) {
      Timer(Duration(seconds: 8),
              () =>
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PostScreen()
              )));
    }
    else{
      Timer(Duration(seconds: 5),
              () =>
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => LoginScreen()
              )));

    }
  }

  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black45,
      //color: Colors.orangeAccent,
      child:  Center(
       // child:Text('Firebase',style:TextStyle(fontWeight:FontWeight.w500,fontSize: 25,color:Colors.deepOrange))
     // child:(Image.asset('assets/images.jpg')),
        child:FadeInImage.assetNetwork(placeholder: 'assets/loading.gif',
          image:'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGtywz074yCMXBYce9ek38S8_AmFKR92gd-w&usqp=CAU',
        height: MediaQuery.of(context).size.height, )
      ),
    );
  }
}
