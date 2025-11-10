import 'package:aerobasket/homepage.dart';
import 'package:aerobasket/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
          Center(child: Image.asset('assets/logo.png',width: 300,height: 151,)),
          const Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text("Create an Account",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,),),
          ),
          Padding(
            padding: const EdgeInsets.only(left:30, right: 50,top: 30),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  hintText: "Enter your Name"
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:30, right: 50,top: 30),
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
            padding: const EdgeInsets.only(left:30, right: 50,top: 30),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Phone Number",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  hintText: "Enter your Phone Number"
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:30, right: 50,top: 30),
            child: TextField(
              obscureText: passwordVisible,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                hintText: "Enter your Password",
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
                hintText: "Please Confirm your Password",
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
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Homepage()),
                  );
                },
                child:Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: const Color(0xFFEC441E))
                  ),
                  child: const Center(child: Text("Sign up",style: TextStyle(fontSize: 20, color: Color(0xFFEC441E),fontWeight: FontWeight.w600),)),
                ),
              ),
            ),
          ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                height: 95,
                width: 700,
                decoration: const BoxDecoration(
                    color: Color(0xFFFC774B),
                ),
                child: CupertinoButton(
                  child: const Text('Already Registered Sign in?',style: TextStyle(color: Colors.black, decoration: TextDecoration.underline,fontWeight: FontWeight.w600),),
                  onPressed: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder :(context) => const Login())
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
