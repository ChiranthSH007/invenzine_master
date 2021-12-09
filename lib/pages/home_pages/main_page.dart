import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:invenzine/pages/home_pages/news_tile.dart';
import 'package:invenzine/pages/user_auth/auth.dart';
import 'package:invenzine/pages/user_auth/social.dart';
import 'package:invenzine/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Home Page Start

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

// Changed Scaffold sttings to false resizeToAvoidBottomPadding  -------->>>> IMportet
class _HomeState extends State<Home> {
  //CrudMethods crudMethods = new CrudMethods();
  //Stream newStream;
  //String imgUrl, title, description;
  FirebaseUser currentUser;
  Firestore firestore = Firestore.instance;
  List<DocumentSnapshot> products = []; // stores fetched products
  bool isLoading = false; // track if products fetching
  bool hasMore = true; // flag for more products available or not
  int documentLimit = 3; // documents to be fetched per request
  DocumentSnapshot
      lastDocument; // flag for last document from where next 10 records to be fetched
  ScrollController _scrollController = ScrollController();
  // listener for listview scrolling
  getpostdata() async {
    print("get pst data");
    if (!hasMore) {
      print('No More Products');
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await firestore
          .collection('News')
          .orderBy('date', descending: true)
          .limit(documentLimit)
          .getDocuments();
    } else {
      querySnapshot = await firestore
          .collection('News')
          .orderBy('date', descending: true)
          .startAfterDocument(lastDocument)
          .limit(documentLimit)
          .getDocuments();
      print(1);
    }
    if (querySnapshot.documents.length < documentLimit) {
      hasMore = false;
    }
    lastDocument = querySnapshot.documents[querySnapshot.documents.length - 1];
    products.addAll(querySnapshot.documents);
    setState(() {
      isLoading = false;
    });
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  // String _email() {
  //   if (currentUser != null) {
  //     return currentUser.email;
  //   } else {
  //     return null;
  //   }
  // }

  String _uid() {
    if (currentUser != null) {
      print(currentUser.uid);
      return currentUser.uid;
    } else {
      return null;
    }
  }

  // void _loadposts() async {
  //   await crudMethods.getData().then((result) {
  //     setState(() {
  //       newStream = result;
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _scrollController.addListener(scrollListener);
    getpostdata();
  }

  void scrollListener() {
    print("scrool controller");
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      getpostdata();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                ListView.builder(
                    physics: ScrollPhysics(),
                    itemCount: products.length,
                    shrinkWrap: true,
                    itemBuilder: (content, index) {
                      return NewsTile(
                          title: products[index]
                              .data['title'], //item.data['title'],
                          description: products[index]
                              .data['desc'], // item.data['desc'],
                          imgUrl: products[index]
                              .data['imgUrl'], //item.data['imgUrl'],
                          date: products[index]
                              .data['date'], // item.data['date'],
                          adminname:
                              products[index].data['adminname'].toString(),
                          ademail: products[index].data['aemail'],
                          //item.data['adminname'],
                          // likelist: item.data['like'],
                          // dislikelist: item.data['dislike'], will not work for getting list and passing it
                          uid: _uid(),
                          docuid:
                              products[index].documentID); //item.documentID);
                    }),
                isLoading
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(5),
                        color: Colors.yellowAccent,
                        child: Text(
                          'Loading',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Container()
              ],
            )),
      ),
    );
  }
}
// Home Page End

