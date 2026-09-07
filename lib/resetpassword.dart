import 'dart:convert';
import 'package:aerobasket/login.dart';
import 'package:aerobasket/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config/api_config.dart';

class ResetPassword extends StatefulWidget {
  final String resetToken;
  const ResetPassword({super.key, required this.resetToken});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool passwordVisible=false;
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    passwordVisible=true;
  }

  Future<void> resetPassword() async {
    if (!globalKey.currentState!.validate()) {
      return;
    }

    setState(() { isLoading = true; });

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "resetToken": widget.resetToken,
          "newPassword": passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password reset successful. Please log in.")),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
                (route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Could not reset password, please start again')),
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
        child: Form(
          key: globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/logo.png',width: 600,height: 151,)),
              const Padding(
                padding: EdgeInsets.only(left: 20,top: 50),
                child: Text("Reset Password",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30,top: 10),
                child: Text("Enter your new password twice \n below to reset a new password",style: TextStyle(color: Colors.grey),),
              ),
              Padding(
                padding: const EdgeInsets.only(left:30, right: 50,top: 30),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    hintText: "Enter your New Password",
                    suffixIcon: IconButton(icon: Icon(passwordVisible?Icons.visibility : Icons.visibility_off),
                      onPressed: (){
                        setState(() { passwordVisible = !passwordVisible; });
                      },
                    ),
                    alignLabelWithHint: false,
                    filled: true,
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter a new password';
                    if (value.length < 8) return 'Password must be at least 8 characters long';
                    if (!value.contains(RegExp(r'[A-Z]'))) return 'Must contain at least one uppercase letter';
                    if (!value.contains(RegExp(r'[a-z]'))) return 'Must contain at least one lowercase letter';
                    if (!value.contains(RegExp(r'[0-9]'))) return 'Must contain at least one digit';
                    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return 'Must contain at least one special character';
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:30, right: 50,top: 30),
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    hintText: "Re-enter your New Password",
                    suffixIcon: IconButton(icon: Icon(passwordVisible?Icons.visibility : Icons.visibility_off),
                      onPressed: (){
                        setState(() { passwordVisible = !passwordVisible; });
                      },
                    ),
                    alignLabelWithHint: false,
                    filled: true,
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please confirm your password';
                    if (value != passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(
                  child: InkWell(
                    onTap: isLoading ? null : resetPassword,
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
                            : const Text("Reset Password",style: TextStyle(fontSize: 20, color: Color(0xFFEC441E),fontWeight: FontWeight.w600),),
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
                padding: const EdgeInsets.only(top: 80),
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
      ),
    );
  }
}