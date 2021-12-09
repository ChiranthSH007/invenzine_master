import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:invenzine/pages/home_pages/author_page.dart';
import 'package:invenzine/pages/home_pages/comments.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

// ignore: camel_case_types
class Full_view extends StatefulWidget {
  // final String imgurl, title, desc, docid, uid;
  final String docid;
  //  final int likeno; // dislikeno;
  //  final DateTime date;

  const Full_view(
      {Key key,
      //this.imgurl,
      //this.title,
      //this.uid,
      //this.likeno,
      //this.dislikeno,
      // this.desc,
      // this.date,
      this.docid})
      : super(key: key);
  @override
  _Full_viewState createState() => _Full_viewState();
}

// ignore: camel_case_types
class _Full_viewState extends State<Full_view> {
  Stream newStream;
  DateTime created_time;
  SheetController controller = SheetController();
  FirebaseUser currentUser;
  String titlefnl, descfnl, imgurlfnl, adname;
  int likes;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(),
      body: SlidingSheet(
        controller: controller,
        elevation: 8,
        minHeight: MediaQuery.of(context).size.height,
        cornerRadius: 16,
        closeOnBackdropTap: true,
        closeOnBackButtonPressed: true,
        addTopViewPaddingOnFullscreen: true,
        isBackdropInteractable: true,
        snapSpec: SnapSpec(
          snap: true,
          positioning: SnapPositioning.relativeToAvailableSpace,
          snappings: const [
            SnapSpec.headerFooterSnap,
            0.6,
            SnapSpec.expanded,
          ],
        ),
        // snapSpec: const SnapSpec(
        //   snap: true,
        //   snappings: [0.45, 0.100, 1],
        //   positioning: SnapPositioning.relativeToAvailableSpace,
        // ),
        // parallaxSpec: const ParallaxSpec(
        //   enabled: true,
        //   amount: 0.35,
        //   endExtent: 0.6,
        // ),
        liftOnScrollHeaderElevation: 12.0,
        liftOnScrollFooterElevation: 12.0,
        body: likes != null //|| dislikeno != null
            ? Center(
                child: Container(
                  height: size.height * 0.86,
                  width: size.width * 0.95,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: ListView(children: [
                    Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        // boxShadow: <BoxShadow>[
                        //   BoxShadow(
                        //       color: Colors.grey.withOpacity(0.5),
                        //       spreadRadius: 4,
                        //       blurRadius: 10.0,
                        //       offset: Offset(0.0, 0.55))
                        // ],
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            child: CachedNetworkImage(
                              imageUrl: imgurlfnl.toString(),
                              height: 200,
                              width: size.width,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          titleSection(titlefnl, created_time),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
                            child: adminText(context, adname, _email()),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    buttoncolumn(
                        docid: widget.docid,
                        likeno: likes,
                        // dislikeno: dislikeno,
                        uid: _uid()),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    textSection(descfnl, widget.docid, context),
                  ]),
                ),
              )
            : Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
        headerBuilder: (context, state) {
          return Comment(
            docid: widget.docid,
          );
          // Container(
          //   padding: EdgeInsets.fromLTRB(120, 3, 120, 0),
          //   child: Divider(
          //     color: Colors.grey[400],
          //     thickness: 5,
          //   ),
          // );
        },
        builder: (context, state) {
          return Container(
            child: Column(
              children: [
                PostList(
                  docid: widget.docid,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    _loadCurrentUser();
    super.initState();
    _getfullviewdata();
  }

  void _loadCurrentUser() async {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  String _email() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return null;
    }
  }

  String _uid() {
    if (currentUser != null) {
      print(currentUser.uid);
      return currentUser.uid;
    } else {
      return null;
    }
  }

  _getfullviewdata() async {
    DocumentReference docref =
        Firestore.instance.collection("News").document(widget.docid);
    DocumentSnapshot doc = await docref.get();
    String title = doc.data['title'];
    String imgurl = doc.data['imgUrl'];
    String desc = doc.data['desc'];
    String admname = doc.data['adminname'];
    DateTime time;
    //DateTime date = doc.data['date'].toDate();
    int likeno = doc.data['likes'];
    setState(() {
      imgurlfnl = imgurl;
      descfnl = desc;
      created_time = time;
      likes = likeno;
      adname = admname;
      titlefnl = title;
    });
    print(adname);
  }
}

Container adminText(BuildContext context, String adname, String email) {
  return Container(
    alignment: Alignment.centerLeft,
    child: adname != null
        ? RichText(
            text: TextSpan(
              style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.05),
              children: <TextSpan>[
                TextSpan(
                  text: adname,
                  style: GoogleFonts.raleway(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => Author_page(
                                    ademail: email,
                                    adminname: adname.toString(),
                                  )));
                    },
                ),
              ],
            ),
          )
        : Text('Loading'),
  );
}

Column textSection(String desc, String docid, BuildContext context) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(18),
        child: Text(
          desc,
          style: GoogleFonts.nunito(
            fontSize: 14,
          ),
          softWrap: true,
        ),
      ),
      // Align(
      //   alignment: Alignment.bottomCenter,
      //   child: Container(
      //     child: Comment(
      //       docid: docid,
      //     ),
      //   ),
      // ),
      SizedBox(height: 15),

