import 'package:chat/components/Square_tile.dart';
import 'package:chat/components/button.dart';
import 'package:chat/components/text_field.dart';
import 'package:chat/services/auth/auth_services.dart';
import 'package:chat/services/auth/google_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //sign in'
  void signIn() async {

    //show a circle loading
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
        ),
      ));
    }
    //stop showing it
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: Colors.grey.shade300,
  body: SafeArea(
    child: CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 60),

                //logo
                const Icon(
                  Icons.lock,
                  size: 100,
                  color: Color.fromARGB(255, 35, 24, 56),
                ),

                const SizedBox(height: 25),

                //welcome
                const Text(
                  "Welcome back you've been missed!",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                //email
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obstext: false,
                ),

                const SizedBox(height: 10),

                //password
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obstext: true,
                ),

                const SizedBox(height: 25),

                //button
                Mybutton(onTap: signIn, text: 'Sign In'),

                const SizedBox(height: 35),

                //or continue with
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey[400],
                        thickness: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),

        //google icon
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SquareTile(
                imagepath: 'lib/images/google.png',
                onTap: () => GoogleAuth().signInWithGoogle(),
              ), //google icon
            ],
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(height: 40,),
        ),
        
        //not a member?register 
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Not a member?'),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: widget.onTap,
                child: const Text(
                  'Register now',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 87, 59, 146),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ),
  ),
);


  }
}
