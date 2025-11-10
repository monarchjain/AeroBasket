import 'package:aerobasket/login.dart';
import 'package:aerobasket/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool passwordVisible=false;
  @override
  void initState(){
    super.initState();
    passwordVisible=true;
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
              child: TextField(
                obscureText: passwordVisible,
                decoration: InputDecoration(
                  labelText: "New Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  hintText: "Enter your New Password",
                  suffixIcon: IconButton(icon: Icon(passwordVisible?Icons.visibility : Icons.visibility_off),
                    onPressed: (){
                      setState(
                            () {
                          passwordVisible = !passwordVisible;
                        },
                      );
                    },
                  ),
                  alignLabelWithHint: false,
                  filled: true,
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:30, right: 50,top: 30),
              child: TextField(
                obscureText: passwordVisible,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  hintText: "Re-enter your New Password",
                  suffixIcon: IconButton(icon: Icon(passwordVisible?Icons.visibility : Icons.visibility_off),
                    onPressed: (){
                      setState(
                            () {
                          passwordVisible = !passwordVisible;
                        },
                      );
                    },
                  ),
                  alignLabelWithHint: false,
                  filled: true,
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
              ),
            ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(
                    child: Container(
                      height: 40,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: const Color(0xFFEC441E))
                      ),
                      child: const Center(child: Text("Reset Password",style: TextStyle(fontSize: 20, color: Color(0xFFEC441E),fontWeight: FontWeight.w600),)),
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
    );
  }
}