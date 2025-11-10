import 'package:aerobasket/login.dart';
import 'package:aerobasket/otppage.dart';
import 'package:aerobasket/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OtpPage()),
                );
              },
              child: Center(
                child: Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: const Color(0xFFEC441E))
                  ),
                  child: const Center(child: Text("Send OTP",style: TextStyle(fontSize: 20, color: Color(0xFFEC441E),fontWeight: FontWeight.w600),)),
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