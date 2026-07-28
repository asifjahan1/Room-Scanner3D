import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liddar/controllers/auth_controller.dart';

class SignInFields extends StatefulWidget {
  final AuthController auth;

  const SignInFields({super.key, required this.auth});

  @override
  State<SignInFields> createState() => _SignInFieldsState();
}

class _SignInFieldsState extends State<SignInFields> {
  bool obscure = true;

  InputDecoration inputDecoration({required String hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        color: const Color(0xFF737686),
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFC3C6D7), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFC3C6D7), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF0058BC), width: 1.5),
      ),
    );
  }

  Widget _buildFieldContainer({required Widget child}) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = widget.auth;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFieldContainer(
          child: TextField(
            controller: auth.emailController,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF191B23),
            ),
            decoration: inputDecoration(hint: "Email Address"),
          ),
        ),

        const SizedBox(height: 16),

        _buildFieldContainer(
          child: TextField(
            controller: auth.passwordController,
            obscureText: obscure,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF191B23),
            ),
            decoration: inputDecoration(
              hint: "Password",
              suffix: IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFF737686),
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Obx(
          () => SizedBox(
            height: 36,
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: auth.rememberMe.value,
                    onChanged: auth.toggleRememberMe,
                    activeColor: const Color(0xFF0058BC),
                    side: const BorderSide(color: Color(0xFFC3C6D7), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  "Remember me",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    color: const Color(0xFF434655),
                  ),
                ),

                const Spacer(),

                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Forgot password?",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                      color: const Color(0xFF191B23),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: auth.signIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0058BC),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              "Sign In",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            const Expanded(
              child: Divider(color: Color(0xFFC3C6D7), thickness: 1),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "OR",
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF737686),
                ),
              ),
            ),

            const Expanded(
              child: Divider(color: Color(0xFFC3C6D7), thickness: 1),
            ),
          ],
        ),
      ],
    );
  }
}