      // Container(
      //   child: RichText(
      //     text: TextSpan(
      //       style: TextStyle(
      //           color: Colors.black,
      //           fontSize: MediaQuery.of(context).size.width * 0.043),
      //       children: <TextSpan>[
      //         TextSpan(
      //             text: 'View Comments',
      //             style: TextStyle(
      //               color: Colors.blue,
      //             ),
      //             recognizer: TapGestureRecognizer()
      //               ..onTap = () {
      //                 Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (content) => CommentSection(
      //                               docid: docid,
      //                             )));
      //               }),
      //       ],
      //     ),
      //   ),
      // ),
      // SizedBox(height: 15),
    ],
  );
}

Container titleSection(String title, DateTime dateTime) {
  return Container(
    child: Row(children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
              child: Text(
                title,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            // Padding(
            //     padding: const EdgeInsets.all(5),
            //     child: dateTime != null
            //         ? Text(
            //             DateFormat('yyyy-MM-dd–kk:mm').format(dateTime),
            //             style: TextStyle(color: Colors.black54, fontSize: 14),
            //           )
            //         : Text("Loading..."))
          ],
        ),
      ),
    ]),
  );
}

// ignore: camel_case_types
class buttoncolumn extends StatefulWidget {
  final String docid, uid;
  final int likeno; // dislikeno;
  const buttoncolumn({
    Key key,
    this.docid,
    this.likeno,
    this.uid,
    //this.dislikeno
  }) : super(key: key);
  @override
  _buttoncolumnState createState() => _buttoncolumnState();
}

// ignore: camel_case_types
class _buttoncolumnState extends State<buttoncolumn> {
  int likeno;
  //int dislikeno;
  bool like;
  String share_link;
  DateTime created_time;
  //bool dislike;
  List<String> likelist = new List<String>();
  //List<String> dislikelist = new List<String>();
  Color _likeiconColor = Colors.black;
  //Color _dislikeiconColor = Colors.grey;

  _checkStatus() async {
    DocumentReference docref =
        Firestore.instance.collection("News").document(widget.docid);
    DocumentSnapshot doc = await docref.get();
    List likelst = doc.data['like'];
    int likes = doc.data['likes'];
    setState(() {
      likelist = List.from(likelst);
      likeno = likes;
    });
    //List dislikelst = doc.data['dislike'];
    //int dislikes = doc.data['dislikes'];
    //setState(() {
    //  dislikelist = List.from(dislikelst);
    //  dislikeno = dislikes;
    //});
    like = likelist.contains(widget.uid.toString());
    //dislike = dislikelist.contains(widget.uid.toString());
    if (like == true) {
      setState(() {
        _likeiconColor = Colors.blue;
        like = true;
      });
    } //else if (dislike == true) {
    //setState(() {
    // _dislikeiconColor = Colors.blue;
    //  dislike = true;
    //});
    //}
    await createFirstPostLink(widget.docid);
  }

  @override
  void initState() {
    _checkStatus();
    super.initState();
  }

