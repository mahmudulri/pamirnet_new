import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

import '../controllers/confirm_pin_controller.dart';
import '../global_controller/languages_controller.dart';

class SocialdialogBox extends StatefulWidget {
  SocialdialogBox({
    super.key,
    this.title,
    this.validity,
    this.buyingprice,
    this.sellingprice,
    this.imagelink,
    this.companyname,
  });

  String? companyname;
  String? title;
  String? validity;
  String? buyingprice;
  String? sellingprice;
  String? imagelink;

  @override
  State<SocialdialogBox> createState() => _SocialdialogBoxState();
}

class _SocialdialogBoxState extends State<SocialdialogBox>
    with TickerProviderStateMixin {
  // controllers
  final confirmPinController = Get.find<ConfirmPinController>();
  final box = GetStorage();
  LanguagesController languagesController = Get.put(LanguagesController());

  // ── animation controllers ──────────────────────────────────
  late AnimationController _slideCtrl;
  late AnimationController _fadeCtrl;
  late AnimationController _borderCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _shimmerCtrl;
  late AnimationController _btnCtrl;

  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _borderAnim;
  late Animation<double> _pulseAnim;
  late Animation<double> _shimmerAnim;
  late Animation<double> _btnGlowAnim;

  // PIN focus
  bool _isPinFocused = false;
  final FocusNode _pinFocus = FocusNode();

  // ID field focus
  bool _isIdFocused = false;
  final FocusNode _idFocus = FocusNode();

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
      begin: const Offset(0, 0.38),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(
      begin: 0.86,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutBack));

    // running border
    _borderCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _borderAnim = CurvedAnimation(parent: _borderCtrl, curve: Curves.linear);

    // logo pulse
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 1.0,
      end: 1.07,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    // company name shimmer
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
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
    _idFocus.addListener(
      () => setState(() => _isIdFocused = _idFocus.hasFocus),
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
    _idFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Obx(
            () => confirmPinController.isLoading.value
                ? _buildLoadingState()
                : _buildMainContent(),
          ),
        ),
      ),
    );
  }

  // ── Loading ────────────────────────────────────────────────
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
                colors: [Color(0xff1890FF), Color(0xff0066CC)],
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

  // ── Main Content ───────────────────────────────────────────
  Widget _buildMainContent() {
    return AnimatedBuilder(
      animation: _borderAnim,
      builder: (context, child) => CustomPaint(
        painter: _RunningBorderPainter(
          progress: _borderAnim.value,
          radius: 32,
          strokeWidth: 3.0,
          trailLength: 0.28,
          colors: const [
            Color(0xff1890FF),
            Color(0xff10B981),
            Color(0xffF59E0B),
            Color(0xffEC4899),
          ],
        ),
        child: child,
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 560),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xffF8FAFF), Color(0xffEEF4FF)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff1890FF).withOpacity(0.15),
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
              // background orbs
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xff1890FF).withOpacity(0.06),
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
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeroCard(),
                      const SizedBox(height: 12),
                      _buildIdInput(),
                      const SizedBox(height: 10),
                      _buildPinInput(),
                      const SizedBox(height: 18),
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

  // ── Hero Card (logo + name + title + pricing) ──────────────
  Widget _buildHeroCard() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - v)),
          child: child,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff1890FF), Color(0xff0050CC)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff1890FF).withOpacity(0.38),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // subtle diagonal shine
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: const Alignment(-1.5, -1.5),
                      end: const Alignment(0.5, 0.5),
                      colors: [
                        Colors.white.withOpacity(0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Logo
                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, child) =>
                        Transform.scale(scale: _pulseAnim.value, child: child),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                          BoxShadow(
                            color: const Color(0xff1890FF).withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                      child: Image.network(
                        widget.imagelink.toString(),
                        height: 56,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.business_rounded,
                          color: Color(0xff1890FF),
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Company name with shimmer
                  AnimatedBuilder(
                    animation: _shimmerAnim,
                    builder: (_, __) => ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: const [
                          Colors.white,
                          Color(0xffBBDEFB),
                          Colors.white,
                        ],
                        stops: [
                          (_shimmerAnim.value - 0.5).clamp(0.0, 1.0),
                          _shimmerAnim.value.clamp(0.0, 1.0),
                          (_shimmerAnim.value + 0.5).clamp(0.0, 1.0),
                        ],
                      ).createShader(bounds),
                      child: Text(
                        widget.companyname.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Bundle title badge
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.elasticOut,
                    builder: (_, v, child) =>
                        Transform.scale(scale: v, child: child),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            languagesController.tr("BUNDLE_TITLE"),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              widget.title.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Pricing card (white)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _priceRow(
                          icon: Icons.shopping_bag_outlined,
                          iconColor: const Color(0xff1890FF),
                          label: languagesController.tr("BUY"),
                          price: widget.buyingprice.toString(),
                          priceColor: Colors.black87,
                        ),
                        Divider(
                          height: 14,
                          color: Colors.grey.shade100,
                          thickness: 1.5,
                        ),
                        _priceRow(
                          icon: Icons.sell_outlined,
                          iconColor: const Color(0xff10B981),
                          label: languagesController.tr("SALE"),
                          price: widget.sellingprice.toString(),
                          priceColor: const Color(0xff10B981),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String price,
    required Color priceColor,
  }) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          price,
          style: TextStyle(
            color: priceColor,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          box.read("currency_code"),
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ── ID Input ───────────────────────────────────────────────
  Widget _buildIdInput() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 750),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - v)),
          child: child,
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isIdFocused
                ? const Color(0xff1890FF)
                : Colors.grey.shade200,
            width: _isIdFocused ? 2.0 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _isIdFocused
                  ? const Color(0xff1890FF).withOpacity(0.15)
                  : Colors.black.withOpacity(0.04),
              blurRadius: _isIdFocused ? 18 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _isIdFocused
                      ? const Color(0xff1890FF).withOpacity(0.12)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.phone_android_rounded,
                  color: _isIdFocused
                      ? const Color(0xff1890FF)
                      : Colors.grey.shade400,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  focusNode: _idFocus,
                  controller: confirmPinController.numberController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: languagesController.tr("ENTER_ID"),
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 15,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1E293B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── PIN Input ──────────────────────────────────────────────
  Widget _buildPinInput() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutBack,
      builder: (_, v, child) => Transform.scale(scale: v, child: child),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          height: 60,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              width: 2.5,
              color: _isPinFocused
                  ? const Color(0xff1890FF)
                  : Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: _isPinFocused
                    ? const Color(0xff1890FF).withOpacity(0.18)
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
                      ? const Color(0xff1890FF)
                      : Colors.grey.shade400,
                  size: 16,
                ),
              ),
              const SizedBox(height: 3),
              TextField(
                focusNode: _pinFocus,
                maxLength: 4,
                controller: confirmPinController.pinController,
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: languagesController.tr("PIN"),
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 6,
                  color: _isPinFocused
                      ? const Color(0xff1890FF)
                      : const Color(0xff1E293B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Action Buttons ─────────────────────────────────────────
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
            child: _SocialConfirmButton(
              glowAnim: _btnGlowAnim,
              onTap: () {
                if (confirmPinController.numberController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: languagesController.tr("ENTER_ID"),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  return;
                }
                if (confirmPinController.pinController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: languagesController.tr("ENTER_YOUR_PIN"),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  return;
                }
                confirmPinController.placeOrder(context);
              },
              label: languagesController.tr("CONFIRMATION"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _SocialCancelButton(
              onTap: () => Navigator.pop(context),
              label: languagesController.tr("CANCEL"),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// 🔵  Running Border Painter — neon light travels all 4 sides
// ══════════════════════════════════════════════════════════════

class _RunningBorderPainter extends CustomPainter {
  final double progress;
  final double radius;
  final double strokeWidth;
  final double trailLength;
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
    final rect = Rect.fromLTWH(0, 0, w, h);

    Shader _shader() => SweepGradient(
      colors: [...colors, colors.first],
      transform: GradientRotation(progress * 3.14159 * 2),
    ).createShader(rect);

    void _draw(double from, double to) {
      from = from.clamp(0.0, total);
      to = to.clamp(0.0, total);
      if (to <= from) return;
      final seg = metrics.extractPath(from, to);

      canvas.drawPath(
        seg,
        Paint()
          ..shader = _shader()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 8
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );

      canvas.drawPath(
        seg,
        Paint()
          ..shader = _shader()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 3
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );

      canvas.drawPath(
        seg,
        Paint()
          ..shader = _shader()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }

    if (tailPos < 0) {
      _draw(total + tailPos, total);
      _draw(0, headPos);
    } else {
      _draw(tailPos, headPos);
    }

    // white spark at tip
    final s0 = (headPos - strokeWidth).clamp(0.0, total);
    final s1 = headPos.clamp(0.0, total);
    if (s1 > s0) {
      canvas.drawPath(
        metrics.extractPath(s0, s1),
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
  bool shouldRepaint(_RunningBorderPainter o) => o.progress != progress;
}

// ══════════════════════════════════════════════════════════════
// ✅  Social Confirm Button
// ══════════════════════════════════════════════════════════════

class _SocialConfirmButton extends StatefulWidget {
  final Animation<double> glowAnim;
  final VoidCallback onTap;
  final String label;

  const _SocialConfirmButton({
    required this.glowAnim,
    required this.onTap,
    required this.label,
  });

  @override
  State<_SocialConfirmButton> createState() => _SocialConfirmButtonState();
}

class _SocialConfirmButtonState extends State<_SocialConfirmButton>
    with TickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _pressAnim;
  late AnimationController _rippleCtrl;
  late Animation<double> _rippleAnim;
  late AnimationController _particleCtrl;
  late Animation<double> _particleAnim;

  bool _showRipple = false;
  bool _showParticles = false;
  Offset _tapOffset = Offset.zero;

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
      _tapOffset = d.localPosition;
    });
    _rippleCtrl.forward(from: 0);
    _particleCtrl.forward(from: 0);
  }

  void _onTapUp(TapUpDetails _) {
    _pressCtrl.reverse();
    widget.onTap();
  }

  void _onTapCancel() => _pressCtrl.reverse();

  List<Widget> _particles(double t) {
    const n = 6;
    return List.generate(n, (i) {
      final angle = (i / n) * 3.14159 * 2;
      final dx = 30.0 * t * cos(angle);
      final dy = 30.0 * t * sin(angle);
      return Positioned(
        left: _tapOffset.dx + dx - 4,
        top: _tapOffset.dy + dy - 4,
        child: Opacity(
          opacity: (1 - t).clamp(0.0, 1.0),
          child: Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }

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
        builder: (_, __) {
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
                      const Color(0xff10B981),
                      const Color(0xff34D399),
                      glow,
                    )!,
                    Color.lerp(
                      const Color(0xff059669),
                      const Color(0xff10B981),
                      glow,
                    )!,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xff10B981,
                    ).withOpacity(0.30 + 0.22 * glow),
                    blurRadius: 18 + 12 * glow,
                    offset: const Offset(0, 6),
                  ),
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
                    // shimmer sweep
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
                    // ripple
                    if (_showRipple)
                      Positioned(
                        left: _tapOffset.dx - 100 * _rippleAnim.value,
                        top: _tapOffset.dy - 100 * _rippleAnim.value,
                        child: Opacity(
                          opacity: (1 - _rippleAnim.value).clamp(0.0, 1.0),
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
                    // particles
                    if (_showParticles) ..._particles(_particleAnim.value),

                    // label
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
}

// ══════════════════════════════════════════════════════════════
// ✖  Cancel Button
// ══════════════════════════════════════════════════════════════

class _SocialCancelButton extends StatefulWidget {
  final VoidCallback onTap;
  final String label;
  const _SocialCancelButton({required this.onTap, required this.label});

  @override
  State<_SocialCancelButton> createState() => _SocialCancelButtonState();
}

class _SocialCancelButtonState extends State<_SocialCancelButton>
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
