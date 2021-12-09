import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invenzine/pages/user_auth/sign_up/email_signup.dart';

class CrudMethods {
  Future<void> addData(newsData) async {
    Firestore.instance.collection("News").add(newsData).catchError((e) {
      print(e);
    });
  }

  Future<void> commentsAdd(docid, cmtdata, username) async {
    Firestore.instance
        .collection("News")
        .document(docid)
        .collection("Comments")
        .document()
        .setData({'Comment': cmtdata, 'userName': username}).catchError((e) {
      print(e);
    });
  }

  //Main page data retrival is done in smae screen

  fullviewdata(docid) async {
    return Firestore.instance
        .collection("News")
        .document(docid)
        .snapshots();
  }

  getsearchresult(tag) async {
    return await Firestore.instance
        .collection("News")
        .where("tags", arrayContains: tag)
        .snapshots();
  }

  getprofiledata(cname) async {
    return await Firestore.instance
        .collection("News")
        .where("adminname", isEqualTo: cname)
        .snapshots();
  }

  getpopularresult() async {
    return await Firestore.instance
        .collection("News")
        .where("likes", isGreaterThanOrEqualTo: 2)
        .snapshots();
  }

  getcommentsData(docid) async {
    // ignore: await_only_futures
    return await Firestore.instance
        .collection("News")
        .document(docid)
        .collection("Comments")
        .snapshots();
  }

  deleteData(docId) {
    Firestore.instance
        .collection("News")
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}
