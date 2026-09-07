import 'dart:convert';
import 'package:aerobasket/resetpassword.dart';
import 'package:aerobasket/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'config/api_config.dart';

class OtpPage extends StatefulWidget {
  final String email;
  const OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> controllers = List.generate(5, (_) => TextEditingController());
  bool isLoading = false;

  String get enteredOtp => controllers.map((c) => c.text).join();

  Future<void> verifyOtp() async {
    if (enteredOtp.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter all 5 digits")),
      );
      return;
    }

    setState(() { isLoading = true; });

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": widget.email, "otp": enteredOtp}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResetPassword(resetToken: data['resetToken'])),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Invalid or expired OTP')),
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

  Widget otpBox(int index) {
    return SizedBox(
      height: 68,
      width: 64,
      child: TextField(
        controller: controllers[index],
        onChanged: (value){
          if(value.length == 1 && index < 4){
            FocusScope.of(context).nextFocus();
          }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          ),
        ),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
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
              padding: EdgeInsets.only(left: 30,top: 20),
              child: Text("Verification Code",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30,top: 60),
              child: Text("Enter your 5 digit Passcode Sent on your E-mail ",style: TextStyle(fontSize: 15),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Form(child: Padding(
                padding: const EdgeInsets.only(left: 10,right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    otpBox(0),
                    otpBox(1),
                    otpBox(2),
                    otpBox(3),
                    otpBox(4),
                  ],
                ),
              )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child:InkWell(
                onTap: isLoading ? null : verifyOtp,
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
                          : const Text("Verify OTP",style: TextStyle(fontSize: 20, color: Color(0xFFEC441E),fontWeight: FontWeight.w600),),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 230),
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