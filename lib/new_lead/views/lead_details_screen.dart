import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liddar/new_lead/controller/lead_details_controller.dart';

class LeadDetailsScreen extends StatelessWidget {
  final LeadDetailsController controller = Get.put(LeadDetailsController());

  LeadDetailsScreen({super.key});

  // Reusable text styles based on the design specs
  final TextStyle headerStyle = const TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontWeight: FontWeight.w700,
    fontSize: 24,
    color: Color(0xFF00418F),
    letterSpacing: 1.2,
  );

  final TextStyle labelStyle = const TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontWeight: FontWeight.w700,
    fontSize: 14,
    color: Color(0xFF727784),
    letterSpacing: 0.7,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FF),
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF00418F)),
          onPressed: () => Get.back(),
        ),
        title: Text('LEAD DETAILS', style: headerStyle),
        titleSpacing: 0,
      ),
      body: Stack(
        children: [
          // Scrollable Body Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 24,
              bottom: 130, // Padding for bottom fixed bar
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVoiceMemoSection(),
                const SizedBox(height: 24),
                _buildDetailedNotesSection(),
                const SizedBox(height: 24),
                _buildAttachmentsSection(),
                const SizedBox(height: 24),
                _buildPrivacySection(),
              ],
            ),
          ),

          // Fixed Bottom Action Bar
          Positioned(left: 0, right: 0, bottom: 0, child: _buildBottomBar()),
        ],
      ),
    );
  }

  Widget _buildVoiceMemoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text('VOICE MEMO', style: labelStyle),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: controller.toggleRecording,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0058BC).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mic,
                    color: Color(0xFF0058BC),
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tap to Record',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Color(0xFF191B22),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Describe the site or lead details verbally',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xFF727784),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text('DETAILED NOTES', style: labelStyle),
        ),
        Container(
          width: double.infinity,
          height: 168,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black.withOpacity(0.02)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: TextField(
            controller: controller.notesController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText:
                  'Enter lead specific requirements,\nsite conditions, or special\nrequests...',
              hintStyle: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: const Color(0xFF727784).withOpacity(0.5),
                height: 1.4,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text('ATTACHMENTS', style: labelStyle),
        ),
        Row(
          children: [
            Expanded(child: _buildAddPhotoTrigger()),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(
                () => controller.showPhoto.value
                    ? _buildPhotoPreview()
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddPhotoTrigger() {
    return Container(
      height: 167,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFFEDEDF6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: Color(0xFF0058BC),
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Add Photo',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color(0xFF0058BC),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPreview() {
    return Container(
      height: 167,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.02)),
        image: const DecorationImage(
          image: AssetImage('assets/images/welcome_logo.png'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: controller.removePhoto,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                  child: Container(
                    width: 32,
                    height: 32,
                    color: Colors.black.withOpacity(0.4),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.02)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => CupertinoSwitch(
              value: controller.isPrivacyAccepted.value,
              onChanged: controller.togglePrivacy,
              activeColor: const Color(0xFF0058BC),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "I confirm that I have the customer's permission to collect and store this information in accordance with site safety and privacy protocols.",
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF424753),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9FF).withOpacity(0.9),
            border: Border(
              top: BorderSide(color: const Color(0xFFC2C6D5).withOpacity(0.1)),
            ),
          ),
          child: ElevatedButton(
            onPressed: controller.submitLead,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0058BC),
              minimumSize: const Size(double.infinity, 64),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              shadowColor: const Color(0xFF0058BC).withOpacity(0.3),
              elevation: 8,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Continue',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12),
                Icon(Icons.arrow_forward, color: Colors.white, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
