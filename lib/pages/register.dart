import 'package:chat/components/Square_tile.dart';
import 'package:chat/components/button.dart';
import 'package:chat/components/text_field.dart';
import 'package:chat/services/auth/auth_services.dart';
import 'package:chat/services/auth/google_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final confirmpassowrdcontroller = TextEditingController();
  final passwordController = TextEditingController();

  //sign up
  void signUp() async {
    if (passwordController.text != confirmpassowrdcontroller.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Passwords do not match'),
      ));
      return;
    }

    //get auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signUpwithEmailandPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            sliver: SliverToBoxAdapter(
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      //logo
                      const Icon(
                        Icons.lock,
                        size: 100,
                        color: Color.fromARGB(255, 35, 24, 56),
                      ),

                      const SizedBox(height: 25),

                      //Create acc
                      const Text(
                        "Let's create an account for you!",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
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

                      const SizedBox(height: 10),

                      //confirm pass
                      MyTextField(
                        controller: confirmpassowrdcontroller,
                        hintText: 'Confirm password',
                        obstext: true,
                      ),

                      const SizedBox(height: 25),

                      //button
                      Mybutton(
                        onTap: signUp,
                        text: 'Sign Up',
                      ),

                      const SizedBox(height: 25),

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
                      const SizedBox(height: 40),

                      //google sign in icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SquareTile(
                            imagepath: 'lib/images/google.png',
                            onTap: () => GoogleAuth().signinwithgoogle(),
                          ), //google icon
                        ],
                      ),

                      const SizedBox(height: 35),

                      //not a member
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already a member?'),
                          const SizedBox(
                            width: 4,
                          ),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              'Login now',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 87, 59, 146),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
