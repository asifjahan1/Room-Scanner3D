import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_card.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDocScaffold(
      headerTitle: 'TERMS OF USE',
      pageTitle: 'Terms of Use',
      subtitle:
          'Please review our operating standards for PerfektWerk OS to ensure site safety and data integrity.',
      children: [
        _buildDocSection(
          icon: Icons.assignment_turned_in_outlined,
          title: "User Responsibilities",
          content:
              "As an operator within the PerfektWerk ecosystem, you are responsible for maintaining the security and precision of the platform:\n\n• Maintain absolute confidentiality of hardware access credentials and biometric tokens.\n\n• Ensure all site data captures are accurate, time-stamped, and verified by an on-site supervisor.\n\n• Notify technical support immediately upon discovery of any hardware-software telemetry discrepancies.",
        ),
        const SizedBox(height: 20),
        _buildDocSection(
          icon: Icons.gavel_rounded,
          title: "Prohibited Conduct",
          content:
              "The following actions represent a breach of safety protocols and will result in immediate credential revocation:\n\n• Reverse engineering or unauthorized modification of the PerfektWerk OS binary, files, or firmware.\n\n• Using automated scripts or tools to spoof GPS location or equipment telemetry data.\n\n• Sharing high-definition site scans or proprietary blueprints with unauthorized third-party vendors.",
        ),
        const SizedBox(height: 20),
        _buildDocSection(
          icon: Icons.balance_outlined,
          title: "Liability",
          content:
              "PerfektWerk provides the OS on an 'as-is' basis for construction operations and telemetry management.\n\n\"PerfektWerk shall not be held liable for mechanical failures or on-site accidents resulting from improper data entry or the disregard of automated safety warnings provided by the OS interface.\"\n\n• Total aggregate liability is limited to the preceding 12 months of service subscription fees.",
        ),
      ],
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDocScaffold(
      headerTitle: 'PRIVACY POLICY',
      pageTitle: 'Your Trust, Engineered.',
      subtitle:
          'PerfektWerk OS is built for high-stakes environments. We handle your data with the same precision and safety you apply to your job site.',
      children: [
        _buildDocSection(
          icon: Icons.storage_rounded,
          title: "Data Collection",
          content:
              "We only collect what's necessary for site operations. This includes your name, professional credentials, and GPS coordinates when you are actively logged into a project site:\n\n• Project logs and equipment telemetry.\n\n• Communication within site teams.\n\n• Safety check-ins and maintenance alerts.",
        ),
        const SizedBox(height: 20),
        _buildDocSection(
          icon: Icons.verified_user_outlined,
          title: "Your Rights",
          content:
              "You maintain full control over your digital footprint on the site. At any time, you can request to view, edit, or remove your personal data from our systems.\n\n• Access: Download a footprint of your site activity data at any time.\n\n• Erasure: Request permanent erasure of your project logs from legacy archives.",
        ),
        const SizedBox(height: 20),
        _buildDocSection(
          icon: Icons.support_agent_rounded,
          title: "Contact",
          content:
              "Need clarification on safety protocols or data usage? Our compliance team is on standby:\n\n📧 privacy@perfektwerk.eu\n📞 +49 (0)30 555-SITE",
        ),
      ],
    );
  }
}

class ImpressumScreen extends StatelessWidget {
  const ImpressumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDocScaffold(
      headerTitle: 'IMPRESSUM',
      pageTitle: 'Impressum',
      superTitle: 'LEGAL IDENTITY',
      subtitle:
          'Legal transparency and corporate information according to German TMG (Telemediengesetz) regulations for industrial operating systems.',
      children: [
        PerfektCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "COMPANY NAME",
                style: PerfektTheme.fontBold(11, color: PerfektTheme.textLight),
              ),
              const SizedBox(height: 4),
              Text(
                "PerfektWerk Technologies GmbH",
                style: PerfektTheme.fontBold(17, color: PerfektTheme.textDark),
              ),
              const SizedBox(height: 16),
              Text(
                "LEGAL FORM",
                style: PerfektTheme.fontBold(11, color: PerfektTheme.textLight),
              ),
              const SizedBox(height: 4),
              Text(
                "Gesellschaft mit beschränkter\nHaftung",
                style: PerfektTheme.fontMedium(
                  15,
                  color: PerfektTheme.textDark,
                ),
              ),
              const Divider(height: 32, color: Color(0xFFF1F5F9)),
              Text(
                "OFFICIAL HEADQUARTERS",
                style: PerfektTheme.fontBold(11, color: PerfektTheme.textLight),
              ),
              const SizedBox(height: 4),
              Text(
                "Bauhüttenstraße\n15-19\n10715 Berlin\nGermany",
                style: PerfektTheme.fontMedium(
                  15,
                  color: PerfektTheme.textDark,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.phone_outlined,
                    color: PerfektTheme.primaryBlue,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "+49 (0)30 555 0100",
                    style: PerfektTheme.fontBold(
                      14,
                      color: PerfektTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.email_outlined,
                    color: PerfektTheme.primaryBlue,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "contact@perfektwerk.eu",
                    style: PerfektTheme.fontBold(
                      14,
                      color: PerfektTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Map Preview
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: PerfektTheme.radiusCard,
            border: Border.all(color: PerfektTheme.borderLight),
            color: PerfektTheme.surfaceGrey,
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?auto=format&fit=crop&q=80&w=600',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 20),
        PerfektCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "COMMERCIAL REGISTRY",
                style: PerfektTheme.fontBold(11, color: PerfektTheme.textLight),
              ),
              const SizedBox(height: 4),
              Text(
                "Amtsgericht Berlin-Charlottenburg\nHRB 194728 B",
                style: PerfektTheme.fontBold(15, color: PerfektTheme.textDark),
              ),
              const SizedBox(height: 12),
              Text(
                "VAT ID (USt-IdNr.)",
                style: PerfektTheme.fontBold(11, color: PerfektTheme.textLight),
              ),
              const SizedBox(height: 4),
              Text(
                "DE 334 889 201",
                style: PerfektTheme.fontMedium(
                  15,
                  color: PerfektTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildDocScaffold({
  required String headerTitle,
  required String pageTitle,
  String? superTitle,
  required String subtitle,
  required List<Widget> children,
}) {
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
          headerTitle,
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
              if (superTitle != null) ...[
                Text(
                  superTitle,
                  style: PerfektTheme.fontBold(
                    12,
                    color: PerfektTheme.textLight,
                  ).copyWith(letterSpacing: 0.8),
                ),
                const SizedBox(height: 4),
              ],
              Text(
                pageTitle,
                style: PerfektTheme.fontBold(24, color: PerfektTheme.textDark),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: PerfektTheme.fontRegular(
                  14,
                  color: PerfektTheme.textMedium,
                ).copyWith(height: 1.4),
              ),
              const SizedBox(height: 24),
              ...children,
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildDocSection({
  required IconData icon,
  required String title,
  required String content,
}) {
  return PerfektCard(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: PerfektTheme.primaryBlue, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: PerfektTheme.fontBold(17, color: PerfektTheme.textDark),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          content,
          style: PerfektTheme.fontRegular(
            14,
            color: PerfektTheme.textDark,
          ).copyWith(height: 1.5),
        ),
      ],
    ),
  );
}
