import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../widgets/perfekt/perfekt_card.dart';

class DataExportScreen extends StatelessWidget {
  const DataExportScreen({super.key});

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
            'DATA EXPORT',
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
                Text(
                  "Data Portability",
                  style: PerfektTheme.fontBold(
                    26,
                    color: PerfektTheme.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Maintain complete ownership of your project's digital footprint. Export all logs, media, and site data records.",
                  style: PerfektTheme.fontRegular(
                    14,
                    color: PerfektTheme.textMedium,
                  ).copyWith(height: 1.4),
                ),
                const SizedBox(height: 26),

                // Export Configuration Card
                PerfektCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.folder_zip_outlined,
                            color: PerfektTheme.primaryBlue,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "EXPORT CONFIGURATION",
                            style: PerfektTheme.fontBold(
                              12,
                              color: PerfektTheme.primaryBlue,
                            ).copyWith(letterSpacing: 0.8),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "What's included in your file?",
                        style: PerfektTheme.fontBold(
                          18,
                          color: PerfektTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 18),

                      _buildFeatureItem(
                        icon: Icons.table_chart_outlined,
                        title: "Comprehensive CSV Reports",
                        description:
                            "Raw GPS telemetry logging, task timestamps, and personnel check-ins formatted for Excel or BI tools.",
                      ),
                      const SizedBox(height: 18),

                      _buildFeatureItem(
                        icon: Icons.picture_as_pdf_outlined,
                        title: "Summarized PDF Documentation",
                        description:
                            "Visual compliance inspections, safety audit summaries, and job status approval timestamps.",
                      ),
                      const SizedBox(height: 18),

                      _buildFeatureItem(
                        icon: Icons.access_time_rounded,
                        title: "Estimated Processing Time",
                        description:
                            "Export packages finish in 12-24 hours depending on total volume of media attachments.",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),

                // Request Export Action Card
                PerfektCard(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.cloud_download_outlined,
                          color: PerfektTheme.primaryBlue,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "Request Export",
                        style: PerfektTheme.fontBold(
                          20,
                          color: PerfektTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "A secure link to download your archive file will be sent to your registered email address.",
                        textAlign: TextAlign.center,
                        style: PerfektTheme.fontRegular(
                          13,
                          color: PerfektTheme.textMedium,
                        ).copyWith(height: 1.4),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: PerfektButton(
                          label: "Request Data Export",
                          icon: Icons.send_rounded,
                          onPressed: () {
                            Get.back();
                            Get.snackbar(
                              "Data Export",
                              "Export archive requested! You will receive an email shortly.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.white,
                              colorText: PerfektTheme.textDark,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: PerfektTheme.primaryBlue, size: 20),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: PerfektTheme.fontBold(15, color: PerfektTheme.textDark),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: PerfektTheme.fontRegular(
                  13,
                  color: PerfektTheme.textMedium,
                ).copyWith(height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
