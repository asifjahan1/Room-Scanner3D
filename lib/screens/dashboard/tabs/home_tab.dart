import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/dashboard_controller.dart';
import '../../../core/routes/app_routes.dart';

// ─── Figma design tokens ────────────────────────────────────────────────────
const _primaryBlue = Color(0xFF0058BC);
const _deepBlue = Color(0xFF00418F);
const _textDark = Color(0xFF191B22);
const _textSub = Color(0xFF5C5F61);
const _textMid = Color(0xFF424753);
const _bgPage = Color(0xFFF9F9FF);
const _surfaceWhite = Color(0xFFFFFFFF);
const _surfaceGrey = Color(0xFFE7E7F1);
const _progressFill = Color(0xFF0058BC);
const _progressEmpty = Color(0xFFE2E8F0);
const _todayHighBg = Color(0x1A0058BC); // rgba(0,88,188,0.10)
const _todayHighBdr = Color(0x1A00418F); // rgba(0,65,143,0.10)
const _weatherIconBg = Color(0x0D0058BC); // rgba(0,88,188,0.05)

TextStyle _jakartaBold(double size, {Color color = _textDark}) =>
    GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color,
      height: 1.33,
    );

TextStyle _jakartaMed(double size, {Color color = _textDark}) =>
    GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: FontWeight.w500,
      color: color,
      height: 1.44,
    );

TextStyle _jakartaReg(double size, {Color color = _textDark}) =>
    GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: color,
      height: 1.5,
    );

TextStyle _interBold(double size, {Color color = _textDark}) =>
    GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color,
    );

TextStyle _interSemiBold(double size, {Color color = _textDark}) =>
    GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: color,
    );

List<BoxShadow> _cardShadow() => [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.05),
    blurRadius: 0,
    offset: const Offset(0, 1),
  ),
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.04),
    blurRadius: 20,
    offset: const Offset(0, 8),
  ),
];

// ─── Main Widget ────────────────────────────────────────────────────────────
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Container(
      color: _bgPage,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 144),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              _Header(
                onNotificationTap: () => Get.toNamed(AppRoutes.notifications),
              ),
              const SizedBox(height: 24),

              // ── Greeting Section ─────────────────────────────────────────
              _GreetingSection(),
              const SizedBox(height: 24),

              // ── Shift Timer Card ─────────────────────────────────────────
              _ShiftTimerCard(controller: controller),
              const SizedBox(height: 16),

              // ── Weather Card ─────────────────────────────────────────────
              _WeatherCard(onTap: () => controller.openWeatherScreen()),
              const SizedBox(height: 16),

              // ── Today Card ───────────────────────────────────────────────
              _TodayCard(onTap: () => controller.viewMyDay()),
              const SizedBox(height: 16),

              // ── Progress Card ────────────────────────────────────────────
              _ProgressCard(onTap: () => controller.viewMyDay()),
              const SizedBox(height: 24),

              // ── Bottom Action Buttons ────────────────────────────────────
              _ActionButton(
                label: 'View my day',
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: () => controller.viewMyDay(),
              ),
              const SizedBox(height: 12),
              _ActionButton(
                label: 'Daily Update',
                leadingIcon: Icons.refresh_rounded,
                onPressed: () => controller.triggerDailyUpdate(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Header ─────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final VoidCallback onNotificationTap;
  const _Header({required this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: _bgPage,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Brand Icon
          const Icon(Icons.handyman, size: 18, color: _deepBlue),
          const SizedBox(width: 8),
          // Brand Name
          Text(
            'PERFEKTWERK OS',
            style: _jakartaBold(
              24,
              color: _deepBlue,
            ).copyWith(letterSpacing: 1.2),
          ),
          const Spacer(),
          // Notification Bell
          GestureDetector(
            onTap: onNotificationTap,
            child: Container(
              width: 32,
              height: 36,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF004AC6),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Profile Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE1E2EB),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=250',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.person,
                  size: 20,
                  color: Color(0xFF5C5F61),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Greeting Section ────────────────────────────────────────────────────────
class _GreetingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text group
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, Daniel',
                style: _jakartaBold(24, color: _textDark),
              ),
              const SizedBox(height: 4),
              Text(
                'Here is your day at a glance.',
                style: _jakartaMed(18, color: _textSub),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Trophy Icon Box
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: _surfaceWhite,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 0,
                offset: const Offset(0, 1),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(child: SvgPicture.asset('assets/icons/cup.svg')),
        ),
      ],
    );
  }
}

