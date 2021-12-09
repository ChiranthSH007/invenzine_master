import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invenzine/pages/home_pages/full_view.dart';
import 'package:invenzine/services/crud.dart';

class Search_result extends StatefulWidget {
  final String tag;

  const Search_result({Key key, this.tag}) : super(key: key);
  @override
  _Search_resultState createState() => _Search_resultState();
}

class _Search_resultState extends State<Search_result> {
  CrudMethods crudMethods = new CrudMethods();
  Stream newStream;
  FirebaseUser currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: SingleChildScrollView(
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
                              adminname: item.data['adminname'].toString(),
                              dislikeno: item.data['dislikes'],
                              uid: _uid(),
                              docuid: item.documentID,
                            );
                          });
                    }),
              )
            : Container(
                child: CircularProgressIndicator(),
              ),
      ),
    );
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

  @override
  void initState() {
    _loadCurrentUser();
    crudMethods.getsearchresult(widget.tag.toString()).then((result) {
      setState(() {
        newStream = result;
      });
    });
    super.initState();
  }
}

class Result_tile extends StatelessWidget {
  final String imgUrl, title, description, docuid, uid, adminname;
  final int likeno, dislikeno;
  final DateTime date;

  Result_tile({
    @required this.adminname,
    @required this.imgUrl,
    @required this.title,
    @required this.description,
    this.date,
    @required this.docuid,
    this.likeno,
    this.dislikeno,
    @required this.uid,
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Full_view(
                //dislikeno: dislikeno,
                docid: docuid,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: size.width * 0.35,
                  height: size.height * 0.13,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: imgUrl,
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  color: Colors.white,
                  width: size.width * 0.55,
                  height: size.height * 0.13,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          title,
                          maxLines: 2,
                          style: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(
                        height: 10,
                        color: Colors.blue,
                        thickness: 1.5,
                      ),
                      Container(
                        child: Text(
                          description,
                          maxLines: 1,
                          style: GoogleFonts.nunito(
                              fontSize: 10, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Row(
                          children: [
                            Text(
                              "Created by: ",
                              style: GoogleFonts.nunito(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              adminname,
                              style: GoogleFonts.nunito(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
        // ListTile(
        //   contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        //   leading: Container(
        //     padding: EdgeInsets.only(right: 12.0),
        //     decoration: new BoxDecoration(
        //         border: new Border(
        //             right: new BorderSide(width: 1.0, color: Colors.black))),
        //     child: Container(
        //       width: size.width * 0.2,
        //       height: size.height * 0.15,
        //       child: CachedNetworkImage(
        //         imageUrl: imgUrl,
        //         width: MediaQuery.of(context).size.height,
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //   ),
        //   title: Text(
        //     title,
        //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        //   ),
        //   // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        //   subtitle: Row(
        //     children: <Widget>[
        //       Flexible(
        //           child: Text(description,
        //               overflow: TextOverflow.ellipsis,
        //               style: TextStyle(color: Colors.black))),
        //     ],
        //   ),
        // ),
        );
  }
}