  // ignore: missing_return
  Future<String> createFirstPostLink(String title) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://invenzine.page.link',
      link: Uri.parse('https://techmag-77e4a.web.app/articleview/$title'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.invenzine',
      ),
      // NOT ALL ARE REQUIRED ===== HERE AS AN EXAMPLE =====
      // iosParameters: IosParameters(
      //   bundleId: 'com.example.ios',
      //   minimumVersion: '1.0.1',
      //   appStoreId: '123456789',
      // ),
      // googleAnalyticsParameters: GoogleAnalyticsParameters(
      //   campaign: 'example-promo',
      //   medium: 'social',
      //   source: 'orkut',
      // ),
      // itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
      //   providerToken: '123456',
      //   campaignToken: 'example-promo',
      // ),
      // socialMetaTagParameters: SocialMetaTagParameters(
      //   title: 'Example of a Dynamic Link',
      //   description: 'This link works whether app is installed or not!',
      // ),
    );

    final Uri dynamicUrl = await parameters.buildUrl();
    setState(() {
      share_link = dynamicUrl.toString();
    });
  }

  Future<void> share() async {
    await FlutterShare.share(
        linkUrl: share_link,
        chooserTitle: 'Example Chooser Title',
        title: "Share, Post");
  }

  likeclk() async {
    DocumentReference docref =
        Firestore.instance.collection("News").document(widget.docid);
    DocumentSnapshot doc = await docref.get();
    List likelst = doc.data['like'];
    //List dislikelst = doc.data['dislike'];
    int likes = doc.data['likes'];
    //int dislikes = doc.data['dislikes'];

    // if (dislike == true) {
    //   if (dislikelst.contains(widget.uid) == true) {
    //     docref.updateData({
    //       'dislike': FieldValue.arrayRemove([widget.uid]),
    //       'like': FieldValue.arrayUnion([widget.uid]),
    //       'likes': likes + 1,
    //       'dislikes': dislikes - 1,
    //     });
    //   }
    //   setState(() {
    //     likeno = likes;
    //     dislikeno = dislikes;
    //     like = true;
    //     dislike = false;
    //     _likeiconColor = Colors.blue;
    //     _dislikeiconColor = Colors.grey;
    //   });
    //   _checkStatus();
    // } else
    if (like == true) {
      if (likelst.contains(widget.uid) == true) {
        docref.updateData({
          'like': FieldValue.arrayRemove([widget.uid]),
          'likes': likes - 1,
        });
      }
      setState(() {
        likeno = likes;
        //dislikeno = dislikes;
        like = false;
        _likeiconColor = Colors.black;
      });
      _checkStatus();
    } else {
      docref.updateData({
        'like': FieldValue.arrayUnion([widget.uid]),
        'likes': likes + 1,
      });
      setState(() {
        likeno = likes;
        //dislikeno = dislikes;
        like = true;
        //dislike = false;
        _likeiconColor = Colors.blue;
        //_dislikeiconColor = Colors.grey;
      });
      _checkStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(AntDesign.like2, color: _likeiconColor),
                  onPressed: () {
                    if (widget.uid != null) {
                      likeclk();
                    } else {
                      Fluttertoast.showToast(
                        msg: "Please Login",
                        backgroundColor: Colors.red[400],
                        textColor: Colors.white,
                      );
                    }
                  },
                ),
                SizedBox(
                  width: 6,
                ),
                likeno != null ? Text(likeno.toString()) : Text("Loading.."),
                // IconButton(
                //   icon: Icon(
                //     Icons.thumb_down,
                //     color: _dislikeiconColor,
                //   ),
                //   onPressed: () {
                //     if (widget.uid != null) {
                //       dislikeclk();
                //     } else {
                //       Fluttertoast.showToast(
                //         msg: "Please Login",
                //         backgroundColor: Colors.red[400],
                //         textColor: Colors.white,
                //       );
                //     }
                //   },
                // ),
                // SizedBox(
                //   width: 6,
                // ),
                // Text(dislikeno.toString())
                SizedBox(
                  width: 40,
                ),
                IconButton(
                  icon: Icon(AntDesign.sharealt, color: Colors.black),
                  onPressed: share,
                ),
                SizedBox(
                  width: 40,
                ),
                Text(
                  "~10m ago",
                  style: GoogleFonts.firaCode(
                      fontSize: 11,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ]),

      // IconButton(
      //   icon: Icon(Icons.comment),
      //   onPressed: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) =>
      //                 CommentSection(docid: widget.docid)));
      //   },
      // ),
      // Spacer(),
    ]));
  }

  // dislikeclk() async {
  //   DocumentReference docref =
  //       Firestore.instance.collection("News").document(widget.docid);
  //   DocumentSnapshot doc = await docref.get();
  //   List dislikelst = doc.data['dislike'];
  //   List likelst = doc.data['like'];
  //   int likes = doc.data['likes'];
  //   int dislikes = doc.data['dislikes'];

  //   if (like == true) {
  //     if (likelst.contains(widget.uid) == true) {
  //       docref.updateData({
  //         'like': FieldValue.arrayRemove([widget.uid]),
  //         'dislike': FieldValue.arrayUnion([widget.uid]),
  //         'likes': likes - 1,
  //         'dislikes': dislikes + 1,
  //       });
  //       setState(() {
  //         likeno = likes;
  //         dislikeno = dislikes;
  //         dislike = true;
  //         like = false;
  //         _dislikeiconColor = Colors.blue;
  //         _likeiconColor = Colors.grey;
  //       });
  //       _checkStatus();
  //     }
  //   } else if (dislike == true) {
  //     if (dislikelst.contains(widget.uid) == true) {
  //       docref.updateData({
  //         'dislike': FieldValue.arrayRemove([widget.uid]),
  //         'dislikes': dislikes - 1,
  //       });
  //       setState(() {
  //         likeno = likes;
  //         dislikeno = dislikes;
  //         dislike = false;
  //         _dislikeiconColor = Colors.grey;
  //       });
  //       _checkStatus();
  //     }
  //   } else {
  //     docref.updateData({
  //       'dislike': FieldValue.arrayUnion([widget.uid]),
  //       'dislikes': dislikes + 1,
  //     });
  //     setState(() {
  //       likeno = likes;
  //       dislikeno = dislikes;
  //       dislike = true;
  //       like = false;
  //       _dislikeiconColor = Colors.blue;
  //       _likeiconColor = Colors.grey;
  //     });
  //     _checkStatus();
  //   }
  // }
}
