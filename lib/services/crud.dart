import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudMethods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  getAdmin() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var userDocument =
        await Firestore.instance.collection('user').document(user.uid).get();
    bool _myAdmin = userDocument["admin"];
    print(_myAdmin);
  }

  getProfile() async {
    return Firestore.instance.collection('profile').snapshots();
  }

  getDataFromUserFromDocument() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return await Firestore.instance.collection('user').document(user.uid).get();
  }

  getDataFromUserFromDocumentWithID(userID) async {
    return await Firestore.instance.collection('user').document(userID).get();
  }

  getDataFromUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return Firestore.instance.collection('user').document(user.uid).snapshots();
  }

  createOrUpdateUserData(Map<String, dynamic> userDataMap) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
//    print('USERID ' + user.uid);
    DocumentReference ref =
        Firestore.instance.collection('user').document(user.uid);
    return ref.setData(userDataMap, merge: true);
  }

   createReservation(Map<String, dynamic> userDataMap) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
//    print('USERID ' + user.uid);
    DocumentReference ref = Firestore.instance
        .collection('user')
        .document(user.uid)
        .collection('reservations')
        .document();
    return ref.setData(userDataMap, merge: true);
  }

  createProfReservation(Map<String, dynamic> userDataMap,String docId) async {
    DocumentReference ref = Firestore.instance
        .collection('professions')
        .document(docId)
        .collection('reservations')
        .document();
    return ref.setData(userDataMap, merge: true);
  }

  getDataFromProfFromDocumentWithID(clubID) async {
    return await Firestore.instance
        .collection('professions')
        .document(clubID)
        .get();
  }
  deleteResData(docId) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection('user')
        .document(user.uid)
        .collection('reservations')
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  getAllProfData() {
    return Firestore.instance.collection('professions').snapshots();
  }

  getDeveloperData() async {
    return await Firestore.instance
        .collection('res')
        .document('developerdetails')
        .get();
  }

  Future<void> createService(Map<String, dynamic> jobDataMap) async {
   Firestore.instance.collection('services').add(jobDataMap).catchError((e) {
        print(e);
      });
  }
}
