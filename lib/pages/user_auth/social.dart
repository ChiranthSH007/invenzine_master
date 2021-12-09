import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:invenzine/pages/home_pages/bot_navbar.dart';
import 'package:invenzine/pages/user_auth/auth.dart';

// Page optimization is done

import 'sign_in/email_signin.dart';

class Social extends StatefulWidget {
  @override
  _SocialState createState() => _SocialState();
}

class _SocialState extends State<Social> {
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: size.width,
                height: size.height / 2,
                color: Colors.yellow,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: size.width / 2.8,
                      right: size.width / 5,
                      top: size.height / 8),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontSize: size.width * 0.1,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.07,
                ),
                Container(
                  height: size.height * 0.6,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: loginButton(), //google login
                          height: size.height * 0.1,
                        ),
                        Container(
                          height: size.height * 0.1,
                          child: OutlineButton(
                            borderSide:
                                BorderSide(width: 1.0, color: Colors.white),
                            child: Image(
                              image: AssetImage('assets/img/fblogin.png'),
                              height: 70,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        Container(
                          height: size.height * 0.1,
                          child: OutlineButton(
                            borderSide:
                                BorderSide(width: 1.0, color: Colors.white),
                            disabledBorderColor: Colors.white,
                            child: Image(
                              image: AssetImage('assets/img/twitter.png'),
                              height: 70,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        Container(
                          height: size.height * 0.1,
                          child: OutlineButton(
                            borderSide:
                                BorderSide(width: 1.0, color: Colors.white),
                            disabledBorderColor: Colors.white,
                            child: Image(
                              image: AssetImage('assets/img/noremail.png'),
                              height: 70,
                            ),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => emailin()));
                            },
                          ),
                        ),
                        // SizedBox(
                        //   height: 48,
                        // ),
                        // clickabletext(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Expanded buildDivider() {
  //   return Expanded(
  //     child: Divider(
  //       color: Color(0xFFD9D9D9),
  //       height: 1.5,
  //     ),
  //   );
  // }

  void click() {
    signInWithGoogle().then((user) => {
          this.user = user,
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => MyHomePage()),
              (Route<dynamic> route) => false)
        });
  }

  Widget loginButton() {
    return OutlineButton(
      borderSide: BorderSide(width: 1.0, color: Colors.white),
      onPressed: this.click,
      splashColor: Colors.yellow,
      color: Colors.yellow,
      child: Image(
        image: AssetImage('assets/img/google_signin.png'),
        height: 70,
      ),
    );
  }
}

// class clickabletext extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     TextStyle defaultStyle = TextStyle(color: Colors.black, fontSize: 20.0);
//     TextStyle linkStyle = TextStyle(
//       color: Colors.black,
//       fontSize: MediaQuery.of(context).textScaleFactor * 20,
//     );
//     return RichText(
//       text: TextSpan(
//         style: defaultStyle,
//         children: <TextSpan>[
//           TextSpan(
//               text: 'Skip Without Login',
//               style: linkStyle,
//               recognizer: TapGestureRecognizer()
//                 ..onTap = () {
//                   Navigator.push(
//                       context, MaterialPageRoute(builder: (_) => MyHomePage()));
//                 }),
//         ],
//       ),
//     );
//   }
// }
