import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadDetailsController extends GetxController {
  // Text controller for detailed notes
  final TextEditingController notesController = TextEditingController();

  // Reactive states
  final RxBool isPrivacyAccepted = false.obs;
  final RxBool isRecording = false.obs;
  final RxBool showPhoto = true.obs;

  // Actions
  void togglePrivacy(bool value) {
    isPrivacyAccepted.value = value;
  }

  void toggleRecording() {
    isRecording.value = !isRecording.value;
  }

  void removePhoto() {
    showPhoto.value = false;
  }

  void submitLead() {
    if (!isPrivacyAccepted.value) {
      Get.snackbar(
        'Consent Required',
        'Please accept the privacy protocols to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }
    // Proceed with submission logic
    log("Lead Details Submitted");
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
