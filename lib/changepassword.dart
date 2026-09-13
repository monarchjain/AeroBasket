import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'controllers/auth_controller.dart';
import 'config/api_config.dart';
import 'config/app_theme.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final AuthController authController = Get.find<AuthController>();
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool oldVisible = true;
  bool newVisible = true;
  bool confirmVisible = true;
  bool isLoading = false;

  Future<void> updatePassword() async {
    if (!globalKey.currentState!.validate()) {
      return;
    }

    setState(() { isLoading = true; });

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authController.token.value}',
        },
        body: jsonEncode({
          "oldPassword": oldPasswordController.text,
          "newPassword": newPasswordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password changed successfully")),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Could not change password')),
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
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 36),
                decoration: const BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.lock_outline, color: Colors.white, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      'Change password',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Choose a strong new password",
                      style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withOpacity(0.7)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: oldPasswordController,
                      obscureText: oldVisible,
                      decoration: AppInputs.filled(label: "Current password", icon: Icons.lock_outline).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(oldVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.slate),
                          onPressed: () => setState(() { oldVisible = !oldVisible; }),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your current password';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: newPasswordController,
                      obscureText: newVisible,
                      decoration: AppInputs.filled(label: "New password", icon: Icons.lock_reset).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(newVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.slate),
                          onPressed: () => setState(() { newVisible = !newVisible; }),
                        ),
                      ),
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
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: confirmVisible,
                      decoration: AppInputs.filled(label: "Confirm new password", icon: Icons.lock_outline).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(confirmVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.slate),
                          onPressed: () => setState(() { confirmVisible = !confirmVisible; }),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please confirm your new password';
                        if (value != newPasswordController.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      label: "Update password",
                      isLoading: isLoading,
                      onTap: isLoading ? null : updatePassword,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}