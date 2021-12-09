import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invenzine/pages/home_pages/bot_navbar.dart';

class passwordReg extends StatefulWidget {
  // ignore: non_constant_identifier_names
  String sup_email;
  // ignore: non_constant_identifier_names
  passwordReg({Key key, this.sup_email}) : super(key: key);
  @override
  _passwordRegState createState() => _passwordRegState(sup_email);
}

// ignore: camel_case_types
class _passwordRegState extends State<passwordReg> {
  String sup_email;
  _passwordRegState(this.sup_email);

  String _password, _confpassword, _uname;
  bool _isUserEmailVerified;
  bool isLoading = false;
  var _formkey = GlobalKey<FormState>();
  bool autoValidate = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[850],
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: size.width,
                      height: size.height / 1.7,
                      color: Colors.yellow,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: size.width / 4.8,
                            right: size.width / 5,
                            top: size.height / 8),
                        child: Column(
                          children: [
                            Text(
                              'Password',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * 0.09),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: size.height / 2.9,
                  left: size.width / 14,
                  right: size.width / 14,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: EdgeInsets.all(size.width * 0.09),
                      child: Form(
                        key: _formkey,
                        autovalidate: autoValidate,
                        child: Column(
                          children: [
                            Text(
                              sup_email,
                              style: TextStyle(fontSize: size.width * 0.045),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[850]))),
                              child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  validator: (item) {
                                    return item.isNotEmpty
                                        ? null
                                        : "UserName Should not be Empty";
                                  },
                                  onChanged: (item) {
                                    setState(() {
                                      _uname = item;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Enter UserName",
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  )),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[850]))),
                              child: TextFormField(
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  validator: (item) {
                                    return item.length > 6
                                        ? null
                                        : "Password must be 6 characters";
                                  },
                                  onChanged: (item) {
                                    setState(() {
                                      _password = item;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Enter Password",
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  )),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[850]))),
                              child: TextFormField(
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  validator: (item) {
                                    return item == _password
                                        ? null
                                        : "Password Dont Match";
                                  },
                                  onChanged: (item) {
                                    setState(() {
                                      _confpassword = item;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Confirm Password",
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  )),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              width: size.width * 2,
                              height: size.height * 0.07,
                              padding: EdgeInsets.only(left: 50.0, right: 50.0),
                              child: RaisedButton(
                                color: Colors.yellow,
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.width * 0.05),
                                ),
                                onPressed: () {
                                  if (_formkey.currentState.validate()) {
                                    signup();
                                    _showMyDialog();
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Please Enter the Right Credentials",
                                        backgroundColor: Colors.grey[400],
                                        textColor: Colors.black);
                                  }
                                },
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: size.height / 22,
                  left: size.width / 17,
                  right: size.width / 17,
                  bottom: size.height / 3,
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.27),
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/img/pass.png'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  //verification and Signup Backend
  Future<void> signup() async {
    if (_formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      FirebaseAuth _auth = FirebaseAuth.instance;
      try {
        AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: sup_email,
          password: _confpassword,
        );
        setState(() {
          isLoading = false;
        });
        FirebaseUser user = authResult.user;
        try {
          await user.sendEmailVerification();
          var userUpdateInfo =
              new UserUpdateInfo(); //for registering the username to .displayname
          userUpdateInfo.displayName = _uname;
          await user.updateProfile(userUpdateInfo);

          if (user.isEmailVerified) {
            setState(() {
              _isUserEmailVerified = user.isEmailVerified;
            });
          }
        } catch (e) {
          print("An error occured while trying to send email verification");
          print(e.message);
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
              msg: "Error" + e.toString(),
              backgroundColor: Colors.grey[400],
              textColor: Colors.black);
        }
      } on PlatformException catch (e) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: "Error" + e.toString(),
            backgroundColor: Colors.grey[400],
            textColor: Colors.black);
        print(e.details);
      }
    }
  }

  // ignore: non_constant_identifier_names
  check_email_verification() async {
    if (_isUserEmailVerified == true) {
      Fluttertoast.showToast(
          msg: "Registration Successfull",
          backgroundColor: Colors.grey[400],
          textColor: Colors.black);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MyHomePage()),
          (Route<dynamic> route) => false);
    } else {
      CircularProgressIndicator();
      Fluttertoast.showToast(
          msg: "Email not verified",
          backgroundColor: Colors.grey[400],
          textColor: Colors.black);
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Email Verified'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Registration Successfull'),
                Text('Please Verify Your Email....!!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Done'),
              onPressed: () {
                check_email_verification();
              },
            ),
          ],
        );
      },
    );
  }
}
