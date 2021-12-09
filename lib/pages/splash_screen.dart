import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:invenzine/pages/user_auth/social.dart';
import 'package:invenzine/services/dynamiclinks.dart';
import 'package:invenzine/services/locator.dart';
import 'home_pages/bot_navbar.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();

  bool _isUserEmailVerified;
  @override
  void initState() {
    _dynamicLinkService.handleDynamicLinks();
    super.initState();
    Timer(Duration(seconds: 3), () {
      FirebaseAuth.instance.currentUser().then((firebaseUser) {
        if (firebaseUser == null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => Social()),
              (Route<dynamic> rr) => false);
        } else {
          // if (firebaseUser.isEmailVerified) {
          //   setState(() {
          //     _isUserEmailVerified = firebaseUser.isEmailVerified;
          //   });
          //   if (_isUserEmailVerified == true) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => MyHomePage()),
              (route) => false);
          // } else {
          //   Fluttertoast.showToast(msg: "Email not verified");
          //Navigator.pushAndRemoveUntil(context,
          // MaterialPageRoute(builder: (_) => Social()), (route) => false);
          // }
          //}
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //   body: Container(
        // color: Colors.white,
        backgroundColor: Colors.grey[900],
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.yellowAccent[400]),
            child: Center(
                child: Image(
              image: AssetImage('assets/img/sclogo.png'),
              width: 230,
            )),
            // ),
          ),
        ));
  }

// Extra Stuf

/*checkUserSignIn().then((status) {
      if (status) {
        _navigate();
      } else {
        _navigateHome();
      }
    });*/

  /*Future<bool> _checkUserSignIn() async {
    await Future.delayed(Duration(milliseconds: 5000), () {});
    
    return true;
  }


   void _navigate() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext content) => Social()));
  }

  void _navigateHome() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext content) => MyHomePage()));
  }

  */

}
