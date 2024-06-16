import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:generalms/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:generalms/screens/settings.dart';
import 'homepage.dart';
import 'registration.dart';
import 'adminHP.dart'; // Import your admin home page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GenerAlms',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFD33333),
          secondary: Color(0xFFF63B3B),
          background: Color(0xFFE8E8E8),
          surface: Color(0xFFFFFFFF),
          onBackground: Color(0xFF000000),
          onSurface: Color(0xFF000000),
          onError: Colors.black,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          error: Colors.red,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  String? _errorMessage;

  Future<String?> getUserType(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
    return userData?['userType'] as String?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/GenerAlmsLogoTransparent.png'),
                const SizedBox(height: 24.0),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 8.0),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 8.0),
                Row(
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
                          value: _rememberMe,
                          onChanged: (bool? value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                        const Text('Remember Me'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );

                      String? userType = await getUserType(userCredential.user!.uid);
                      if (userType == 'Admin') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => AdminDBScreen()), // Using AdminDashboardPage
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage(user: userCredential.user!)),
                        );
                      }

                      print("User logged in: ${userCredential.user!.uid}");
                    } catch (e) {
                      setState(() {
                        _errorMessage = "Invalid credentials. Please try again.";
                      });
                      print("Error: $e");
                    }
                  },
                  child: const Text('Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD33333),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    textStyle: const TextStyle(fontSize: 16.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegistrationPage()),
                    );
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
