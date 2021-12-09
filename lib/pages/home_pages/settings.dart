import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:invenzine/pages/user_auth/auth.dart';
import 'package:invenzine/pages/user_auth/social.dart';
import 'package:invenzine/services/crud.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  CrudMethods crudMethods = new CrudMethods();

  FirebaseUser currentUser;
  //String _newpwd;

  String adminuname;
  @override
  void initState() {
    //email getting
    _loadCurrentUser();
    super.initState(); //email getting
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  String _uemail() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return null;
    }
  }

  String _uname() {
    if (currentUser != null) {
      return currentUser.displayName;
    } else {
      return null;
    }
  }

  Widget logoutButton(String text) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: OutlineButton(
        onPressed: () async {
          await signOutGoogle();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Social()));
        },
        splashColor: Colors.redAccent,
        child: Padding(
          padding: EdgeInsets.only(
              left: size.width / 52,
              right: size.width / 52,
              top: size.height / 52,
              bottom: size.height / 52),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: size.width / 25),
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: size.width * 0.05, color: Colors.white),
                ),
              ),
              Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              height: size.height / 2,
              width: size.width / 1.2,
              child: _uemail() != null
                  ? Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            left: size.width / 20,
                            right: size.width / 20,
                            top: size.height / 15,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "UserName: " +
                                  _uname()
                                      .toString(), //currentUser.displayName,
                              style: TextStyle(
                                fontSize: size.width * 0.05,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.width * 0.001,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: size.width / 20,
                              right: size.width / 20,
                              top: size.height / 52,
                              bottom: size.height / 52),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Email:  " +
                                        _uemail()
                                            .toString(), //currentUser.displayName,
                                    style: TextStyle(
                                      fontSize: size.width * 0.04,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       border: Border(
                        //         bottom: BorderSide(color: Colors.grey[850]),
                        //       ),
                        //     ),
                        //     child: TextField(
                        //       onChanged: (item) {
                        //         setState(() {
                        //           _newpwd = item;
                        //         });
                        //       },
                        //       decoration: InputDecoration(
                        //         hintText: "Password Reset",
                        //         border: InputBorder.none,
                        //         focusedBorder: InputBorder.none,
                        //         enabledBorder: InputBorder.none,
                        //         errorBorder: InputBorder.none,
                        //         disabledBorder: InputBorder.none,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // FlatButton(
                        //   onPressed: () {
                        //     _changePassword(_newpwd.toString());
                        //   },
                        //   child: Text("Reset"),
                        //   color: Colors.greenAccent,
                        // ),
                        SizedBox(
                          height: 120,
                        ),
                        logoutButton('Log Out')
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Please Login",
                            style: TextStyle(
                                fontSize: size.width * 0.065,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: size.height * 0.03),
                          loginButton(),
                        ],
                      ),
                    ),
            ),
          ),
          Container(
            child: Positioned(
              top: size.height / 42,
              bottom: size.height / 1.7,
              left: size.width / 3,
              right: size.width / 3,
              child: Image(
                  image: AssetImage('assets/img/login-logof.png'),
                  width: size.width / 3,
                  height: size.height / 3),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginButton() {
    Size size = MediaQuery.of(context).size;
    return OutlineButton(
      onPressed: () async {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Social()));
      },
      splashColor: Colors.redAccent,
      child: Padding(
        padding: EdgeInsets.only(
            left: size.width / 52,
            right: size.width / 52,
            top: size.height / 52,
            bottom: size.height / 52),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: size.width / 35),
              child: Text(
                "Login",
                style: TextStyle(fontSize: size.width * 0.055),
              ),
            ),
            Icon(
              Icons.exit_to_app,
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  void _changePassword(String password) async {
    //Create an instance of the current user.
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_) {
      print("Succesfull changed password");
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }
}
