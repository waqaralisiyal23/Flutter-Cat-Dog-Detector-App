import 'package:cat_dog_classifier/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: HomeScreen(),
      title: Text(
        'Cat & Dog Classifiers',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22.0,
          color: Colors.yellowAccent,
        ),
      ),
      image: Image.asset('assets/images/cat_dog.jpg'),
      backgroundColor: Colors.blueAccent,
      photoSize: 60,
      loaderColor: Colors.redAccent,
    );
  }
}
