import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddUser extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid='';
  Future<String> addContacts(String email, String name) async {
    try {
    QuerySnapshot querySnapshot =
        await _firestore.collection('users').get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      // Access the 'email' field from each document
      String email0 = doc['email'];
      if(email == email0)
      {
        uid=doc.id;
      }
    }
    print('uid: $uid');
    if(uid != ''){//check if uid is not empty
      //put email and name ,uid to databse
      await _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid).collection('contacts').doc(email)
      .set({
        'email': email,
        'name': name,
        'uid': uid,
      });

      return uid;
      
      }
      return ''; // Operation unsuccessful
    } 
    
    catch (e) 
    {
      print('Error adding contact: $e');
      return ''; // Operation failed
    }
  }
}