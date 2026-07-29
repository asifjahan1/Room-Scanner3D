import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../widgets/perfekt/perfekt_card.dart';
import '../../core/routes/app_routes.dart';

// ─── Figma-specific colors not in PerfektTheme ───────────────────────────────
const _bgPage = Color(0xFFF9F9FF);
const _deepBlue = Color(0xFF00418F);
const _textMid = Color(0xFF424753);
const _divider = Color(0xFFE2E8F0);
const _surfaceGrey = Color(0xFFE7E7F1);

// Done card
const _doneAccent = Color(0xFF22C55E);
const _doneBadgeBg = Color(0xFFDCFCE7);
const _doneBadgeFg = Color(0xFF166534);

// Live (In-progress) card
const _liveCardBg = Color(0x0D00418F); // rgba(0,65,143,0.05)
const _liveCardBdr = Color(0x3300418F); // rgba(0,65,143,0.20)

// ─── Screen ──────────────────────────────────────────────────────────────────
class MyDayTimelineScreen extends StatelessWidget {
  const MyDayTimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPage,
      body: SafeArea(
        child: Column(
          children: [
            _Header(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                child: _TimelineContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: _bgPage,
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          SizedBox(
            width: 56,
            height: 56,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: _deepBlue, size: 18.67),
              onPressed: () => Get.back(),
            ),
          ),
          // Title
          Text(
            'PLANS',
            style: PerfektTheme.fontBold(
              24,
              color: _deepBlue,
            ).copyWith(letterSpacing: 1.2),
          ),
          // Avatar
          SizedBox(
            width: 56,
            height: 56,
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1E2EB),
                  border: Border.all(color: PerfektTheme.primaryBlue, width: 2),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=250',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.person, size: 20, color: _deepBlue),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Full Timeline ────────────────────────────────────────────────────────────
class _TimelineContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Card 1 – DONE
        _TimelineCard(
          time: '07:30',
          title: 'Travel to site',
          subtitle: 'Zone A',
          status: _TaskStatus.done,
          showDividerBelow: true,
          nodeChild: _DoneNode(),
        ),
        const SizedBox(height: 24),

        // Card 2 – IN PROGRESS (LIVE)
        _TimelineCard(
          time: '08:00',
          title: 'Install wall framing',
          subtitle: 'Main Hall',
          status: _TaskStatus.live,
          showDividerBelow: true,
          showMapButton: true,
          nodeChild: _LiveNode(),
        ),
        const SizedBox(height: 16),

        // "Open Next Task" button — offset to align with card column
        Padding(
          padding: const EdgeInsets.only(left: 72),
          child: PerfektButton(
            label: 'Open Next Task',
            trailingIcon: Icons.arrow_forward_rounded,
            height: 56,
            fontSize: 16,
            onPressed: () => Get.toNamed(AppRoutes.taskDetail),
          ),
        ),
        const SizedBox(height: 24),

        // Card 3 – UPCOMING (with outlined map button)
        _TimelineCard(
          time: '11:30',
          title: 'Measure kitchen wall',
          subtitle: 'Kitchen B',
          status: _TaskStatus.upcoming,
          showDividerBelow: true,
          showMapButton: true,
          mapButtonOutlined: true,
          nodeChild: _UpcomingNode(icon: Icons.schedule_rounded),
        ),
        const SizedBox(height: 24),

        // Card 4 – no badge, no map button
        _TimelineCard(
          time: '14:00',
          title: 'Progress update',
          subtitle: 'Site-wide',
          status: _TaskStatus.none,
          showDividerBelow: false,
          nodeChild: _UpcomingNode(icon: Icons.bar_chart_rounded),
        ),
      ],
    );
  }
}

// ─── Task Status Enum ─────────────────────────────────────────────────────────
enum _TaskStatus { done, live, upcoming, none }

// ─── Timeline Card ────────────────────────────────────────────────────────────
class _TimelineCard extends StatelessWidget {
  final String time;
  final String title;
  final String subtitle;
  final _TaskStatus status;
  final bool showDividerBelow;
  final bool showMapButton;
  final bool mapButtonOutlined;
  final Widget nodeChild;

