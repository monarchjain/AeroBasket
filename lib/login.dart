import 'dart:convert';
import 'package:aerobasket/forgotpassword.dart';
import 'package:aerobasket/homepage.dart';
import 'package:aerobasket/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'config/api_config.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthController authController = Get.put(AuthController());

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;
  bool isLoading = false;

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
        child: Form(
          key: globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/logo.png', width: 300, height: 151,)),
              const Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text("Login", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text("Welcome Back to the app", style: TextStyle(color: Colors.grey),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 50, top: 20),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    hintText: "Enter your Email",
                    prefixIcon: const Icon(Icons.mail_outline_outlined),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 50, top: 30),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 190),
                child: CupertinoButton(
                  child: const Text('FORGOT PASSWORD ?', style: TextStyle(color: Color(0xFFEC441E), fontWeight: FontWeight.w600),),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => const ForgotPassword())
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: InkWell(
                    onTap: isLoading ? null : sendPostRequest,
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: const Color(0xFFEC441E))
                      ),
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFEC441E)),
                        )
                            : const Text("Login", style: TextStyle(fontSize: 20, color: Color(0xFFEC441E), fontWeight: FontWeight.w600),),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 140),
                child: Container(
                  height: 95,
                  width: 800,
                  decoration: const BoxDecoration(color: Color(0xFFF88863)),
                  child: CupertinoButton(
                    child: const Text('SIGN UP', style: TextStyle(color: Colors.black, decoration: TextDecoration.underline, fontWeight: FontWeight.w600),),
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => const SignUp())
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendPostRequest() async {
    if (!globalKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        authController.setUserData(
          token: data['token'],
          id: data['user']['id'],
          name: data['user']['name'],
          email: data['user']['email'],
          phone: data['user']['phone'],
        );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Homepage()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Login failed')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not connect to server. Is the backend running?')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}