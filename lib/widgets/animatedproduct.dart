import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedProductIcon extends StatefulWidget {
  const AnimatedProductIcon({super.key});

  @override
  State<AnimatedProductIcon> createState() => _AnimatedProductIconState();
}

class _AnimatedProductIconState extends State<AnimatedProductIcon>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _shimmerController;
  late AnimationController _bounceController;

  late Animation<double> _pulseAnim;
  late Animation<double> _rotateAnim;
  late Animation<double> _shimmerAnim;
  late Animation<double> _bounceAnim;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    // Pulse - slow breathe
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Rotate - spinning outer ring
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    // Shimmer - sweeping light
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();

    // Bounce - icon hop
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnim = Tween<double>(begin: 0.2, end: 0.8).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotateAnim = Tween<double>(
      begin: 0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(parent: _rotateController, curve: Curves.linear));

    _shimmerAnim = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _bounceAnim = Tween<double>(begin: 0, end: -4).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _shimmerController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _pulseController,
        _rotateController,
        _shimmerController,
        _bounceController,
      ]),
      builder: (context, child) {
        return SizedBox(
          width: 64,
          height: 64,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // --- Layer 1: Outer glow ring ---
              Transform.scale(
                scale: _pulseAnim.value,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFF6C63FF,
                        ).withOpacity(_glowAnim.value * 0.5),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                      BoxShadow(
                        color: const Color(
                          0xFFFF6584,
                        ).withOpacity(_glowAnim.value * 0.3),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),

              // --- Layer 2: Spinning dashed arc ring ---
              Transform.rotate(
                angle: _rotateAnim.value,
                child: CustomPaint(
                  size: const Size(56, 56),
                  painter: _DashedRingPainter(
                    color: const Color(0xFF6C63FF).withOpacity(0.6),
                    strokeWidth: 1.5,
                    dashCount: 10,
                  ),
                ),
              ),

              // --- Layer 3: Counter-spinning dots ring ---
              Transform.rotate(
                angle: -_rotateAnim.value * 0.6,
                child: CustomPaint(
                  size: const Size(44, 44),
                  painter: _DotsRingPainter(
                    color: const Color(0xFFFF6584).withOpacity(0.7),
                    dotCount: 6,
                    dotRadius: 2.5,
                  ),
                ),
              ),

              // --- Layer 4: Main circle background ---
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color.fromARGB(255, 148, 143, 240),
                      const Color.fromARGB(255, 177, 229, 134),
                    ],
                  ),
                ),
              ),

              // --- Layer 5: Shimmer sweep ---
              ClipOval(
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Transform.translate(
                    offset: Offset(_shimmerAnim.value * 48, 0),
                    child: Transform.rotate(
                      angle: 0.5,
                      child: Container(
                        width: 20,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0),
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // --- Layer 6: Bouncing icon ---
              Transform.translate(
                offset: Offset(0, _bounceAnim.value),
                child: const Icon(
                  Icons.shopping_bag_rounded,
                  size: 24,
                  color: Colors.white,
                ),
              ),

              // --- Layer 7: Floating sparkles ---
              ..._buildSparkles(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildSparkles() {
    final sparklePositions = [
      const Offset(-26, -18),
      const Offset(26, -14),
      const Offset(22, 20),
      const Offset(-22, 16),
    ];

    return sparklePositions.asMap().entries.map((entry) {
      final i = entry.key;
      final pos = entry.value;
      final phase = (i / sparklePositions.length);
      final t = (_shimmerController.value + phase) % 1.0;
      final opacity = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.0, 1.0);
      final scale = 0.4 + opacity * 0.6;

      return Positioned(
        left: 32 + pos.dx - 4,
        top: 32 + pos.dy - 4,
        child: Transform.scale(
          scale: scale,
          child: Icon(
            Icons.star_rounded,
            size: 8,
            color: i.isEven
                ? const Color(0xFFFFD700).withOpacity(opacity)
                : const Color(0xFFFF6584).withOpacity(opacity),
          ),
        ),
      );
    }).toList();
  }
}

// --- Custom painter: Dashed Ring ---
class _DashedRingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int dashCount;

  _DashedRingPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final dashAngle = 3.14159 * 2 / dashCount;
    final gapRatio = 0.4;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      final sweepAngle = dashAngle * (1 - gapRatio);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// --- Custom painter: Dots Ring ---
class _DotsRingPainter extends CustomPainter {
  final Color color;
  final int dotCount;
  final double dotRadius;

  _DotsRingPainter({
    required this.color,
    required this.dotCount,
    required this.dotRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final angleStep = 3.14159 * 2 / dotCount;

    for (int i = 0; i < dotCount; i++) {
      final angle = i * angleStep;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
