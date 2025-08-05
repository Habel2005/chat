import 'dart:async';

import 'package:chat/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier{

  //get auth instance and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late String chatroomid;
  
  //Send Message
  Future<void> sendMessage(String reciever,String message) async
  {
     //get current user data
     final String currentUserId = _firebaseAuth.currentUser!.uid;
     final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
     final Timestamp timestamp = Timestamp.now();
     
     //create a new mssg
     Message newMessage = Message(
      senderId: currentUserId,
       senderEmail: currentUserEmail,
        receiverId: reciever,
         message: message,
          timestamp: timestamp);

     //create a chat room id from current userID and receiver
     //(sorted to ensure uniquences)
     List<String> ids = [currentUserId , reciever];
     ids.sort();   //sort the ids(ensure two users are using same room)
     String chatRoomId =ids.join("_");//combine ids with _
     chatroomid=chatRoomId;


     //add new mssg to database
     await _firebaseFirestore.collection("chatrooms").doc(chatRoomId)
     .collection('messages').add(newMessage.toMap());

  }


  //Get Message
Future<Stream<QuerySnapshot<Object?>>> getMessages(String userId, String otherUserId) async {
  List<String> ids = [userId, otherUserId];
  ids.sort();
  String chatRoomId = ids.join("_");

  // Update the last seen timestamp when the stream is first created
  await updateLastSeen();

  // Create a stream for the chat room messages
  Stream<QuerySnapshot<Object?>> messageStream = _firebaseFirestore
      .collection('chatrooms')
      .doc(chatRoomId)
      .collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots();

  // Listen to the message stream and update the last seen timestamp whenever a new message is received
  StreamSubscription messageSubscription = messageStream.listen((snapshot) {
    updateLastSeen();
  });

  // Return the message stream and ensure the subscription is canceled when the stream is closed
  return messageStream.handleError((error) {
    messageSubscription.cancel();
  });
}

Future<void> updateLastSeen() async {
    await _firebaseFirestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .set({'lastSeen': Timestamp.now()}, SetOptions(merge: true));
  }
    

  Stream<int> getMessageCountStream(String userId, String otherUserId) {
  List<String> ids = [userId, otherUserId];
  ids.sort();
  String chatRoomId = ids.join("_");

  return _firebaseFirestore
      .collection('chatrooms')
      .doc(chatRoomId)
      .collection('messages')
      .where('senderId', isNotEqualTo: otherUserId) // Filter out messages sent by the current user
      .where('timestamp', isGreaterThan: Timestamp.now()) // Only count new messages
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
}
}