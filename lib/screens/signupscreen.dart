import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'homescreen.dart';
import 'loginscree.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final firebaseAuth = FirebaseAuth.instance;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscureText = true;

   void signup() async {
    if (emailController.text.isEmpty && passwordController.text.isEmpty) {
      EasyLoading.showError('Email and password cannot be empty');
      return;
    }
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        EasyLoading.showError('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        EasyLoading.showError('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
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
          body:Container(
          decoration: const BoxDecoration(
            
            image: DecorationImage(
              
              image: AssetImage("assets/images/bg.webp",
              
              ),
              fit: BoxFit.fill
              //alignment: Alignment.bottomCenter,
             // opacity: 0.5,
            ),
          ),
          child:  Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                  const Text(
                    'Sign Up',
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
                      onPressed: signup,
                      child: const Text(
                        'Sign Up',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Login',
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