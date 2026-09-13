import 'dart:convert';
import 'package:aerobasket/login.dart';
import 'package:aerobasket/otppage.dart';
import 'package:aerobasket/signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'config/api_config.dart';
import 'config/app_theme.dart';

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
        if (data['otp'] != null && mounted) {
          await showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Text("Dev mode: your OTP", style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600)),
              content: Text("Email sending isn't set up yet, so here's your OTP:\n\n${data['otp']}", style: GoogleFonts.inter()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text("OK", style: GoogleFonts.inter(color: AppColors.runway, fontWeight: FontWeight.w600)),
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
      backgroundColor: AppColors.paper,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 70, bottom: 36),
              decoration: const BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  const Icon(Icons.lock_reset, color: Colors.white, size: 32),
                  const SizedBox(height: 12),
                  Text(
                    'Forgot password?',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Enter your email and we'll send you a code to reset it",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: AppInputs.filled(label: "Email", hint: "Enter your email", icon: Icons.mail_outline),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: "Send OTP",
                    isLoading: isLoading,
                    onTap: isLoading ? null : sendOtp,
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Remember your password?", style: GoogleFonts.inter(color: AppColors.slate)),
                      TextButton(
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder :(context) => const Login())
                          );
                        },
                        child: Text('Sign in', style: GoogleFonts.inter(color: AppColors.runway, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("New here?", style: GoogleFonts.inter(color: AppColors.slate)),
                      TextButton(
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder :(context) => const SignUp())
                          );
                        },
                        child: Text('Create an account', style: GoogleFonts.inter(color: AppColors.runway, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}