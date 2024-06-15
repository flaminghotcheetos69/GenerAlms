import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart'; // Assuming HomePage is defined in homepage.dart

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/GenerAlmsLogoTransparent.png'),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        // Add your "Forget Password" logic here
                      },
                      child: const Text('Forget Password'),
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: false,
                          onChanged: (bool? value) {
                            // Add your "Remember Me" logic here
                          },
                        ),
                        const SizedBox(width: 4.0),
                        const Text('Remember Me'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  try {
                    UserCredential userCredential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HomePage(user: userCredential.user!),
                      ),
                    );

                    print("User logged in: ${userCredential.user!.uid}");
                  } catch (e) {
                    print("Login Error: $e"); // Print error for debugging
                    // Optionally show a dialog or snackbar with the error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Login failed: $e"),
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  // Navigate to registration page or handle registration logic
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
