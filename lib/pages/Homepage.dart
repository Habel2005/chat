import 'dart:async';

import 'package:chat/pages/ChatPage.dart';
import 'package:chat/pages/SaveUser.dart';
import 'package:chat/services/auth/auth_services.dart';
import 'package:chat/services/chat/chat_service.dart';
import 'package:chat/services/chat/round_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MessageCountProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final String _userId;
  final String _otherUserId;

  int _messageCount = 0;
  int get messageCount => _messageCount;

  late StreamSubscription _subscription;

  MessageCountProvider(this._userId, this._otherUserId) {
    _setupMessageCountListener();
  }

  void _setupMessageCountListener() {
    _subscription = _chatService
        .getMessageCountStream(_userId, _otherUserId)
        .listen((count) {
      _messageCount = count;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirebaseAuth _auth = FirebaseAuth.instance; //auth instance
  final TextEditingController _searchController = TextEditingController();
  ChatService chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 60,left: 16,right: 16),
            sliver: SliverAppBar(
              pinned: true,
              backgroundColor: Colors.black,
              title: const Text(
                'Messaging',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: 'Avenir',
                  letterSpacing: 1.3,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    signOut();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 162, 162, 162),
                        width: 3.0,
                      ),
                    ),
                    child: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            sliver: SliverToBoxAdapter(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Find messages',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          _buildUserSliverList(),
        ],
      ),
      floatingActionButton: Container(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SaveUser(),
              ),
            );
          },
          backgroundColor: const Color.fromARGB(255, 173, 157, 209),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60.0),
          ),
          child: const Icon(Icons.person_add_alt_1,size: 30,),
        ),
      ),
    );
  }

  //sign out func
  void signOut() {
    //get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.SignOut();
  }

  //user list of users except for current logged in one
  Widget _buildUserSliverList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('contacts')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Text(
                'ERROR',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Text(
                'Loading..',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Text(
                'It\'s pretty empty here..',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final DocumentSnapshot doc = snapshot.data!.docs[index];
              return FutureBuilder<Widget>(
                future: _buildUserListItem(doc),
                builder:
                    (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Show loading indicator
                  } else if (snapshot.hasError) {
                    return Text(
                        'Error: ${snapshot.error}'); // Show error message
                  } else {
                    return snapshot
                        .data!; // Return the widget built by _buildUserListItem
                  }
                },
              );
            },
            childCount: snapshot.data!.docs.length,
          ),
        );
      },
    );
  }

  //build indivitual user list items
  Future<Widget> _buildUserListItem(DocumentSnapshot document) async {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // Get the name from the Firestore document
    String name = (await FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('contacts')
            .where('email', isEqualTo: data['email'])
            .limit(1)
            .get())
        .docs
        .first
        .data()['name'];
    // Display all saved users
    return ChangeNotifierProvider(
        create: (_) =>
            MessageCountProvider(data['uid'], _auth.currentUser!.uid),
        child: ListTile(
          title: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3), // Shadow color
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(
                            0, 3), // Changes the position of the shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 209, 209, 209),
                        child: Icon(Icons.person),
                      ),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: Text(
                          name, //displying name of user on list
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Consumer<MessageCountProvider>(
                        builder: (context, provider, child) {
                          if (provider.messageCount > 0) {
                            return RoundedMessageIcon(
                                messageCount: provider.messageCount);
                          } else {
                            return const SizedBox
                                .shrink(); // Or any other widget you want to show when messageCount is 0
                          }
                        },
                      ),

                      // Display arrow icon
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          onTap: () async {
            // Pass the clicked user's UID to the chat page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  useremail: data['email'],
                  recieveID: data['uid'],
                  name: name,
                ),
              ),
            );
          },
        ));
  }
}
