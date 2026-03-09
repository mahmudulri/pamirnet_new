import 'package:flutter/material.dart';

import '../utils/colors.dart';

class GradientActionButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const GradientActionButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  State<GradientActionButton> createState() => _GradientActionButtonState();
}

class _GradientActionButtonState extends State<GradientActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: _isPressed
                ? [
                    AppColors.primaryColor.withOpacity(0.85),
                    AppColors.primaryColor.withOpacity(0.55),
                  ]
                : [
                    AppColors.primaryColor,
                    AppColors.primaryColor.withOpacity(0.75),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(
                _isPressed ? 0.25 : 0.45,
              ),
              blurRadius: _isPressed ? 10 : 20,
              spreadRadius: _isPressed ? 1 : 2,
              offset: Offset(0, _isPressed ? 3 : 6),
            ),
          ],
        ),
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
