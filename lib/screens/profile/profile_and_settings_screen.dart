import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_card.dart';
import '../../core/routes/app_routes.dart';

class ProfileAndSettingsScreen extends StatelessWidget {
  const ProfileAndSettingsScreen({super.key});

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
            'PROFILE AND SETTINGS',
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
                // Avatar Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: PerfektTheme.primaryBlue,
                            width: 3,
                          ),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=300',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Jack Miller",
                        style: PerfektTheme.fontBold(
                          22,
                          color: PerfektTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Master Carpenter",
                        style: PerfektTheme.fontMedium(
                          14,
                          color: PerfektTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Personal Information
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Personal Information",
                      style: PerfektTheme.fontBold(
                        17,
                        color: PerfektTheme.textDark,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.snackbar(
                        "Edit Profile",
                        "Personal details edit form active.",
                        snackPosition: SnackPosition.TOP,
                      ),
                      child: Text(
                        "EDIT",
                        style: PerfektTheme.fontBold(
                          13,
                          color: PerfektTheme.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                PerfektCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow("FULL NAME", "Jack Miller"),
                      const Divider(height: 24, color: Color(0xFFF1F5F9)),
                      _buildInfoRow(
                        "EMAIL ADDRESS",
                        "j.miller@perfektwerk.com",
                      ),
                      const Divider(height: 24, color: Color(0xFFF1F5F9)),
                      _buildInfoRow("PHONE NUMBER", "+49 151 2345 6789"),
                      const Divider(height: 24, color: Color(0xFFF1F5F9)),
                      _buildInfoRow(
                        "EMERGENCY CONTACT",
                        "Sarah Miller (Wife) • +49 151 9876 5432",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),

                // Employment Section
                Text(
                  "Employment",
                  style: PerfektTheme.fontBold(
                    17,
                    color: PerfektTheme.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                PerfektCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.engineering_outlined,
                              color: PerfektTheme.primaryBlue,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ROLE",
                                  style: PerfektTheme.fontBold(
                                    11,
                                    color: PerfektTheme.textLight,
                                  ).copyWith(letterSpacing: 0.8),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Master Carpenter",
                                  style: PerfektTheme.fontBold(
                                    16,
                                    color: PerfektTheme.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoRow("EMPLOYEE ID", "PW-00402"),
                          ),
                          Expanded(
                            child: _buildInfoRow(
                              "COMPANY",
                              "PerfektWerk\nGmbH",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),

                // App Settings Button Tile
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.appPreferences),
                  child: PerfektCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: PerfektTheme.surfaceGrey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.settings_outlined,
                            color: PerfektTheme.textDark,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "App Settings",
                            style: PerfektTheme.fontBold(
                              16,
                              color: PerfektTheme.textDark,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: PerfektTheme.textLight,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Logout Tile
                GestureDetector(
                  onTap: () => Get.offAllNamed(AppRoutes.welcome),
                  child: PerfektCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            color: PerfektTheme.alertCritical,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "Logout",
                            style: PerfektTheme.fontBold(
                              16,
                              color: PerfektTheme.alertCritical,
                            ),
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: PerfektTheme.fontBold(
            11,
            color: PerfektTheme.textLight,
          ).copyWith(letterSpacing: 0.8),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: PerfektTheme.fontMedium(15, color: PerfektTheme.textDark),
        ),
      ],
    );
  }
}
