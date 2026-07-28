import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_card.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../core/routes/app_routes.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

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
              color: PerfektTheme.textDark,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Task Detail',
            style: PerfektTheme.fontBold(18, color: PerfektTheme.textDark),
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PerfektTheme.surfaceGrey,
                  border: Border.all(
                    color: PerfektTheme.primaryBlue,
                    width: 1.5,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=250',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Progress Gauge Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Install Wall Framing",
                            style: PerfektTheme.fontBold(
                              24,
                              color: PerfektTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 15,
                                color: PerfektTheme.textMedium,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Sector C – Room 104",
                                style: PerfektTheme.fontMedium(
                                  14,
                                  color: PerfektTheme.textMedium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // 65% Circle Badge
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: PerfektTheme.primaryBlue,
                          width: 4.5,
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: PerfektTheme.primaryBlue.withValues(
                              alpha: 0.15,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "65%",
                          style: PerfektTheme.fontBold(
                            13,
                            color: PerfektTheme.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Instruction Advisory Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: PerfektTheme.radiusCard,
                    border: const Border(
                      left: BorderSide(
                        color: PerfektTheme.primaryBlue,
                        width: 4,
                      ),
                      top: BorderSide(color: PerfektTheme.borderLight),
                      right: BorderSide(color: PerfektTheme.borderLight),
                      bottom: BorderSide(color: PerfektTheme.borderLight),
                    ),
                    boxShadow: PerfektTheme.cardShadow,
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.assignment_ind_outlined,
                          color: PerfektTheme.primaryBlue,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "INSTRUCTION",
                              style: PerfektTheme.fontBold(
                                11,
                                color: PerfektTheme.primaryBlue,
                              ).copyWith(letterSpacing: 1.0),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Verify stud spacing at 40cm and secure top plate before continuing.",
                              style: PerfektTheme.fontRegular(
                                14,
                                color: PerfektTheme.textDark,
                              ).copyWith(height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Add Photo & Add Update Row
                Row(
                  children: [
                    Expanded(
                      child: _buildActionTile(
                        icon: Icons.camera_alt_outlined,
                        label: "ADD PHOTO",
                        onTap: () => Get.toNamed(AppRoutes.offlineWork),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildActionTile(
                        icon: Icons.mic_none_rounded,
                        label: "ADD UPDATE",
                        onTap: () => Get.toNamed(AppRoutes.updateProgress),
                        isHighlight: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Transcribed Note Card
                PerfektCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.description_outlined,
                                size: 18,
                                color: PerfektTheme.textLight,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "TRANSCRIBED NOTE",
                                style: PerfektTheme.fontBold(
                                  11,
                                  color: PerfektTheme.textLight,
                                ).copyWith(letterSpacing: 0.8),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => Get.toNamed(AppRoutes.voiceUpdate),
                            child: Text(
                              "Edit",
                              style: PerfektTheme.fontBold(
                                13,
                                color: PerfektTheme.primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '"Wall framing 65% complete. Waiting for more studs."',
                        style: PerfektTheme.fontMedium(
                          14,
                          color: PerfektTheme.textDark,
                        ).copyWith(fontStyle: FontStyle.italic, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Attached Plans Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Attached Plans",
                      style: PerfektTheme.fontBold(
                        16,
                        color: PerfektTheme.textDark,
                      ),
                    ),
                    Text(
                      "VIEW ALL",
                      style: PerfektTheme.fontBold(
                        11,
                        color: PerfektTheme.primaryBlue,
                      ).copyWith(letterSpacing: 0.8),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Attached Plan Thumbnails
                Row(
                  children: [
                    Expanded(
                      child: _buildPlanThumbnail(
                        imageUrl:
                            'https://images.unsplash.com/photo-1503387762-592deb58ef4e?auto=format&fit=crop&q=80&w=400',
                        caption: '3D Cad Plan',
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildPlanThumbnail(
                        imageUrl:
                            'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?auto=format&fit=crop&q=80&w=400',
                        caption: 'Wall Frame Studs',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Start Work Button
                PerfektButton(
                  label: "Start Work",
                  icon: Icons.play_arrow_rounded,
                  height: 52,
                  fontSize: 16,
                  onPressed: () => Get.toNamed(AppRoutes.offlineWork),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isHighlight = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isHighlight ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: PerfektTheme.radiusCard,
          border: Border.all(
            color: isHighlight
                ? PerfektTheme.primaryBlue
                : PerfektTheme.borderLight,
            width: isHighlight ? 1.5 : 1.0,
          ),
          boxShadow: PerfektTheme.cardShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: PerfektTheme.primaryBlue, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: PerfektTheme.fontBold(
                12,
                color: PerfektTheme.primaryBlue,
              ).copyWith(letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanThumbnail({
    required String imageUrl,
    required String caption,
  }) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: PerfektTheme.surfaceGrey,
        borderRadius: PerfektTheme.radiusCard,
        border: Border.all(color: PerfektTheme.borderLight),
        boxShadow: PerfektTheme.cardShadow,
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: PerfektTheme.radiusCard,
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withValues(alpha: 0.5), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.bottomLeft,
        child: Text(
          caption,
          style: PerfektTheme.fontSemiBold(12, color: Colors.white),
        ),
      ),
    );
  }
}
