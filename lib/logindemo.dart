import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:aerobasket/forgotpassword.dart';
import 'package:aerobasket/homepage.dart';
import 'package:aerobasket/signup.dart';

class LoginDemo extends StatefulWidget {
  const LoginDemo({super.key});

  @override
  State<LoginDemo> createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool passwordVisible = false;

  final String apiUrl = 'http://localhost:3000/user/login'; // Replace with your actual login endpoint

  // Function to call login endpoint
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/logo.png',
                width: 300,
                height: 151,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Login",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Welcome Back to the app",
                style: TextStyle(color: Colors.grey),
              ),
            ),

            // Email Field
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 50, top: 20),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Enter your Email",
                  prefixIcon: const Icon(Icons.mail_outline_outlined),
                ),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@') || !value.contains('.')) {
                    return 'Please enter a valid email address';
                  }
                  return null; // Return null if the validation is successful
                },
              ),
            ),

            // Password Field
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 50, top: 30),
              child: TextFormField(
                obscureText: passwordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Enter your Password",
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  alignLabelWithHint: false,
                  filled: true,
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  // Add more password validation rules if needed
                  return null; // Return null if the validation is successful
                },
              ),
            ),

            // Forgot Password Button
            Padding(
              padding: const EdgeInsets.only(left: 190),
              child: CupertinoButton(
                child: const Text(
                  'FORGOT PASSWORD ?',
                  style: TextStyle(color: Color(0xFFEC441E), fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const ForgotPassword()),
                  );
                },
              ),
            ),

            // Login Button
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                child: InkWell(
                  onTap: () async {
                    if (globalKey.currentState!.validate()) {
                      // If form validation is successful, call login function
                      final email = ''; // Get email from TextFormField controller
                      final password = ''; // Get password from TextFormField controller
                      try {
                        await loginUser(email, password);
                        // Handle successful login
                        // Navigate to home page or perform any other actions
                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Homepage()),
                        );
                      } catch (e) {
                        // Handle login failure
                      }
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: const Color(0xFFEC441E))),
                    child: const Center(
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 20, color: Color(0xFFEC441E), fontWeight: FontWeight.w600),
                        )),
                  ),
                ),
              ),
            ),

            // Sign Up Button
            Padding(
              padding: const EdgeInsets.only(top: 140),
              child: Container(
                height: 95,
                width: 800,
                decoration: const BoxDecoration(color: Color(0xFFF88863)),
                child: CupertinoButton(
                  child: const Text(
                    'SIGN UP',
                    style: TextStyle(color: Colors.black, decoration: TextDecoration.underline, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => const SignUp()),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
