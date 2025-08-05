import 'package:flutter/material.dart';
import 'package:chat/services/chat/adduser.dart';

class SaveUser extends StatefulWidget {
  const SaveUser({super.key});

  @override
  State<SaveUser> createState() => _SaveUserState();
}

TextEditingController _email = TextEditingController();
TextEditingController _name = TextEditingController();
late String uid;

class _SaveUserState extends State<SaveUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + 50),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Text(
              'New Contact',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Arial',
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 20), // Adjust vertical spacing here
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person,
                        color: Color.fromARGB(255, 172, 172, 172)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter name',
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 242, 242, 242)),
                        controller: _name,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.email,
                        color: Color.fromARGB(255, 172, 172, 172)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter email',
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        controller: _email,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async { 


                      AddUser addUser = AddUser();

                      uid = await addUser.addContacts(_email.text, _name.text);
                      if (uid != '')
                      {
                        Navigator.pop(context); // Navigate back if successful
                        _email.clear();
                        _name.clear();
                      } 
                      
                      else {
                        // Print error or show error message to user
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Failed to add contact. Please try again.'),
                          ),
                        );
                      }


                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Add'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
