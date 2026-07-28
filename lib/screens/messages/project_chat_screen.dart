import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';

class ChatMessage {
  final String sender;
  final String role;
  final String time;
  final String content;
  final String? mention;
  final String? imageUrl;
  final bool isHighlightBorder;
  final bool isMe;

  ChatMessage({
    required this.sender,
    required this.role,
    required this.time,
    required this.content,
    this.mention,
    this.imageUrl,
    this.isHighlightBorder = false,
    this.isMe = false,
  });
}

class ProjectChatController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final RxList<ChatMessage> messages = <ChatMessage>[
    ChatMessage(
      sender: "Marcus",
      role: "Electrician",
      time: "08:42 AM",
      content:
          "The wiring for the 4th floor lobby is completed. Ready for inspection tomorrow morning.",
    ),
    ChatMessage(
      sender: "James Miller",
      role: "Foreman",
      time: "09:15 AM",
      mention: "@Marcus ",
      content:
          "Great progress. Please double check the load distribution on panel B before the inspection. See attached reference from the site map.",
      imageUrl:
          'https://images.unsplash.com/photo-1581092580497-e0d23cbdf1dc?auto=format&fit=crop&q=80&w=600',
      isHighlightBorder: true,
    ),
  ].obs;

  void sendMessage() {
    final text = textController.text.trim();
    if (text.isNotEmpty) {
      messages.add(
        ChatMessage(
          sender: "You",
          role: "Engineer",
          time: "Just now",
          content: text,
          isMe: true,
        ),
      );
      textController.clear();
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}

class ProjectChatScreen extends StatelessWidget {
  const ProjectChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectChatController());

    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: PerfektTheme.backgroundLight,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          shadowColor: Colors.black.withValues(alpha: 0.05),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: PerfektTheme.primaryBlue,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Skyline Apartments – Site A',
            style: PerfektTheme.fontBold(17, color: PerfektTheme.primaryBlue),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    itemCount: controller.messages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Center(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: PerfektTheme.surfaceGrey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "TODAY",
                              style: PerfektTheme.fontBold(
                                11,
                                color: PerfektTheme.textMedium,
                              ).copyWith(letterSpacing: 0.8),
                            ),
                          ),
                        );
                      }
                      final msg = controller.messages[index - 1];
                      return _buildMessageItem(msg);
                    },
                  ),
                ),
              ),
              _buildBottomControls(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: msg.isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // Sender (Role) label
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              "${msg.sender} (${msg.role})",
              style: PerfektTheme.fontBold(
                12,
                color: msg.isHighlightBorder
                    ? PerfektTheme.primaryBlue
                    : PerfektTheme.textMedium,
              ),
            ),
          ),

          // Message Bubble Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: msg.isHighlightBorder
                    ? PerfektTheme.primaryBlue
                    : PerfektTheme.borderLight,
                width: msg.isHighlightBorder ? 2.0 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      if (msg.mention != null)
                        TextSpan(
                          text: msg.mention,
                          style: PerfektTheme.fontBold(
                            15,
                            color: PerfektTheme.primaryBlue,
                          ),
                        ),
                      TextSpan(
                        text: msg.content,
                        style: PerfektTheme.fontMedium(
                          15,
                          color: PerfektTheme.textDark,
                        ).copyWith(height: 1.4),
                      ),
                    ],
                  ),
                ),
                if (msg.imageUrl != null) ...[
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      msg.imageUrl!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Timestamp below bubble
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Text(
              msg.time,
              style: PerfektTheme.fontMedium(11, color: PerfektTheme.textLight),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(ProjectChatController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: PerfektTheme.borderLight)),
      ),
      child: Column(
        children: [
          // Row with Attachment Icon Squares & Send Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildIconButton(
                    icon: Icons.camera_alt_outlined,
                    onTap: () => Get.snackbar(
                      "Camera",
                      "Instant site capture ready.",
                      snackPosition: SnackPosition.TOP,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _buildIconButton(
                    icon: Icons.attach_file_rounded,
                    onTap: () => Get.snackbar(
                      "Attachments",
                      "Cloud folder integration active.",
                      snackPosition: SnackPosition.TOP,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: controller.sendMessage,
                child: Container(
                  width: 48,
                  height: 44,
                  decoration: BoxDecoration(
                    color: PerfektTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: PerfektTheme.primaryBlue.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Text Input Box Capsule
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: PerfektTheme.borderLight),
            ),
            child: TextField(
              controller: controller.textController,
              style: PerfektTheme.fontMedium(15, color: PerfektTheme.textDark),
              decoration: InputDecoration(
                hintText: "Type a message or @mention...",
                hintStyle: PerfektTheme.fontRegular(
                  14,
                  color: PerfektTheme.textLight,
                ),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => controller.sendMessage(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Icon(icon, color: PerfektTheme.primaryBlue, size: 22),
        ),
      ),
    );
  }
}
