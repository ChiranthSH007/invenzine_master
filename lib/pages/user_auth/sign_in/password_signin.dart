import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invenzine/pages/home_pages/bot_navbar.dart';

// Page optimization is done

// ignore: camel_case_types
class passwordPage extends StatefulWidget {
  @override
  String sin_email;
  passwordPage({Key key, this.sin_email}) : super(key: key);
  _passwordPageState createState() => _passwordPageState(sin_email);
}

class _passwordPageState extends State<passwordPage> {
  String sin_email;
  _passwordPageState(this.sin_email);

  String _password;
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
                      height: size.height / 1.9,
                      color: Colors.yellow,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: size.width / 3.6,
                            right: size.width / 5,
                            top: size.height / 8),
                        child: Text('Password',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.1)),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: size.height / 2.7,
                  left: size.width / 12,
                  right: size.width / 12,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: EdgeInsets.all(size.width * 0.09),
                      child: Form(
                          key: _formkey,
                          autovalidate: autoValidate,
                          child: Column(children: [
                            SizedBox(
                              height: size.height * 0.07,
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
                                        : "Error: Please check ur EmailId and Password";
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
                              margin: EdgeInsets.symmetric(vertical: 5),
                              width: size.width * 2,
                              height: size.height * 0.07,
                              padding: EdgeInsets.only(left: 50.0, right: 50.0),
                              child: RaisedButton(
                                color: Colors.yellow,
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.width * 0.05),
                                ),
                                onPressed: () {
                                  signin();
                                },
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                          ])),
                    ),
                  ),
                ),
                Positioned(
                  top: size.height / 15,
                  left: size.width / 17,
                  right: size.width / 17,
                  bottom: size.height / 3,
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.27),
                    child: Image(
                      image: AssetImage('assets/img/password-icon.png'),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  //sign with email and pwd
  void signin() {
    bool _isUserEmailVerified;
    if (_formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: sin_email, password: _password)
          .then((user) async {
        setState(() {
          isLoading = false;
        });
        await FirebaseAuth.instance.currentUser()
          ..reload();
        var user = await FirebaseAuth.instance.currentUser();
        if (user.isEmailVerified) {
          setState(() {
            _isUserEmailVerified = user.isEmailVerified;
          });
        }
        if (_isUserEmailVerified == true) {
          Fluttertoast.showToast(
              msg: "Login Successfull",
              backgroundColor: Colors.grey[400],
              textColor: Colors.black);

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => MyHomePage()),
              (Route<dynamic> route) => false);
        } else {
          Fluttertoast.showToast(
              msg: "Email not verified",
              backgroundColor: Colors.grey[400],
              textColor: Colors.black);
        }
      }).catchError(() {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: "Please Enter correct Email Id and Password",
            backgroundColor: Colors.grey[400],
            textColor: Colors.black);
      });
    }
  }
}
