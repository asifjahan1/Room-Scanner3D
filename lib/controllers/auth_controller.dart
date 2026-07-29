import 'dart:async'; // Timer ব্যবহার করার জন্য এটি ইমপোর্ট করতে হবে
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/routes/app_routes.dart';

/// Authentication controller for PerfektWerk OS onboarding and access.
/// CRITICAL REQUIREMENT: Absolutely zero validation for sign in, sign up, or email verification.
class AuthController extends GetxController {
  // Form text editing controllers (for visual input only, no validation)
  final emailController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  final fullNameController = TextEditingController(text: '');
  final phoneController = TextEditingController(text: '');

  final rememberMe = true.obs;
  final isLoading = false.obs;

  // Timer Variables
  final secondsRemaining = 60.obs;
  final canResend = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer(); // কন্ট্রোলার ইনিশিয়ালাইজ হওয়ার সাথে সাথেই টাইমার শুরু হবে
  }

  @override
  void onClose() {
    _timer?.cancel(); // মেমোরি লিক রোধ করতে টাইমার ক্যানসেল করা
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  // Timer ফাংশন
  void startTimer() {
    canResend.value = false;
    secondsRemaining.value = 60;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  /// Toggle remember me checkbox
  void toggleRememberMe(bool? value) {
    if (value != null) {
      rememberMe.value = value;
    }
  }

  /// Navigate from Welcome screen to Company Invitation screen
  void goToInvitation() {
    Get.toNamed(AppRoutes.invitation);
  }

  /// Accept company invitation and go to Sign In screen
  void acceptInvitation() {
    Get.toNamed(AppRoutes.signIn);
  }

  /// Decline invitation and return to Welcome screen
  void declineInvitation() {
    Get.back();
    Get.snackbar(
      'Invitation Declined',
      'You have declined the SteinMetz Construction invitation.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF334155),
      colorText: const Color(0xFFFFFFFF),
    );
  }

  /// Navigate to Sign Up screen
  void goToSignUp() {
    Get.toNamed(AppRoutes.signUp);
  }

  /// Navigate to Sign In screen
  void goToSignIn() {
    Get.toNamed(AppRoutes.signIn);
  }

  /// Perform sign in WITHOUT any validation checks
  void signIn() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading.value = false;
    // Directly navigate to main Dashboard regardless of input content
    Get.offAllNamed(AppRoutes.dashboard);
  }

  /// Social sign in with Google WITHOUT validation
  void signInWithGoogle() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading.value = false;
    Get.offAllNamed(AppRoutes.dashboard);
  }

  /// Social sign in with Apple WITHOUT validation
  void signInWithApple() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading.value = false;
    Get.offAllNamed(AppRoutes.dashboard);
  }

  /// Perform sign up WITHOUT any validation checks
  void signUp() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading.value = false;
    // Directly navigate to email verification regardless of input
    Get.toNamed(AppRoutes.verifyEmail);
  }

  /// Perform email verification WITHOUT checking OTP validity
  void verifyEmail() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading.value = false;
    // Directly proceed to the workspace dashboard
    Get.offAllNamed(AppRoutes.dashboard);
  }

  /// Resend code action for verification screen
  void resendCode() {
    if (!canResend.value) return; // যদি ০ না হয়, তাহলে কাজ করবে না

    Get.snackbar(
      'Code Resent',
      'A new 6-digit verification code has been dispatched to your email.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF155DFC),
      colorText: const Color(0xFFFFFFFF),
    );

    startTimer(); // রিসেন্ড করার পর আবার ৬০ সেকেন্ড থেকে শুরু হবে
  }

  /// Change email action
  void changeEmail() {
    Get.back();
  }
}
