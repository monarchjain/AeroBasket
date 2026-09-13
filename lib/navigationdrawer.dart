import 'package:aerobasket/changepassword.dart';
import 'package:aerobasket/login.dart';
import 'package:aerobasket/mybooking.dart';
import 'package:aerobasket/updateprofile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controllers/auth_controller.dart';
import 'config/api_config.dart';
import 'config/app_theme.dart';

class Navigationdrawer extends StatefulWidget {
  const Navigationdrawer({super.key});

  @override
  State<Navigationdrawer> createState() => _NavigationdrawerState();
}

class _NavigationdrawerState extends State<Navigationdrawer> {
  final AuthController authController = Get.find<AuthController>();

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Sign out", style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600)),
        content: Text("Are you sure you want to sign out?", style: GoogleFonts.inter()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text("Cancel", style: GoogleFonts.inter(color: AppColors.slate)),
          ),
          TextButton(
            onPressed: () {
              authController.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false,
              );
            },
            child: Text("Sign out", style: GoogleFonts.inter(color: Colors.red, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.navy),
      title: Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.paper,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Obx(() => Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            decoration: const BoxDecoration(color: AppColors.navy),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  backgroundImage: authController.profilePhotoUrl.value.isNotEmpty
                      ? NetworkImage('${ApiConfig.baseUrl}${authController.profilePhotoUrl.value}')
                      : const AssetImage("assets/profilepic.png") as ImageProvider,
                ),
                const SizedBox(height: 14),
                Text(authController.userName.value, style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(authController.userEmail.value, style: GoogleFonts.inter(color: Colors.white.withOpacity(0.7), fontSize: 13)),
              ],
            ),
          )),
          const SizedBox(height: 8),
          _tile(Icons.edit_outlined, "Edit account", (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateProfile()));
          }),
          _tile(Icons.lock_outline, "Change password", (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePassword()));
          }),
          _tile(Icons.confirmation_number_outlined, "My bookings", (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyBooking()));
          }),
          _tile(Icons.headset_mic_outlined, "Support", (){}),
          _tile(Icons.star_border, "Rate us", (){}),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text("Sign out", style: GoogleFonts.inter(color: Colors.red, fontWeight: FontWeight.w600)),
            onTap: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }
}