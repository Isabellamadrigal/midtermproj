import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

import 'homescreen.dart';
import 'signupscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final firebaseAuth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true;

  Future<void> login() async {
    if (emailController.text.isEmpty && passwordController.text.isEmpty) {
      EasyLoading.showError('Email and password cannot be empty');
      return;
    }
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        EasyLoading.showError('User not found.');
      } else if (e.code == 'wrong-password') {
        EasyLoading.showError('Wrong password.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeScreen(
            userId: snapshot.data!.uid,
          );
        }

        return Scaffold(
          body:  Container(
          decoration: const BoxDecoration(
            
            image: DecorationImage(
              
              image: AssetImage("assets/images/bg.webp",
              
              ),
              fit: BoxFit.fill
              //alignment: Alignment.bottomCenter,
             // opacity: 0.5,
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.025,
            horizontal: 12.0,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('TO DO',
                      style: GoogleFonts.archivoBlack(
                        fontSize: 46,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                       //const SizedBox(height: 12),
                   Text('"Reminds EveryThings"',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                  
                 
                 
                 
                  const SizedBox(height: 42),
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: emailController,
                    decoration:  InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      border:  OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all( RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)))
                      ),
                      onPressed: login,
                      child: const Text(
                        'Login',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          )
        );
      },
    );
  }
}