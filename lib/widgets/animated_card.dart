import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../helpers/price.dart';

class AnimatedConfirmDialog extends StatefulWidget {
  final dynamic data;
  final dynamic confirmPinController;
  final dynamic languagesController;
  final dynamic box;
  final double screenWidth;

  const AnimatedConfirmDialog({
    required this.data,
    required this.confirmPinController,
    required this.languagesController,
    required this.box,
    required this.screenWidth,
  });

  @override
  State<AnimatedConfirmDialog> createState() => AnimatedConfirmDialogState();
}

class AnimatedConfirmDialogState extends State<AnimatedConfirmDialog>
    with TickerProviderStateMixin {
  // entrance
  late AnimationController _slideCtrl;
  late AnimationController _fadeCtrl;
  // continuous
  late AnimationController _borderCtrl; // 4-side running light
  late AnimationController _pulseCtrl; // logo pulse
  late AnimationController _shimmerCtrl; // title shimmer
  // confirm button
  late AnimationController _btnCtrl; // idle glow pulse

  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _borderAnim;
  late Animation<double> _pulseAnim;
  late Animation<double> _shimmerAnim;
  late Animation<double> _btnGlowAnim;

  bool _isPinFocused = false;
  final FocusNode _pinFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    // entrance
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(
      begin: 0.88,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutBack));

    // running border
    _borderCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _borderAnim = CurvedAnimation(parent: _borderCtrl, curve: Curves.linear);

    // logo pulse
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 1.0,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    // title shimmer
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _shimmerAnim = Tween<double>(
      begin: -1.5,
      end: 2.5,
    ).animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut));

    // confirm button glow
    _btnCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _btnGlowAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _btnCtrl, curve: Curves.easeInOut));

    _slideCtrl.forward();
    _fadeCtrl.forward();

    _pinFocus.addListener(
      () => setState(() => _isPinFocused = _pinFocus.hasFocus),
    );
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _fadeCtrl.dispose();
    _borderCtrl.dispose();
    _pulseCtrl.dispose();
    _shimmerCtrl.dispose();
    _btnCtrl.dispose();
    _pinFocus.dispose();
    super.dispose();
  }

  Map<String, dynamic> _validityConfig(String type) {
    switch (type) {
      case 'unlimited':
        return {
          'label': 'UNLIMITED',
          'color': const Color(0xff826AF9),
          'icon': Icons.all_inclusive,
        };
      case 'monthly':
        return {
          'label': 'MONTHLY',
          'color': const Color(0xff0EA5E9),
          'icon': Icons.calendar_month,
        };
      case 'weekly':
        return {
          'label': 'WEEKLY',
          'color': const Color(0xff10B981),
          'icon': Icons.view_week,
        };
      case 'daily':
        return {
          'label': 'DAILY',
          'color': const Color(0xffF59E0B),
          'icon': Icons.today,
        };
      case 'hourly':
        return {
          'label': 'HOURLY',
          'color': const Color(0xffEF4444),
          'icon': Icons.schedule,
        };
      case 'nightly':
        return {
          'label': 'NIGHTLY',
          'color': const Color(0xff6366F1),
          'icon': Icons.nights_stay,
        };
      default:
        return {'label': '', 'color': Colors.grey, 'icon': Icons.info};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Obx(
              () => widget.confirmPinController.isLoading.value
                  ? _buildLoadingState()
                  : _buildMainContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 160,
              width: 160,
              child: Lottie.asset('assets/loties/recharge.json'),
            ),
            const SizedBox(height: 12),
            ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: [Color(0xff10B981), Color(0xff059669)],
              ).createShader(b),
              child: const Text(
                'Processing…',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    final validityConfig = _validityConfig(widget.data.validityType.toString());

    // Wrap in AnimatedBuilder so the border repaints every frame
    return AnimatedBuilder(
      animation: _borderAnim,
      builder: (context, child) => CustomPaint(
        painter: _RunningBorderPainter(
          progress: _borderAnim.value,
          radius: 32,
          strokeWidth: 3.0,
          trailLength: 0.28,
          colors: const [
            Color(0xff6366F1),
            Color(0xff10B981),
            Color(0xffF59E0B),
            Color(0xffEC4899),
          ],
        ),
        child: child,
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 520),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xffF8FAFF), Color(0xffF0F4FF)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff6366F1).withOpacity(0.15),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            children: [
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (validityConfig['color'] as Color).withOpacity(0.06),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xff10B981).withOpacity(0.06),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(validityConfig),
                      const SizedBox(height: 14),
                      _buildPricingCard(),
                      const SizedBox(height: 10),
                      _buildPhoneRow(),
                      const SizedBox(height: 14),
                      _buildPinInput(),
                      const SizedBox(height: 20),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> validityConfig) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xffE2E8FF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, child) =>
                Transform.scale(scale: _pulseAnim.value, child: child),
            child: Container(
              height: 58,
              width: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    (validityConfig['color'] as Color).withOpacity(0.15),
                    (validityConfig['color'] as Color).withOpacity(0.05),
                  ],
                ),
                border: Border.all(
                  color: (validityConfig['color'] as Color).withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (validityConfig['color'] as Color).withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: widget.data.service!.company!.companyLogo
                      .toString(),
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Icon(
                    Icons.business_rounded,
                    color: validityConfig['color'] as Color,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedBuilder(
                  animation: _shimmerAnim,
                  builder: (_, __) => ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: const [
                        Color(0xff1E293B),
                        Color(0xff94A3B8),
                        Color(0xff1E293B),
                      ],
                      stops: [
                        (_shimmerAnim.value - 0.5).clamp(0.0, 1.0),
                        _shimmerAnim.value.clamp(0.0, 1.0),
                        (_shimmerAnim.value + 0.5).clamp(0.0, 1.0),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      widget.data.bundleTitle.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (_, v, child) => Transform.scale(
                    scale: v,
                    alignment: Alignment.centerLeft,
                    child: child,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (validityConfig['color'] as Color).withOpacity(0.18),
                          (validityConfig['color'] as Color).withOpacity(0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: (validityConfig['color'] as Color).withOpacity(
                          0.3,
                        ),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          validityConfig['icon'] as IconData,
                          color: validityConfig['color'] as Color,
                          size: 12,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.languagesController.tr(
                            validityConfig['label'] as String,
                          ),
                          style: TextStyle(
                            color: validityConfig['color'] as Color,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - v)),
          child: child,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff1E293B), Color(0xff0F172A)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff1E293B).withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.languagesController.tr("BUY"),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      PriceTextView(
                        price: widget.data.buyingPrice.toString(),
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          widget.box.read("currency_code"),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "SELL",
                    style: TextStyle(
                      color: Color(0xff6EE7B7),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      PriceTextView(
                        price: widget.data.sellingPrice.toString(),
                        textStyle: const TextStyle(
                          color: Color(0xff34D399),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          widget.box.read("currency_code"),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff6EE7B7),
                          ),
                        ),
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

  Widget _buildPhoneRow() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - v)),
          child: child,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xffE2E8FF), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xff6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.phone_rounded,
                color: Color(0xff6366F1),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              widget.languagesController.tr("PHONENUMBER"),
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              widget.confirmPinController.numberController.text.toString(),
              style: const TextStyle(
                color: Color(0xff1E293B),
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinInput() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutBack,
      builder: (_, v, child) => Transform.scale(scale: v, child: child),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        height: 64,
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 2.5,
            color: _isPinFocused
                ? const Color(0xff6366F1)
                : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: _isPinFocused
                  ? const Color(0xff6366F1).withOpacity(0.18)
                  : Colors.black.withOpacity(0.05),
              blurRadius: _isPinFocused ? 18 : 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseAnim,
              builder: (_, child) => Transform.scale(
                scale: _isPinFocused ? _pulseAnim.value : 1.0,
                child: child,
              ),
              child: Icon(
                Icons.lock_rounded,
                color: _isPinFocused
                    ? const Color(0xff6366F1)
                    : Colors.grey.shade400,
                size: 16,
              ),
            ),
            const SizedBox(height: 3),
            TextField(
              focusNode: _pinFocus,
              maxLength: 4,
              controller: widget.confirmPinController.pinController,
              keyboardType: TextInputType.phone,
              textAlign: TextAlign.center,
              obscureText: true,
              decoration: InputDecoration(
                counterText: '',
                hintText: widget.languagesController.tr("PIN"),
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 6,
                color: _isPinFocused
                    ? const Color(0xff6366F1)
                    : const Color(0xff1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, 30 * (1 - v)),
          child: child,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _ConfirmButton(
              glowAnim: _btnGlowAnim,
              onTap: () async {
                if (!widget.confirmPinController.isLoading.value) {
                  if (widget.confirmPinController.pinController.text.isEmpty ||
                      widget.confirmPinController.pinController.text.length !=
                          4) {
                    Fluttertoast.showToast(
                      msg: widget.languagesController.tr("ENTER_YOUR_PIN"),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } else {
                    await widget.confirmPinController.placeOrder(context);
                  }
                }
              },
              label: widget.languagesController.tr("CONFIRMATION"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _CancelButton(
              onTap: () => Navigator.pop(context),
              label: widget.languagesController.tr("CANCEL"),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// 🔵  Running Border Painter  — neon light travels all 4 sides
// ══════════════════════════════════════════════════════════════

class _RunningBorderPainter extends CustomPainter {
  final double progress; // 0.0 → 1.0 (one full loop)
  final double radius;
  final double strokeWidth;
  final double trailLength; // 0.0–1.0 fraction of perimeter
  final List<Color> colors;

  _RunningBorderPainter({
    required this.progress,
    required this.radius,
    required this.strokeWidth,
    required this.trailLength,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Full rounded-rect path (clockwise)
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, w, h),
          Radius.circular(radius),
        ),
      );

    final metrics = path.computeMetrics().first;
    final total = metrics.length;

    final headPos = progress * total;
    final tailPos = headPos - trailLength * total;

    // The gradient rotates with the progress so colors feel "alive"
    Shader _buildShader(Rect rect) => SweepGradient(
      colors: [...colors, colors.first],
      transform: GradientRotation(progress * 3.14159 * 2),
    ).createShader(rect);

    final rect = Rect.fromLTWH(0, 0, w, h);

    void _drawSegment(double from, double to) {
      from = from.clamp(0.0, total);
      to = to.clamp(0.0, total);
      if (to <= from) return;
      final seg = metrics.extractPath(from, to);

      // soft outer glow
      canvas.drawPath(
        seg,
        Paint()
          ..shader = _buildShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 8
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );

      // mid glow
      canvas.drawPath(
        seg,
        Paint()
          ..shader = _buildShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 3
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );

      // core line
      canvas.drawPath(
        seg,
        Paint()
          ..shader = _buildShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }

    if (tailPos < 0) {
      // wrap: draw tail from end of perimeter + head from start
      _drawSegment(total + tailPos, total);
      _drawSegment(0, headPos);
    } else {
      _drawSegment(tailPos, headPos);
    }

    // Bright white spark at the head tip
    final sparkFrom = (headPos - strokeWidth).clamp(0.0, total);
    final sparkTo = headPos.clamp(0.0, total);
    if (sparkTo > sparkFrom) {
      final spark = metrics.extractPath(sparkFrom, sparkTo);
      canvas.drawPath(
        spark,
        Paint()
          ..color = Colors.white.withOpacity(0.95)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 3
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
    }
  }

  @override
  bool shouldRepaint(_RunningBorderPainter old) => old.progress != progress;
}

// ══════════════════════════════════════════════════════════════
// ✅  Confirm Button — animated gradient + shimmer + ripple
// ══════════════════════════════════════════════════════════════

class _ConfirmButton extends StatefulWidget {
  final Animation<double> glowAnim;
  final VoidCallback onTap;
  final String label;

  const _ConfirmButton({
    required this.glowAnim,
    required this.onTap,
    required this.label,
  });

  @override
  State<_ConfirmButton> createState() => _ConfirmButtonState();
}

class _ConfirmButtonState extends State<_ConfirmButton>
    with TickerProviderStateMixin {
  // press scale
  late AnimationController _pressCtrl;
  late Animation<double> _pressAnim;

  // ripple on tap
  late AnimationController _rippleCtrl;
  late Animation<double> _rippleAnim;
  bool _showRipple = false;
  Offset _rippleOffset = Offset.zero;

  // particle burst
  late AnimationController _particleCtrl;
  late Animation<double> _particleAnim;
  bool _showParticles = false;

  @override
  void initState() {
    super.initState();

    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
    );
    _pressAnim = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut));

    _rippleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _rippleAnim = CurvedAnimation(parent: _rippleCtrl, curve: Curves.easeOut);
    _rippleCtrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        setState(() => _showRipple = false);
        _rippleCtrl.reset();
      }
    });

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _particleAnim = CurvedAnimation(
      parent: _particleCtrl,
      curve: Curves.easeOut,
    );
    _particleCtrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        setState(() => _showParticles = false);
        _particleCtrl.reset();
      }
    });
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    _rippleCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails d) {
    _pressCtrl.forward();
    setState(() {
      _showRipple = true;
      _showParticles = true;
      _rippleOffset = d.localPosition;
    });
    _rippleCtrl.forward(from: 0);
    _particleCtrl.forward(from: 0);
  }

  void _onTapUp(TapUpDetails _) {
    _pressCtrl.reverse();
    widget.onTap();
  }

  void _onTapCancel() => _pressCtrl.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _pressAnim,
          widget.glowAnim,
          _rippleAnim,
          _particleAnim,
        ]),
        builder: (context, _) {
          final glow = widget.glowAnim.value;
          final press = _pressAnim.value;

          return Transform.scale(
            scale: press,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(
                      const Color.fromARGB(255, 238, 106, 19),
                      const Color(0xff34D399),
                      glow,
                    )!,
                    Color.lerp(
                      const Color.fromARGB(255, 161, 236, 22),
                      const Color(0xff10B981),
                      glow,
                    )!,
                  ],
                ),
                boxShadow: [
                  // primary shadow
                  BoxShadow(
                    color: const Color(
                      0xff10B981,
                    ).withOpacity(0.30 + 0.22 * glow),
                    blurRadius: 18 + 12 * glow,
                    offset: const Offset(0, 6),
                  ),
                  // ambient ring glow
                  BoxShadow(
                    color: const Color(
                      0xff34D399,
                    ).withOpacity(0.18 + 0.22 * glow),
                    blurRadius: 28 + 18 * glow,
                    spreadRadius: -3,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // ── Moving shimmer sweep ──────────────────
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(-2.0 + 4.0 * glow, -0.4),
                            end: Alignment(-1.0 + 4.0 * glow, 0.4),
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.18),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ── Tap ripple ────────────────────────────
                    if (_showRipple)
                      Positioned(
                        left: _rippleOffset.dx - 100 * _rippleAnim.value,
                        top: _rippleOffset.dy - 100 * _rippleAnim.value,
                        child: Opacity(
                          opacity: (1 - _rippleAnim.value).clamp(0, 1),
                          child: Container(
                            width: 200 * _rippleAnim.value,
                            height: 200 * _rippleAnim.value,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white30,
                            ),
                          ),
                        ),
                      ),

                    // ── Particle burst ────────────────────────
                    if (_showParticles) ..._buildParticles(_particleAnim.value),

                    // ── Label ─────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.elasticOut,
                          builder: (_, v, child) =>
                              Transform.scale(scale: v, child: child),
                          child: const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Small star particles that burst outward on tap
  List<Widget> _buildParticles(double t) {
    const particleCount = 6;
    final particles = <Widget>[];
    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * 3.14159 * 2;
      final dx = 28.0 * t * cos(angle);
      final dy = 28.0 * t * sin(angle);
      final opacity = (1 - t).clamp(0.0, 1.0);
      particles.add(
        Positioned(
          left: _rippleOffset.dx + dx - 4,
          top: _rippleOffset.dy + dy - 4,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }
    return particles;
  }
}

// dart:math import needed at top of file for cos/sin:
// import 'dart:math' show cos, sin;

// ══════════════════════════════════════════════════════════════
// ✖  Cancel Button
// ══════════════════════════════════════════════════════════════

class _CancelButton extends StatefulWidget {
  final VoidCallback onTap;
  final String label;
  const _CancelButton({required this.onTap, required this.label});

  @override
  State<_CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<_CancelButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.94,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.close_rounded, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
