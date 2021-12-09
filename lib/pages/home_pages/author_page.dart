import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invenzine/pages/home_pages/searchresult.dart';
import 'package:invenzine/services/crud.dart';

class Author_page extends StatefulWidget {
  final String ademail, adminname;
  const Author_page({Key key, this.ademail, this.adminname}) : super(key: key);
  @override
  _Author_pageState createState() => _Author_pageState();
}

// ignore: camel_case_types
class _Author_pageState extends State<Author_page> {
  String imgUrl;
  File selectedImage;
  String followBtn = "Follow";
  Color followclr = Colors.yellow;
  bool following = false;
  int post_no, follow_num;
  Stream newStream;
  FirebaseUser currentUser;
  CrudMethods crudMethods = new CrudMethods();

  @override
  void initState() {
    _loadCurrentUser();
    crudMethods.getprofiledata(widget.adminname.toString()).then((result) {
      setState(() {
        newStream = result;
        // post_no = result.data.documents.length;
        // print(post_no);
      });
    });
    checkStatus();
    getAuthordata();
    super.initState();
  }

  checkStatus() async {
    Firestore firestore = Firestore.instance;
    DocumentReference docref =
        Firestore.instance.collection("LocalAdmins").document(widget.ademail);
    DocumentSnapshot doc = await docref.get();
    List follrs = doc.data['Subscribers'];
    int fll_num = follrs.length;
    QuerySnapshot q;
    q = await firestore
        .collection("News")
        .where("adminname", isEqualTo: widget.adminname)
        .getDocuments();
    int pstnum = q.documents.length;
    setState(() {
      follow_num = fll_num;
      post_no = pstnum;
    });
    if (follrs.contains(_email().toString()) == true) {
      setState(() {
        following = true;
        followBtn = "UnFollow";
        followclr = Colors.grey;
      });
    } else {
      setState(() {
        following = false;
        followBtn = "Follow";
        followclr = Colors.yellow;
      });
    }
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  // ignore: missing_return
  String _uid() {
    if (currentUser != null) {
      return currentUser.uid;
    }
  }

  String _email() {
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

  getAuthordata() async {
    DocumentReference docref =
        Firestore.instance.collection("LocalAdmins").document(widget.ademail);
    DocumentSnapshot doc = await docref.get();
    String url = doc.data['imgurl'];
    setState(() {
      imgUrl = url;
    });
  }

  Future getImage() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //super.build(context); // reloads state when opened again

    Column pro_pic(String url, String name, Size size) {
      return Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                child: GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: imgUrl != null
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: url,
                            height: size.height * 0.2,
                            width: size.width * 0.4,
                            fit: BoxFit.cover,
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          maxRadius: size.height * 0.1,
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                Container(
                  child: Text(
                    name,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  width: size.width * 0.6,
                  height: size.height * 0.04,
                  padding: EdgeInsets.only(left: 50.0, right: 50.0),
                  child: RaisedButton(
                    color: followclr,
                    child: Text(
                      followBtn,
                      style: TextStyle(
                          color: Colors.black, fontSize: size.width * 0.037),
                    ),
                    onPressed: () {
                      followClick();
                    },
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }

    Row follow_row(int followers_no, int posts_no) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text("Followers"),
                ),
                follow_num != null
                    ? Container(
                        child: Text(
                          followers_no.toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : Container(
                        child: Text(
                          "Loading..",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text("Posts"),
              ),
              post_no != null
                  ? Container(
                      child: Text(
                        posts_no.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(
                      child: Text(
                        "Loading..",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    )
            ],
          )
        ],
      );
    }

    // StreamBuilder posttile() {
    //   return ;
    // }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          _uname() == widget.adminname
              ? pro_pic(imgUrl, widget.adminname.toString(), size)
              : Column(
                  children: [
                    imgUrl != null
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: imgUrl,
                              height: size.height * 0.2,
                              width: size.width * 0.4,
                              fit: BoxFit.cover,
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            maxRadius: size.height * 0.1,
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            child: Text(
                              widget.adminname,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.015,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            width: size.width * 0.6,
                            height: size.height * 0.04,
                            padding: EdgeInsets.only(left: 50.0, right: 50.0),
                            child: RaisedButton(
                              color: followclr,
                              child: Text(
                                followBtn,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.width * 0.037),
                              ),
                              onPressed: () {
                                followClick();
                              },
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
          SizedBox(
            height: size.height * 0.005,
          ),
          Row(children: <Widget>[
            Expanded(
              child: new Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Divider(
                  color: Colors.black,
                  thickness: 0.65,
                  height: size.height * 0.045,
                ),
              ),
            ),
          ]),
          follow_row(follow_num, post_no),
          Row(children: <Widget>[
            Expanded(
              child: new Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Divider(
                  color: Colors.black,
                  thickness: 0.65,
                  height: size.height * 0.045,
                ),
              ),
            ),
          ]),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: newStream != null
                  ? Container(
                      child: StreamBuilder(
                      stream: newStream,
                      builder: (context, snapshot) {
                        if (snapshot.data == null)
                          return CircularProgressIndicator();
                        return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (content, index) {
                            QuerySnapshot snap = snapshot.data; // Snapshot
                            List<DocumentSnapshot> items =
                                snap.documents; // List of Documents
                            DocumentSnapshot item =
                                items[index]; //Specific Document
                            return Result_tile(
                              title: item.data['title'],
                              description: item.data['desc'],
                              imgUrl: item.data['imgUrl'],
                              likeno: item.data['likes'],
                              dislikeno: item.data['dislikes'],
                              uid: _uid().toString(),
                              docuid: item.documentID,
                              adminname: item.data['adminname'],
                            );
                          },
                        );
                      },
                    ))
                  : Container(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  followClick() async {
    DocumentReference docref =
        Firestore.instance.collection("LocalAdmins").document(widget.ademail);
    DocumentSnapshot doc = await docref.get();
    List followers = doc.data['Subscribers'];
    if (followers.contains(_email().toString()) == true) {
      docref.updateData({
        'Subscribers': FieldValue.arrayRemove([_email().toString()]),
        // 'likes': likes - 1,
      });
      checkStatus();
    } else {
      docref.updateData({
        'Subscribers': FieldValue.arrayUnion([_email().toString()]),
        // 'likes': likes - 1,
      });
      checkStatus();
    }
  }
}
