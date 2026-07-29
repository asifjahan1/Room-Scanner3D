import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      body: SafeArea(
        child: Column(
          children: [
            // Header - Top AppBar
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xFFF9F9FF),
                border: Border(
                  bottom: BorderSide(
                    color: Color(0x0D191B22),
                  ), // rgba(25, 27, 34, 0.05)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0A000000), // rgba(0, 0, 0, 0.04)
                    offset: Offset(0, 8),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: Color(0xFF00418F),
                    size: 25,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Messages",
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Color(0xFF00418F),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Communications Section
                    const Text(
                      "SEARCH COMMUNICATIONS",
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 0.7,
                        color: Color(0xFF5C5F61),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000),
                            offset: Offset(0, 1),
                            blurRadius: 1,
                          ),
                          BoxShadow(
                            color: Color(0x0A000000),
                            offset: Offset(0, 8),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            color: Color(0xFF727784),
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Search by project or user...",
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Pinned Announcements Section
                    Row(
                      children: const [
                        Icon(
                          Icons.push_pin_rounded,
                          color: Color(0xFF5C5F61),
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "PINNED ANNOUNCEMENTS",
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            letterSpacing: 1.4,
                            color: Color(0xFF5C5F61),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildPinnedAnnouncementCard(),
                    const SizedBox(height: 32),

                    // Recent Activity Section
                    const Text(
                      "RECENT ACTIVITY",
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 1.4,
                        color: Color(0xFF5C5F61),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Chat Item 1: Skyline Apartments
                    _buildChatCard(
                      avatar: _buildImageAvatar(
                        'https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&q=80&w=200',
                        isOnline: true,
                      ),
                      title: "Skyline Apartmer", // Trimmed in design
                      time: "2m\nago",
                      unreadCount: 12,
                      onTap: () => Get.toNamed(AppRoutes.projectChat),
                      subtitle: RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Marcus: ",
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xFF00418F),
                              ),
                            ),
                            TextSpan(
                              text: "Concrete truck i", // Trimmed in design
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Color(0xFF424753),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Chat Item 2: Electrical Team
                    _buildChatCard(
                      avatar: _buildIconAvatar(Icons.engineering_outlined),
                      title: "Electrical Team - F",
                      time: "1h\nago",
                      isReadReceipt: true,
                      onTap: () {},
                      subtitle: const Text(
                        "You: Wiring diagrams\nare in the cloud folder.",
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          height: 1.44,
                          color: Color(0xFF5C5F61),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Chat Item 3: Heritage Restoration
                    _buildChatCard(
                      avatar: _buildImageAvatar(
                        'https://images.unsplash.com/photo-1503387762-592deb58ef4e?auto=format&fit=crop&q=80&w=200',
                      ),
                      title: "Heritage Resto",
                      time: "Yesterday",
                      unreadCount: 1,
                      onTap: () {},
                      subtitle: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0x1A782C00,
                              ), // rgba(120, 44, 0, 0.1)
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: const Text(
                              "NEW\nDOCUMENT",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w400,
                                fontSize: 8,
                                height: 1.5,
                                color: Color(0xFF782C00),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              "Structure_Re",
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Color(0xFF424753),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Chat Item 4: Maintenance Log
                    _buildChatCard(
                      avatar: _buildIconAvatar(Icons.build_outlined),
                      title: "Maintenance Log",
                      time: "Oct 12",
                      onTap: () {},
                      subtitle: const Text(
                        "Crane #4 inspection\npassed.",
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          height: 1.44,
                          color: Color(0xFF424753),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

  Widget _buildPinnedAnnouncementCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left Blue Accent Line
            Container(
              width: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF0058BC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 20, 16, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD8E2FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.campaign_rounded,
                          color: Color(0xFFADC6FF),
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  "Safety Announ",
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: Color(0xFF191B22),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "08:30 AM",
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Color(0xFF5C5F61),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF0058BC),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "3",
                                        style: TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "New high-vis\nrequirements for\nZone B starting\nMonday morning.",
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              height: 1.44, // 26px line-height
                              color: Color(0xFF424753),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildTag(
                                "PRIORITY",
                                const Color(0xFFFFDAD6),
                                const Color(0xFF93000A),
                              ),
                              const SizedBox(width: 8),
                              _buildTag(
                                "ACTIVE",
                                const Color(0x1A00418F),
                                const Color(0xFF00418F),
                              ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w400,
          fontSize: 10,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildImageAvatar(String url, {bool isOnline = false}) {
    return Stack(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
          ),
        ),
        if (isOnline)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
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
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFE1E2EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(icon, color: const Color(0xFF5C5F61), size: 26),
      ),
    );
  }

  Widget _buildChatCard({
    required Widget avatar,
    required String title,
    required String time,
    required Widget subtitle,
    required VoidCallback onTap,
    int unreadCount = 0,
    bool isReadReceipt = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0x0D000000),
          ), // rgba(0,0,0, 0.05)
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              offset: Offset(0, 1),
              blurRadius: 1,
            ),
            BoxShadow(
              color: Color(0x0A000000),
              offset: Offset(0, 8),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            avatar,
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Color(0xFF191B22),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            time,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF5C5F61),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (unreadCount > 0)
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0058BC),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  "$unreadCount",
                                  style: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          else if (isReadReceipt)
                            const Icon(
                              Icons.done_all_rounded,
                              color: Color(0xFF727784),
                              size: 18,
                            ),
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
