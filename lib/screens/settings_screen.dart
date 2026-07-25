import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../core/storage/local_storage.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<LocalStorage>();

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgDark,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Measurement Unit
          _buildSectionHeader('Measurement'),
          _buildSettingTile(
            icon: Icons.straighten,
            title: 'Unit System',
            subtitle: storage.isMetric ? 'Metric (meters)' : 'Imperial (feet)',
            onTap: () {
              storage.isMetric = !storage.isMetric;
              Get.forceAppUpdate();
            },
          ),

          const SizedBox(height: 24),

          // Appearance
          _buildSectionHeader('Appearance'),
          _buildSettingTile(
            icon: Icons.dark_mode,
            title: 'Theme',
            subtitle: storage.themeMode == 'dark' ? 'Dark' : 'Light',
            onTap: () {
              storage.themeMode =
                  storage.themeMode == 'dark' ? 'light' : 'dark';
              Get.changeThemeMode(
                storage.themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light,
              );
            },
          ),

          const SizedBox(height: 24),

          // Export
          _buildSectionHeader('Export'),
          _buildSettingTile(
            icon: Icons.file_download,
            title: 'Default Format',
            subtitle: storage.defaultExportFormat.toUpperCase(),
            onTap: () {
              _showFormatPicker(context, storage);
            },
          ),

          const SizedBox(height: 24),

          // About
          _buildSectionHeader('About'),
          _buildSettingTile(
            icon: Icons.info_outline,
            title: 'Room Scanner 3D',
            subtitle: 'Version 1.0.0',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.primaryBlue,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: AppTheme.borderDark),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.primaryBlue, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppTheme.textTertiary, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppTheme.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }

  void _showFormatPicker(BuildContext context, LocalStorage storage) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final formats = ['pdf', 'png', 'json', 'svg', 'dxf'];
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.borderDark,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Default Export Format',
                  style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              ...formats.map((f) => ListTile(
                    title: Text(f.toUpperCase(),
                        style:
                            const TextStyle(color: AppTheme.textPrimary)),
                    trailing: storage.defaultExportFormat == f
                        ? const Icon(Icons.check_circle,
                            color: AppTheme.accentTeal)
                        : null,
                    onTap: () {
                      storage.defaultExportFormat = f;
                      Get.back();
                      Get.forceAppUpdate();
                    },
                  )),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }
}
