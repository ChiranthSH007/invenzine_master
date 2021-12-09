import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invenzine/pages/home_pages/full_view.dart';
import 'package:invenzine/pages/home_pages/searchresult.dart';
import 'package:invenzine/services/crud.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  CrudMethods crudMethods = new CrudMethods();
  Stream newStream;
  FirebaseUser currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: InputBorder
                          .none, //to remove the border below the text filed
                      icon: new Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.keyboard_arrow_right_outlined),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Search_result(
                                      tag: _typeAheadController.text)));
                        },
                      ),
                    ),
                    controller: this._typeAheadController,
                  ),
                  suggestionsCallback: (pattern) async {
                    return await StateService.getSuggestions(pattern);
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Search_result(tag: suggestion),
                          ),
                        );
                      },
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    this._typeAheadController.text = suggestion;
                  },
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Divider(
                color: Colors.black,
                thickness: 4,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 8, 0, 8),
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text(
                    "Popular Posts",
                    style: GoogleFonts.oswald(
                        fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                ),
                SingleChildScrollView(
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
                                      QuerySnapshot snap =
                                          snapshot.data; // Snapshot
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
                                        uid: _uid(),
                                        docuid: item.documentID,
                                        adminname:
                                            item.data['adminname'].toString(),
                                      );
                                    });
                              }),
                        )
                      : Container(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return Expanded(
      child: Divider(
        color: Color(0xFFD9D9D9),
        thickness: 0.5,
        height: 2,
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

  String _uid() {
    if (currentUser != null) {
      print(currentUser.uid);
      return currentUser.uid;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    _loadCurrentUser();
    crudMethods.getpopularresult().then((result) {
      setState(() {
        newStream = result;
      });
    });
    super.initState();
  }
}

class StateService {
  // ignore: deprecated_member_use
  static List<dynamic> tags = new List<dynamic>();

  static getSuggestions(String query) async {
    DocumentReference docref =
        Firestore.instance.collection("Tags").document("newstag");
    DocumentSnapshot doc = await docref.get();
    tags = doc.data['tags'];
    List<dynamic> matches = List();
    matches.addAll(tags);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches.toList();
  }
}
