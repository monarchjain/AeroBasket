
import 'package:aerobasket/forgotpassword.dart';
import 'package:aerobasket/homepage.dart';
import 'package:aerobasket/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> globalKey =  GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
        title: const Text(""),
      ),
      body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Image.asset('assets/logo.png',width: 300,height: 151,)),
          const Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text("Login",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text("Welcome Back to the app",style: TextStyle(color: Colors.grey),),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 30, right: 50, top: 20),
            child: TextFormField(
              controller: emailController,
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
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 50, top: 30),
            child: TextFormField(
              controller: passwordController,
              obscureText: passwordVisible,
              //controller: passwordController,
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
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                if (!value.contains(RegExp(r'[A-Z]'))) {
                  return 'Password must contain at least one uppercase letter';
                }
                if (!value.contains(RegExp(r'[a-z]'))) {
                  return 'Password must contain at least one lowercase letter';
                }
                if (!value.contains(RegExp(r'[0-9]'))) {
                  return 'Password must contain at least one digit';
                }
                if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                  return 'Password must contain at least one special character';
                }
                return null; // Return null if the validation is successful
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 190),
            child: CupertinoButton(
              child: const Text('FORGOT PASSWORD ?',style: TextStyle(color: Color(0xFFEC441E),fontWeight: FontWeight.w600),),
              onPressed: (){
                Navigator.push(
                    context,
                    CupertinoPageRoute(builder :(context) => const ForgotPassword())
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: InkWell(
                onTap: (){
                  sendPostRequest();
                },
               child:Container(
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: const Color(0xFFEC441E))
                ),
                child: const Center(child: Text("Login",style: TextStyle(fontSize: 20, color: Color(0xFFEC441E),fontWeight: FontWeight.w600),)),
              ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 140),
            child: Container(
              height: 95,
              width: 800,
               decoration: const BoxDecoration(
                  color: Color(0xFFF88863)
              ),
              child: CupertinoButton(
                child: const Text('SIGN UP',style: TextStyle(color: Colors.black,decoration: TextDecoration.underline,fontWeight: FontWeight.w600),),
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

  Future<void> sendPostRequest() async {

    var jsonObject ={
      "email": emailController.text,
      "password": passwordController.text,
    };
    var response = await http.post(Uri.parse('http://10.0.2.2:3000/user/login/'),
      //  headers: {'Content-Type': 'application/json'},
        body: jsonObject);

    if (response.statusCode == 200) {
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Homepage())
        );
      }
      /*Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Post created successfully!"),
      ));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Failed to create post!"),
      ));*/
    }
  }
}
