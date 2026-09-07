import 'dart:convert';
import 'package:aerobasket/login.dart';
import 'package:aerobasket/otppage.dart';
import 'package:aerobasket/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config/api_config.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Future<void> sendOtp() async {
    if (emailController.text.trim().isEmpty || !emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email address")),
      );
      return;
    }

    setState(() { isLoading = true; });

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": emailController.text.trim()}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // TEMPORARY: showing the OTP directly since real email isn't wired
        // up yet. Remove this dialog once that's added.
        if (data['otp'] != null && mounted) {
          await showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: const Text("Dev Mode: Your OTP"),
              content: Text("Email sending isn't set up yet, so here's your OTP:\n\n${data['otp']}"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OtpPage(email: emailController.text.trim())),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Something went wrong')),
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
        setState(() { isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset('assets/logo.png',width: 300,height: 151,)),
            const Padding(
              padding: EdgeInsets.only(top: 70,left: 20),
              child: Text("Forgot Password?",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text("Enter your Email Address to get \n the password reset link",style: TextStyle(color: Colors.grey),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30,right: 50,top: 40),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  hintText: "Enter your Email",
                  prefixIcon: const Icon(Icons.mail_outline_outlined),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child:InkWell(
                onTap: isLoading ? null : sendOtp,
                child: Center(
                  child: Container(
                    height: 40,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: const Color(0xFFEC441E))
                    ),
                    child: Center(
                      child: isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFEC441E)))
                          : const Text("Send OTP",style: TextStyle(fontSize: 20, color: Color(0xFFEC441E),fontWeight: FontWeight.w600),),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: CupertinoButton(
                child: const Text('Back to login',style: TextStyle(color: Color(0xFFEC441E),fontWeight: FontWeight.w600),),
                onPressed: (){
                  Navigator.push(
                      context,
                      CupertinoPageRoute(builder :(context) => const Login())
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 160),
              child: Center(
                child: CupertinoButton(
                  child: const Text('Create an account',style: TextStyle(color: Color(0xFFEC441E),fontWeight: FontWeight.bold),),
                  onPressed: (){
                    Navigator.push(
                        context,
                        CupertinoPageRoute(builder :(context) => const SignUp())
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