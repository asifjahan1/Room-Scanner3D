import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/utils/measurement_utils.dart';

/// Floating card displaying live room dimensions (area and perimeter) with fast unit switching.
class DimensionLabelWidget extends StatelessWidget {
  final double areaSqMeters;
  final double perimeterMeters;
  final bool isMetric;
  final VoidCallback? onToggleUnits;

  const DimensionLabelWidget({
    super.key,
    required this.areaSqMeters,
    required this.perimeterMeters,
    this.isMetric = true,
    this.onToggleUnits,
  });

  @override
  Widget build(BuildContext context) {
    final areaStr = MeasurementUtils.formatArea(areaSqMeters, isMetric: isMetric);
    final perimeterStr = MeasurementUtils.formatLength(perimeterMeters, isMetric: isMetric);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppTheme.borderDark),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatItem('Area', areaStr, Icons.square_foot, AppTheme.primaryBlue),
          Container(
            height: 30,
            width: 1,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            color: AppTheme.borderDark,
          ),
          _buildStatItem('Perimeter', perimeterStr, Icons.border_outer, AppTheme.accentTeal),
          const SizedBox(width: 14),
          GestureDetector(
            onTap: onToggleUnits,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.bgSurface,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.5)),
              ),
              child: Text(
                isMetric ? 'METRIC' : 'IMPERIAL',
                style: const TextStyle(
                  color: AppTheme.primaryBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(color: AppTheme.textTertiary, fontSize: 10, fontWeight: FontWeight.w600),
            ),
            Text(
              value,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }
}
