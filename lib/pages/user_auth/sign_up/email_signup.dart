import 'package:flutter/material.dart';
import 'package:invenzine/pages/user_auth/sign_up/password_signup.dart';

// Page optimization is done

// ignore: camel_case_types
class emailreg extends StatefulWidget {
  @override
  _emailregState createState() => _emailregState();
}

// ignore: camel_case_types
class _emailregState extends State<emailreg> {
  String _email;
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[850],
      body: Stack(
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
                      left: size.width / 2.9,
                      right: size.width / 5,
                      top: size.height / 7),
                  child: Text('SignUp',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * 0.1,
                      )),
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
                padding: EdgeInsets.all(size.width * 0.06),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.07,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[850]),
                          ),
                        ),
                        child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            validator: (item) {
                              return item.contains("@")
                                  ? null
                                  : "Enter valid Email";
                            },
                            onChanged: (text) {
                              setState(() {
                                _email = text;
                              });
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Enter Email",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            )),
                      ),
                      SizedBox(
                        height: size.height*0.02,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        width: size.width * 5,
                        height: size.height * 0.07,
                        padding: EdgeInsets.only(left: 50.0, right: 50.0),
                        child: RaisedButton(
                          color: Colors.yellow,
                          child: Text(
                            "Next",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * 0.05),
                          ),
                          onPressed: () {
                            if (_formkey.currentState.validate()) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      passwordReg(sup_email: _email)));
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
            top: size.height / 15,
            left: size.width / 17,
            right: size.width / 17,
            bottom: size.height / 3,
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.27),
              child: Image(
                image: AssetImage('assets/img/email-icon.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
