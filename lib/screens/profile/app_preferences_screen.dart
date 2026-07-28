import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_card.dart';
import '../../core/routes/app_routes.dart';

class AppPreferencesScreen extends StatelessWidget {
  const AppPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: PerfektTheme.backgroundLight,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: PerfektTheme.primaryBlue,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'APP SETTINGS',
            style: PerfektTheme.fontBold(
              16,
              color: PerfektTheme.primaryBlue,
            ).copyWith(letterSpacing: 1.0),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Global Preferences
                Text(
                  "Global Preferences",
                  style: PerfektTheme.fontBold(
                    18,
                    color: PerfektTheme.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                PerfektCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.notifications_active_outlined,
                        title: "Notifications",
                        subtitle: "Push, Operational",
                        onTap: () =>
                            Get.toNamed(AppRoutes.notificationPreferences),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.lock_outline_rounded,
                        title: "Security",
                        subtitle: "Password & Account Protection",
                        onTap: () => Get.toNamed(AppRoutes.securitySettings),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.language_rounded,
                        title: "Language",
                        subtitle: "English (UK), German",
                        onTap: () => Get.toNamed(AppRoutes.languageSettings),
                      ),
                      _buildDivider(),
                      // Link to Core LiDAR Scanner Configuration
                      _buildMenuItem(
                        icon: Icons.radar_outlined,
                        title: "3D LiDAR Scanner Config",
                        subtitle: "Original point cloud & mesh parameter setup",
                        onTap: () => Get.toNamed(AppRoutes.settings),
                        isSpecial: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Legal & Compliance
                Text(
                  "LEGAL & COMPLIANCE",
                  style: PerfektTheme.fontBold(
                    13,
                    color: PerfektTheme.textMedium,
                  ).copyWith(letterSpacing: 0.8),
                ),
                const SizedBox(height: 10),
                PerfektCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.privacy_tip_outlined,
                        title: "Privacy Policy",
                        onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.article_outlined,
                        title: "Terms of Use",
                        onTap: () => Get.toNamed(AppRoutes.termsOfUse),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.domain_verification_outlined,
                        title: "Impressum",
                        onTap: () => Get.toNamed(AppRoutes.impressum),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.security_rounded,
                        title: "Permissions",
                        onTap: () => Get.toNamed(AppRoutes.devicePermissions),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Data & Account
                Text(
                  "DATA & ACCOUNT",
                  style: PerfektTheme.fontBold(
                    13,
                    color: PerfektTheme.textMedium,
                  ).copyWith(letterSpacing: 0.8),
                ),
                const SizedBox(height: 10),
                PerfektCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.download_rounded,
                        title: "Data Export",
                        onTap: () => Get.toNamed(AppRoutes.dataExport),
                      ),
                      _buildDivider(),
                      InkWell(
                        onTap: () {
                          Get.defaultDialog(
                            title: "Delete Account",
                            titleStyle: PerfektTheme.fontBold(
                              18,
                              color: PerfektTheme.alertCritical,
                            ),
                            middleText:
                                "Are you sure you want to permanently delete your account and project logs?",
                            middleTextStyle: PerfektTheme.fontRegular(
                              14,
                              color: PerfektTheme.textDark,
                            ),
                            textConfirm: "Delete",
                            confirmTextColor: Colors.white,
                            buttonColor: PerfektTheme.alertCritical,
                            textCancel: "Cancel",
                            cancelTextColor: PerfektTheme.textMedium,
                            onConfirm: () => Get.offAllNamed(AppRoutes.welcome),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete_outline_rounded,
                                color: PerfektTheme.alertCritical,
                                size: 22,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                "Delete Account",
                                style: PerfektTheme.fontBold(
                                  16,
                                  color: PerfektTheme.alertCritical,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isSpecial = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSpecial
                  ? PerfektTheme.primaryBlue
                  : PerfektTheme.textDark,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: PerfektTheme.fontBold(
                      16,
                      color: isSpecial
                          ? PerfektTheme.primaryBlue
                          : PerfektTheme.textDark,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: PerfektTheme.fontRegular(
                        12,
                        color: PerfektTheme.textMedium,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: PerfektTheme.textLight,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9));
  }
}
