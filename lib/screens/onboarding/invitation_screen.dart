import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../controllers/auth_controller.dart';

class InvitationScreen extends StatelessWidget {
  const InvitationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: PerfektTheme.backgroundLight,
      ),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                // Verified company icon emblem
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: PerfektTheme.borderLight, width: 1.5),
                        boxShadow: PerfektTheme.cardShadow,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.apartment_rounded,
                          size: 38,
                          color: PerfektTheme.textDark,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: PerfektTheme.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Title and description
                Text(
                  "You've been\ninvited to join\nSteinMetz\nConstruction",
                  textAlign: TextAlign.center,
                  style: PerfektTheme.fontBold(30, color: PerfektTheme.textDark).copyWith(
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Access the centralized project management ecosystem for upcoming infrastructure and commercial developments.",
                    textAlign: TextAlign.center,
                    style: PerfektTheme.fontRegular(14, color: PerfektTheme.textMedium).copyWith(
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                // Assigned Role Card
                Text(
                  "ASSIGNED ROLE",
                  style: PerfektTheme.fontSemiBold(11, color: PerfektTheme.textMedium).copyWith(
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: PerfektTheme.surfaceGrey,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: PerfektTheme.borderLight),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: PerfektTheme.primaryBlue,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: PerfektTheme.buttonShadow,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.engineering_rounded, color: Colors.white, size: 22),
                        const SizedBox(width: 10),
                        Text(
                          "Worker",
                          style: PerfektTheme.fontSemiBold(16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                // Expiry timer notice
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer_outlined, size: 16, color: PerfektTheme.alertCritical),
                    const SizedBox(width: 6),
                    Text(
                      "Invitation expires in 48 hours",
                      style: PerfektTheme.fontSemiBold(13, color: PerfektTheme.alertCritical),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Actions
                PerfektButton(
                  label: "Accept Invitation",
                  height: 54,
                  fontSize: 16,
                  onPressed: () => auth.acceptInvitation(),
                ),
                const SizedBox(height: 12),
                PerfektButton(
                  label: "Decline",
                  type: PerfektButtonType.outline,
                  height: 54,
                  fontSize: 16,
                  onPressed: () => auth.declineInvitation(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
