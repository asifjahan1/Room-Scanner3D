import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/perfekt_theme.dart';
import '../../../../core/routes/app_routes.dart';

class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.chat_bubble_outline_rounded, color: PerfektTheme.primaryBlue, size: 26),
                const SizedBox(width: 10),
                Text(
                  "Messages",
                  style: PerfektTheme.fontBold(24, color: PerfektTheme.primaryBlue),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // SEARCH COMMUNICATIONS
            Text(
              "SEARCH COMMUNICATIONS",
              style: PerfektTheme.fontBold(11, color: PerfektTheme.textLight).copyWith(letterSpacing: 1.0),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: PerfektTheme.radiusCard,
                border: Border.all(color: PerfektTheme.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, color: PerfektTheme.textLight, size: 22),
                  const SizedBox(width: 12),
                  Text(
                    "Search by project or user...",
                    style: PerfektTheme.fontRegular(14, color: PerfektTheme.textMedium),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // PINNED ANNOUNCEMENTS
            Row(
              children: [
                Icon(Icons.push_pin_rounded, color: PerfektTheme.textMedium, size: 14),
                const SizedBox(width: 6),
                Text(
                  "PINNED ANNOUNCEMENTS",
                  style: PerfektTheme.fontBold(11, color: PerfektTheme.textMedium).copyWith(letterSpacing: 1.0),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPinnedAnnouncementCard(),
            const SizedBox(height: 26),

            // RECENT ACTIVITY
            Text(
              "RECENT ACTIVITY",
              style: PerfektTheme.fontBold(11, color: PerfektTheme.textLight).copyWith(letterSpacing: 1.0),
            ),
            const SizedBox(height: 12),

            // Activity 1: Skyline Apartments
            _buildActivityItem(
              title: "Skyline Apartments - Site A",
              time: "2m ago",
              unreadCount: 12,
              onTap: () => Get.toNamed(AppRoutes.projectChat),
              avatar: _buildImageAvatar('https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&q=80&w=200', true),
              subtitle: RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: [
                    TextSpan(text: "Marcus: ", style: PerfektTheme.fontBold(13, color: PerfektTheme.primaryBlue)),
                    TextSpan(text: "Concrete truck is ready at entrance...", style: PerfektTheme.fontRegular(13, color: PerfektTheme.textDark)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Activity 2: Electrical Team - Floor 4
            _buildActivityItem(
              title: "Electrical Team - Floor 4",
              time: "1h ago",
              isReadReceipt: true,
              onTap: () => Get.snackbar("Electrical Team", "No unread messages.", snackPosition: SnackPosition.BOTTOM),
              avatar: _buildIconAvatar(Icons.engineering_outlined),
              subtitle: Text(
                "You: Wiring diagrams are in the cloud folder.",
                style: PerfektTheme.fontMedium(13, color: PerfektTheme.textMedium).copyWith(fontStyle: FontStyle.italic),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),

            // Activity 3: Heritage Restoration Project
            _buildActivityItem(
              title: "Heritage Restoration Project",
              time: "Yesterday",
              unreadCount: 1,
              onTap: () => Get.snackbar("Heritage Restoration", "Document download ready.", snackPosition: SnackPosition.BOTTOM),
              avatar: _buildImageAvatar('https://images.unsplash.com/photo-1503387762-592deb58ef4e?auto=format&fit=crop&q=80&w=200', false),
              subtitle: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text("NEW DOCUMENT", style: PerfektTheme.fontBold(9, color: const Color(0xFFD97706))),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Structure_Report_v2.pdf",
                      style: PerfektTheme.fontMedium(13, color: PerfektTheme.textDark),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Activity 4: Maintenance Log - Equipment
            _buildActivityItem(
              title: "Maintenance Log - Equipment",
              time: "Oct 12",
              onTap: () => Get.snackbar("Maintenance Log", "Crane #4 inspection passed.", snackPosition: SnackPosition.BOTTOM),
              avatar: _buildIconAvatar(Icons.build_outlined),
              subtitle: Text(
                "Crane #4 inspection passed.",
                style: PerfektTheme.fontMedium(13, color: PerfektTheme.textDark),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPinnedAnnouncementCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: PerfektTheme.radiusCard,
        border: Border.all(color: PerfektTheme.borderLight),
        boxShadow: PerfektTheme.cardShadow,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 5,
              decoration: const BoxDecoration(
                color: PerfektTheme.primaryBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.campaign_outlined, color: PerfektTheme.primaryBlue, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Safety Announcement",
                                style: PerfektTheme.fontBold(16, color: PerfektTheme.textDark),
                              ),
                              Row(
                                children: [
                                  Text("08:30 AM", style: PerfektTheme.fontMedium(11, color: PerfektTheme.textLight)),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: PerfektTheme.primaryBlue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text("3", style: PerfektTheme.fontBold(11, color: Colors.white)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "New high-vis requirements for Zone B starting Monday morning.",
                            style: PerfektTheme.fontMedium(13, color: PerfektTheme.textDark),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildTag("PRIORITY", const Color(0xFFFEE2E2), const Color(0xFFDC2626)),
                              const SizedBox(width: 8),
                              _buildTag("ACTIVE", const Color(0xFFDBEAFE), const Color(0xFF2563EB)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: PerfektTheme.fontBold(10, color: textColor),
      ),
    );
  }

  Widget _buildImageAvatar(String url, bool isOnline) {
    return Stack(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIconAvatar(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: PerfektTheme.surfaceGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(icon, color: PerfektTheme.textDark, size: 24),
      ),
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String time,
    required Widget avatar,
    required Widget subtitle,
    required VoidCallback onTap,
    int unreadCount = 0,
    bool isReadReceipt = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: PerfektTheme.radiusCard,
          border: Border.all(color: PerfektTheme.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            avatar,
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: PerfektTheme.fontBold(15, color: PerfektTheme.textDark)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(time, style: PerfektTheme.fontMedium(11, color: PerfektTheme.textLight)),
                          const SizedBox(height: 4),
                          if (unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: PerfektTheme.primaryBlue,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "$unreadCount",
                                style: PerfektTheme.fontBold(11, color: Colors.white),
                              ),
                            )
                          else if (isReadReceipt)
                            const Icon(Icons.done_all_rounded, color: PerfektTheme.textLight, size: 16),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  subtitle,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
