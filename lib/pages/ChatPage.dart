import 'dart:async';

import 'package:chat/components/chat_bubble.dart';
import 'package:chat/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {
  final String useremail;
  final String recieveID;
  final String name;
  const ChatPage(
      {super.key,
      required this.useremail,
      required this.recieveID,
      required this.name});

  @override
  State<ChatPage> createState() => _ChatPageState();
  
}

class _ChatPageState extends State<ChatPage> {
  late Timer _updateLastSeenTimer;

  @override
  void initState() {
    super.initState();
    _updateLastSeen(); // Update lastSeen when the chat page is opened
    _updateLastSeenTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateLastSeen();
    });
  }

  @override
  void dispose() {
    _updateLastSeenTimer.cancel();
    super.dispose();
  }

  Future<void> _updateLastSeen() async {
    await _chatService.updateLastSeen();
  }
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) //send only if not empty
    {
      await _chatService.sendMessage(widget.recieveID, _messageController.text);
      //clear message after send
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 30, 45), //background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              color: const Color.fromARGB(255, 34, 71, 102), //header
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 185, 184, 189),
                    size: 35,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    widget.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildMessageList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildMessageInput(),
            ),
          ],
        ),
      ),
    );
  }

// Message list
  Widget _buildMessageList() {
    return FutureBuilder<Stream<QuerySnapshot>>(
      future: _chatService.getMessages(
          widget.recieveID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }
        return StreamBuilder(
          stream: snapshot.data,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading..');
            }
            return ListView(
              children: (snapshot.data!)
                  .docs
                  .map((document) => _buildMessageItem(document))
                  .toList(),
            );
          },
        );
      },
    );
  }

  //message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //align the messages to right if the sender == current user
    //else put it in left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    bool color =
        (data['senderId'] == _firebaseAuth.currentUser!.uid) ? true : false;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Chatbubble(
            message: data['message'],
            color: color,
            align: alignment,
          ),
        ],
      ),
    );
  }

  //message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Container(
        width: double.infinity, // Adjust the width to fit the screen
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16), // Adjust left padding
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            IconButton(
              iconSize: 30, // Adjust icon size
              padding:
                  const EdgeInsets.all(8), // Adjust padding around the icon
              icon: const Icon(Icons.send, color: Colors.blueAccent),
              onPressed: () {
                sendMessage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
