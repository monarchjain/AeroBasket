import 'package:aerobasket/searchpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}
class _ChangePasswordState extends State<ChangePassword> {
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
            const Center(child: Text("Personal Info",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(child: Image.asset("assets/profilepic.png")),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(child: Text("Monarch",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
              child: TextField(
                obscureText: passwordVisible,
                decoration: InputDecoration(
                  labelText: "Old Password",
                  helperStyle:const TextStyle(color:Colors.red),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  hintText: "Enter  your Old Password",
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
              padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
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
              padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
              child: TextField(
                obscureText: passwordVisible,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  helperText:"Password must contain special character",
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
              padding: const EdgeInsets.only(top: 180),
              child: Center(
                child: Container(
                  height: 40,
                  width: 150,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color(0xFFEC441E)
                  ),
                  child: const Center(child: Text("Update",style: TextStyle(fontSize: 20,color: Colors.white),)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: CupertinoButton(
                  child: const Text('Skip',style: TextStyle(color: Color(0xFFEC441E)),),
                  onPressed: (){
                    Navigator.push(
                        context,
                        CupertinoPageRoute(builder :(context) => const Searchpage())
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
