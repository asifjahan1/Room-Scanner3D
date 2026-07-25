import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/floor_plan_element.dart';

/// Interactive UI widget for customizing a selected door or window opening.
class DoorWidget extends StatelessWidget {
  final EditableOpening opening;
  final ValueChanged<double>? onWidthChanged;
  final VoidCallback? onDelete;

  const DoorWidget({
    super.key,
    required this.opening,
    this.onWidthChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDoor = opening.type == 'door';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppTheme.borderDark),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isDoor ? Icons.door_front_door_outlined : Icons.window_outlined,
                    color: AppTheme.accentTeal,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isDoor ? 'Door Configuration' : 'Window Configuration',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppTheme.dangerRed),
                onPressed: onDelete,
                tooltip: 'Delete',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Width: ${opening.width.toStringAsFixed(2)}m',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
          Slider(
            value: opening.width.clamp(0.5, 3.0),
            min: 0.5,
            max: 3.0,
            divisions: 25,
            activeColor: AppTheme.primaryBlue,
            inactiveColor: AppTheme.borderDark,
            label: '${opening.width.toStringAsFixed(2)}m',
            onChanged: (val) {
              onWidthChanged?.call(val);
            },
          ),
        ],
      ),
    );
  }
}
