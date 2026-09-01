import 'package:flutter/material.dart';
import 'package:pamirnet/utils/colors.dart';

class AnimatedBorderButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;

  AnimatedBorderButton({super.key, this.label = "Continue", this.onTap});

  @override
  State<AnimatedBorderButton> createState() => _AnimatedBorderButtonState();
}

class _AnimatedBorderButtonState extends State<AnimatedBorderButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            height: 55,
            width: double.infinity,
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: SweepGradient(
                colors: [
                  Color(0xFF00C6FF),
                  Color(0xFF7B2FF7),
                  Color(0xFFFF6FD8),
                  Color(0xFFFF4E50),
                  Color(0xFF00C6FF),
                ],
                transform: GradientRotation(_controller.value * 2 * 3.14159),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
