import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invenzine/services/crud.dart';

// class CommentSection extends StatefulWidget {
//   final String docid;

//   const CommentSection({Key key, this.docid}) : super(key: key);

//   @override
//   _CommentSectionState createState() => _CommentSectionState();
// }

// class _CommentSectionState extends State<CommentSection> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Comment'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//               child: PostList(
//             docid: widget.docid,
//           )),
//           // Container(
//           //     child: Padding(
//           //   padding: const EdgeInsets.all(8.0),
//           //   child: Comment(docid: widget.docid),
//           // ))
//         ],
//       ),
//     );
//   }
// }

class Comment extends StatefulWidget {
  final String docid;
  const Comment({Key key, this.docid}) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  String cmt;
  String uname;
  final controller = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Future<void> click(cmt) async {
    //widget.callback(controller.text);
    final FirebaseUser user = await auth.currentUser();
    if (user != null) {
      setState(() {
        uname = user.displayName.toString();
      });
    } else {
      Fluttertoast.showToast(
        msg: "Please Login",
        backgroundColor: Colors.red[400],
        textColor: Colors.white,
      );
    }
    CrudMethods crudMethods = new CrudMethods();
    if (user != null) {
      crudMethods.commentsAdd(widget.docid, cmt, uname);
      controller.clear();
    } else {
      Fluttertoast.showToast(
        msg: "Please Login",
        backgroundColor: Colors.red[400],
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: this.controller,
      onChanged: (item) {
        setState(() {
          cmt = item;
        });
      },
      decoration: InputDecoration(
        // filled: true,
        // fillColor: Colors.grey[200],
        border: InputBorder.none, //to remove the border below the text filed
        prefixIcon: Icon(FontAwesome.comment_o, color: Colors.black),
        labelText: 'Add a Comment',
        suffixIcon: IconButton(
          icon: Icon(FontAwesome.send_o, color: Colors.black),
          onPressed: () {
            this.click(cmt);
          },
        ),
      ),
    );
  }
}

class PostList extends StatefulWidget {
  final String docid;

  const PostList({Key key, this.docid}) : super(key: key);
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  Stream newsStream;
  CrudMethods crudMethods = new CrudMethods();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: newsStream != null
          ? StreamBuilder(
              stream: newsStream,
              builder: (context, snapshot) {
                if (snapshot.data == null) return CircularProgressIndicator();
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    QuerySnapshot snap = snapshot.data; // Snapshot
                    List<DocumentSnapshot> items =
                        snap.documents; // List of Documents
                    DocumentSnapshot item = items[index]; //Specific Document
                    return cmttile(
                        cmt: item.data['Comment'], uid: item.data['userName']);
                  },
                );
              },
            )
          : Center(
              child: Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  @override
  void initState() {
    crudMethods.getcommentsData(widget.docid).then((result) {
      setState(() {
        newsStream = result;
      });
    });
    super.initState();
  }
}

class cmttile extends StatelessWidget {
  final String cmt, uid;

  const cmttile({Key key, this.cmt, this.uid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          Row(children: <Widget>[
            Expanded(
              child: Container(
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: size.width * 0.013,
                            color: Colors.yellow,
                          ),
                          color: Colors.yellow,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.network(
                            'https://variety.com/wp-content/uploads/2015/07/naruto_movie-lionsgate.jpg',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        //radius: size.width * 0.070,
                      ),
                    ),
                    SizedBox(width: size.width * 0.04),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: Text(
                          uid,
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        )),
                        SizedBox(height: size.height * 0.01),
                        Container(
                            child: Text(
                          cmt,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                          ),
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ),
            // ListTile(
            //   title: Text(cmt),
            //   subtitle: Text(uid),
            // ))
          ]),
          Divider(),
        ],
      ),
    );
  }
}