// ─── Shift Timer Card ────────────────────────────────────────────────────────
class _ShiftTimerCard extends StatelessWidget {
  final DashboardController controller;
  const _ShiftTimerCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _surfaceWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
        boxShadow: _cardShadow(),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Label
          Text(
            'CURRENT SHIFT SESSION',
            style: _interSemiBold(
              9.45,
              color: const Color(0xFF434655),
            ).copyWith(letterSpacing: 0.47),
          ),
          const SizedBox(height: 3.15),
          // Timer Display
          Obx(
            () => Text(
              controller.formattedTimer,
              style: _interBold(
                37.81,
                color: _textDark,
              ).copyWith(letterSpacing: -0.76),
            ),
          ),
          const SizedBox(height: 12.6),
          // Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Obx(
              () => Column(
                children: [
                  // Clock In / Clock Out
                  _FigmaButton(
                    label: controller.isClockedIn.value
                        ? 'CLOCK OUT'
                        : 'CLOCK IN',
                    leadingIcon: Icons.schedule_rounded,
                    backgroundColor: controller.isClockedIn.value
                        ? const Color(0xFFDC2626)
                        : _primaryBlue,
                    onPressed: () => controller.toggleClockIn(),
                  ),
                  const SizedBox(height: 6.3),
                  // Break
                  _FigmaButton(
                    label: controller.isOnBreak.value ? 'RESUME' : 'BREAK',
                    leadingIcon: Icons.pause_rounded,
                    backgroundColor: const Color(0xFF464646),
                    onPressed: () => controller.toggleBreak(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Small Figma-spec button used inside shift card ─────────────────────────
class _FigmaButton extends StatelessWidget {
  final String label;
  final IconData leadingIcon;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const _FigmaButton({
    required this.label,
    required this.leadingIcon,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 50.41,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(9.45),
          boxShadow: [
            BoxShadow(
              color: _primaryBlue.withValues(alpha: 0.20),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(leadingIcon, color: Colors.white, size: 18),
            const SizedBox(width: 6.3),
            Text(label, style: _interSemiBold(15.75, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

// ─── Weather Card ────────────────────────────────────────────────────────────
class _WeatherCard extends StatelessWidget {
  final VoidCallback onTap;
  const _WeatherCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 98,
        decoration: BoxDecoration(
          color: _surfaceWhite,
          borderRadius: BorderRadius.circular(18),
          boxShadow: _cardShadow(),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            // Weather Icon Box
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _weatherIconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.cloud_queue_rounded,
                color: _deepBlue,
                size: 26.67,
              ),
            ),
            const SizedBox(width: 16),
            // Text info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('6°C', style: _jakartaReg(20, color: _textDark)),
                      const SizedBox(width: 8),
                      Text(
                        'LIGHT RAIN',
                        style: _jakartaReg(
                          12,
                          color: _textSub,
                        ).copyWith(letterSpacing: 1.2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Site condition: Wet, slippery soil.',
                    style: _jakartaReg(13, color: _textMid),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF727784),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Today Card ──────────────────────────────────────────────────────────────
class _TodayCard extends StatelessWidget {
  final VoidCallback onTap;
  const _TodayCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        decoration: BoxDecoration(
          color: _surfaceWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
          boxShadow: _cardShadow(),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row: Title + Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                      color: _deepBlue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "TODAY'S SCHEDULE",
                      style: _jakartaReg(12, color: _textSub),
                    ),
                  ],
                ),
                // Pill badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _surfaceGrey,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    'Start 07:30',
                    style: _jakartaReg(12, color: _deepBlue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Jobs row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('4 Jobs today', style: _jakartaReg(16, color: _textDark)),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 11.77,
                  color: Color(0xFF727784),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // NEXT PRIORITY highlight
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _todayHighBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _todayHighBdr),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NEXT PRIORITY',
                    style: _jakartaReg(12, color: _deepBlue),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Zone A - Foundation Pour',
                    style: _jakartaReg(16, color: _deepBlue),
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

// ─── Progress Card ───────────────────────────────────────────────────────────
class _ProgressCard extends StatelessWidget {
  final VoidCallback onTap;
  const _ProgressCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _surfaceWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
          boxShadow: _cardShadow(),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Left: label + big value
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CURRENT PROGRESS',
                          style: _jakartaReg(12, color: _textSub),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '2 / 5 Tasks',
                          style: _jakartaReg(24, color: _textDark),
                        ),
                      ],
                    ),
                    // Right: percentage label
                    Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 4),
                      child: Text(
                        '40% Completed',
                        style: _jakartaReg(16, color: _deepBlue),
                      ),
                    ),
                  ],
                ),
                // Chevron arrow absolutely placed
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 11.77,
                  color: Color(0xFF727784),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 5-segment pill progress bar
            Row(
              children: List.generate(5, (i) {
                final filled = i < 2;
                return Expanded(
                  child: Container(
                    height: 12,
                    margin: EdgeInsets.only(right: i < 4 ? 6 : 0),
                    decoration: BoxDecoration(
                      color: filled ? _progressFill : _progressEmpty,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom Action Button ────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: _primaryBlue,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: _primaryBlue.withValues(alpha: 0.20),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
            ],
            Text(label, style: _jakartaReg(16, color: Colors.white)),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              Icon(trailingIcon, color: Colors.white, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}
