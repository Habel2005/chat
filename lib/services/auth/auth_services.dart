
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier
{
  final FirebaseAuth _firebaseAuth =FirebaseAuth.instance; //auth instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; //firestore instance


  //sign in
  Future<UserCredential> signInWithEmailPassword(String email,String password) async
  {
    try{
      //sign in
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password);

        //after sign in create a doc for user
         _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
        }, SetOptions(merge: true));
        
        return userCredential;
    } 
    //error
    on FirebaseAuthException catch(e)
    {
      throw Exception(e.code);
    }

  }

  //sign out
  Future<void> SignOut() async
  {
    return await FirebaseAuth.instance.signOut();
  }
  

  //new user
  Future<UserCredential> signUpwithEmailandPassword(String email,String password) async
  {
    try{
      
      UserCredential user =await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

        //after creating ser,create a document for user in user collection
        _firestore.collection('users').doc(user.user!.uid).set({
          'uid': user.user!.uid,
          'email': email,
        });


      return user;
    } 
    on FirebaseAuthException catch(e)
    {
      throw Exception(e.code);

    }
  }
}