import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:invenzine/pages/home_pages/author_page.dart';
import 'package:invenzine/pages/home_pages/full_view.dart';

// ignore: must_be_immutable
class NewsTile extends StatefulWidget {
  final String imgUrl, title, description, docuid, uid, adminname, ademail;
  final Timestamp date;

  NewsTile({
    @required this.adminname,
    @required this.ademail,
    @required this.imgUrl,
    @required this.title,
    @required this.description,
    @required this.uid,
    @required this.date,
    @required this.docuid,
  });
  @override
  _NewsTileState createState() => _NewsTileState();
}

class _NewsTileState extends State<NewsTile> {
  bool like;
  // bool dislike;
  int likeno;
  String share_link;
  DateTime created_time, today_time;
  Duration diff_time;
  int in_time;
  //int dislikeno;
  List<String> likelist = new List<String>();
  //List<String> dislikelist = new List<String>();
  Color _likeiconColor = Colors.black;
  //Color _dislikeiconColor = Colors.grey;

  _checkStatus() async {
    // print(widget.date);
    // setState(() {
    //   created_time = widget.date;
    // });
    DocumentReference docref =
        Firestore.instance.collection("News").document(widget.docuid);
    DocumentSnapshot doc = await docref.get();
    //Timestamp createdate = doc.data['date'];
    List likelst = doc.data['like'];
    int likes = doc.data['likes'];
    setState(() {
      likelist = List.from(likelst);
      likeno = likes;
      created_time = widget.date.toDate();
      today_time = DateTime.now();
      diff_time = today_time.difference(created_time);
      if (diff_time.inDays >= 1) {
        in_time = diff_time.inDays;
      } else if (diff_time.inHours >= 1) {
        in_time = diff_time.inHours;
      } else if (diff_time.inMinutes >= 1) {
        in_time = diff_time.inMinutes;
      }
      print(in_time);
      print(diff_time);
      print(today_time);
      print(created_time);
    });
    // List dislikelst = doc.data['dislike'];
    // int dislikes = doc.data['dislikes'];
    // setState(() {
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
    } // else if (dislike == true) {
    //setState(() {
    //  _dislikeiconColor = Colors.blue;
    //  dislike = true;
    //});
    //}
    await createFirstPostLink(widget.docuid);
  }

  @override
  void initState() {
    _checkStatus();
    super.initState();
  }

  // ignore: non_constant_identifier_names
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        margin: EdgeInsets.all(8),
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => Full_view(
                          // imgurl: widget.imgUrl,
                          // title: widget.title,
                          // desc: widget.description,
                          // likeno: likeno,
                          // uid: widget.uid,
                          //dislikeno: dislikeno,
                          docid: widget.docuid)));
            },
            child: //likeno != null || dislikeno != null
                Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: Image(
                          image: AssetImage("assets/img/defaultimage.png"),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      imageUrl: widget.imgUrl,
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: size.height * 0.010),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.title,
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: created_time != null
                        ? Text(
                            DateFormat('yyyy-MM-dd–kk:mm').format(created_time),
                            style: GoogleFonts.firaCode(
                                fontSize: 10,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          )
                        : Text("Loading..."),
                  ),
                  // SizedBox(height: 4),
                  // Text(widget.description,
                  //     maxLines: 2,
                  //     style: TextStyle(
                  //         color: Colors.black54,
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w500)),
                  Row(children: <Widget>[
                    IconButton(
                      icon: Icon(
                        AntDesign.like2,
                        color: _likeiconColor,
                      ),
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
                    likeno != null
                        ? Text(likeno.toString())
                        : Text("Loading.."),
                    Spacer(),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                        children: <TextSpan>[
                          TextSpan(
                            text: widget.adminname,
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
                                              ademail: widget.ademail,
                                              adminname:
                                                  widget.adminname.toString(),
                                            )));
                              },
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(AntDesign.sharealt, color: Colors.black),
                      onPressed: share,
                    )
                  ])
                ],
              ),
            )));
  }

  likeclk() async {
    DocumentReference docref =
        Firestore.instance.collection("News").document(widget.docuid);
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
    //       //'dislikes': dislikes - 1,
    //     });
    //   }
    //   setState(() {
    //     likeno = likes;
    //     //dislikeno = dislikes;
    //     like = true;
    //     //dislike = false;
    //     _likeiconColor = Colors.blue;
    //     //_dislikeiconColor = Colors.grey;
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
}
  // dislikeclk() async {
  //   DocumentReference docref =
  //       Firestore.instance.collection("News").document(widget.docuid);
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



// ignore: camel_case_types
// class clickabletext extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     TextStyle defaultStyle = TextStyle(
//         color: Colors.black,
//         fontSize: MediaQuery.of(context).size.width * 0.05);
//     TextStyle linkStyle = TextStyle(
//       color: Colors.black,
//     );
//     return RichText(
//       text: TextSpan(
//         style: defaultStyle,
//         children: <TextSpan>[
//           TextSpan(
//               text: 'Create an Account',
//               style: linkStyle,
//               recognizer: TapGestureRecognizer()
//                 ..onTap = () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (_) => Author_page()));
//                 }),
//         ],
//       ),
//     );
//   }
// }
