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
class SlideToConfirm extends StatefulWidget {
  final String label;
  final VoidCallback onConfirm;
  const SlideToConfirm({super.key, required this.label, required this.onConfirm});

  @override
  State<SlideToConfirm> createState() => _SlideToConfirmState();
}

class _SlideToConfirmState extends State<SlideToConfirm> {
  double _dragX = 0;
  bool _confirmed = false;

  static const double _thumbSize = 48;
  static const double _trackHeight = 56;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxDrag = constraints.maxWidth - _thumbSize - 8;
        return Container(
          height: _trackHeight,
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(_trackHeight / 2),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Center(
                child: Text(
                  widget.label,
                  style: GoogleFonts.inter(color: Colors.white.withOpacity(0.75), fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ),
              AnimatedPositioned(
                duration: _confirmed ? const Duration(milliseconds: 250) : Duration.zero,
                left: 4 + _dragX,
                top: 4,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (_confirmed) return;
                    setState(() {
                      _dragX = (_dragX + details.delta.dx).clamp(0, maxDrag);
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (_confirmed) return;
                    if (_dragX > maxDrag * 0.75) {
                      setState(() {
                        _dragX = maxDrag;
                        _confirmed = true;
                      });
                      widget.onConfirm();
                    } else {
                      setState(() { _dragX = 0; });
                    }
                  },
                  child: Container(
                    height: _thumbSize,
                    width: _thumbSize,
                    decoration: const BoxDecoration(
                      color: AppColors.runway,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const SecondaryButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.runway, width: 1.4),
            ),
            child: Center(
              child: Text(label, style: GoogleFonts.inter(color: AppColors.runway, fontWeight: FontWeight.w600, fontSize: 16)),
            ),
          ),
        ),
      ),
    );
  }
}