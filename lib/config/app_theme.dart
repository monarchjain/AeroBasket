import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color ink = Color(0xFF1B1B1F);
  static const Color paper = Color(0xFFFBF7F2);
  static const Color navy = Color(0xFF142850);
  static const Color runway = Color(0xFFE8630A);
  static const Color slate = Color(0xFF7C8798);
  static const Color mist = Color(0xFFEEF1F5);
}

class AppInputs {
  static InputDecoration filled({required String label, String? hint, IconData? icon}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: AppColors.slate) : null,
      filled: true,
      fillColor: AppColors.mist,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.runway, width: 1.6),
      ),
      labelStyle: GoogleFonts.inter(color: AppColors.slate),
      hintStyle: GoogleFonts.inter(color: AppColors.slate.withOpacity(0.6)),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  const PrimaryButton({super.key, required this.label, required this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: onTap == null ? AppColors.slate.withOpacity(0.4) : AppColors.runway,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Center(
              child: isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(label, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
            ),
          ),
        ),
      ),
    );
  }
}