  const _TimelineCard({
    required this.time,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.showDividerBelow,
    required this.nodeChild,
    this.showMapButton = false,
    this.mapButtonOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Vertical connector line below node
        if (showDividerBelow)
          Positioned(
            left: 27,
            top: 56,
            bottom: -24,
            child: Container(width: 2, color: _divider),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(width: 56, child: nodeChild),
            ),
            const SizedBox(width: 16),
            Expanded(child: _buildCardContent()),
          ],
        ),
      ],
    );
  }

  Widget _buildCardContent() {
    // Done card: ClipRRect handles the radius; inner Row provides the green left accent.
    // Flutter does NOT allow borderRadius + non-uniform border colors in BoxDecoration.
    if (status == _TaskStatus.done) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: PerfektTheme.cardShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: IntrinsicHeight(
            child: Container(
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left green accent bar — stretches to card height via IntrinsicHeight
                  Container(width: 4, color: _doneAccent),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: _cardBody(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (status == _TaskStatus.live) {
      return Container(
        decoration: BoxDecoration(
          color: _liveCardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _liveCardBdr, width: 2),
          boxShadow: PerfektTheme.cardShadow,
        ),
        padding: const EdgeInsets.all(20),
        child: _cardBody(),
      );
    }

    // Upcoming / None — use PerfektCard
    return PerfektCard(
      borderRadius: BorderRadius.circular(18),
      borderColor: Colors.transparent,
      child: _cardBody(),
    );
  }

  Widget _cardBody() {
    final timeColor = status == _TaskStatus.live ? _deepBlue : _textMid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time + badge row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time,
              style: PerfektTheme.fontBold(
                14,
                color: timeColor,
              ).copyWith(letterSpacing: 0.7),
            ),
            if (status != _TaskStatus.none) _buildBadge(),
          ],
        ),
        const SizedBox(height: 4),
        // Title
        Text(
          title,
          style: PerfektTheme.fontSemiBold(20, color: PerfektTheme.textDark),
        ),
        const SizedBox(height: 4),
        // Subtitle + optional map button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 9.33,
                  color: PerfektTheme.textMedium,
                ),
                const SizedBox(width: 4),
                Text(
                  subtitle,
                  style: PerfektTheme.fontRegular(
                    14,
                    color: PerfektTheme.textMedium,
                  ),
                ),
              ],
            ),
            if (showMapButton) _buildMapButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge() {
    switch (status) {
      case _TaskStatus.done:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _doneBadgeBg,
            borderRadius: PerfektTheme.radiusPill,
          ),
          child: Text(
            'DONE',
            style: PerfektTheme.fontBold(
              12,
              color: _doneBadgeFg,
            ).copyWith(letterSpacing: 0.6),
          ),
        );
      case _TaskStatus.live:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _deepBlue,
            borderRadius: PerfektTheme.radiusPill,
          ),
          child: Text(
            'LIVE',
            style: PerfektTheme.fontBold(
              12,
              color: Colors.white,
            ).copyWith(letterSpacing: 0.6),
          ),
        );
      case _TaskStatus.upcoming:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _surfaceGrey,
            borderRadius: PerfektTheme.radiusPill,
          ),
          child: Text(
            'UPCOMING',
            style: PerfektTheme.fontBold(
              12,
              color: _textMid,
            ).copyWith(letterSpacing: 0.6),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMapButton() {
    if (mapButtonOutlined) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: PerfektTheme.borderLight),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.map_outlined,
          size: 18,
          color: PerfektTheme.textMedium,
        ),
      );
    }
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _surfaceGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.map_outlined, size: 18, color: _deepBlue),
    );
  }
}

// ─── Node Widgets ─────────────────────────────────────────────────────────────

class _DoneNode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: _bgPage, width: 4),
              boxShadow: PerfektTheme.cardShadow,
            ),
          ),
          Icon(
            Icons.check_circle_rounded,
            color: PerfektTheme.successGreen,
            size: 21.7,
          ),
        ],
      ),
    );
  }
}

class _LiveNode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: PerfektTheme.primaryBlue,
              shape: BoxShape.circle,
              boxShadow: PerfektTheme.buttonShadow,
            ),
          ),
          const Icon(
            Icons.engineering_rounded,
            color: Colors.white,
            size: 21.9,
          ),
        ],
      ),
    );
  }
}

class _UpcomingNode extends StatelessWidget {
  final IconData icon;
  const _UpcomingNode({required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: _bgPage, width: 4),
              boxShadow: PerfektTheme.cardShadow,
            ),
          ),
          Icon(icon, color: PerfektTheme.textMedium, size: 20),
        ],
      ),
    );
  }
}
