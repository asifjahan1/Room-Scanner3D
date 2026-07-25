import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Interactive editing toolbar for modifying walls and openings in the floor plan editor.
class ToolbarWidget extends StatelessWidget {
  final bool canUndo;
  final bool canRedo;
  final bool hasSelection;
  final bool showGrid;
  final VoidCallback? onUndo;
  final VoidCallback? onRedo;
  final VoidCallback? onAddDoor;
  final VoidCallback? onAddWindow;
  final VoidCallback? onSplitWall;
  final VoidCallback? onDeleteSelected;
  final VoidCallback? onToggleGrid;
  final VoidCallback? onExport;

  const ToolbarWidget({
    super.key,
    required this.canUndo,
    required this.canRedo,
    required this.hasSelection,
    required this.showGrid,
    this.onUndo,
    this.onRedo,
    this.onAddDoor,
    this.onAddWindow,
    this.onSplitWall,
    this.onDeleteSelected,
    this.onToggleGrid,
    this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        border: Border.all(color: AppTheme.borderDark),
        boxShadow: AppTheme.cardShadow,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildToolIcon(
              icon: Icons.undo,
              label: 'Undo',
              enabled: canUndo,
              onTap: onUndo,
            ),
            _buildToolIcon(
              icon: Icons.redo,
              label: 'Redo',
              enabled: canRedo,
              onTap: onRedo,
            ),
            _buildDivider(),
            _buildToolIcon(
              icon: Icons.door_front_door_outlined,
              label: '+ Door',
              enabled: true,
              onTap: onAddDoor,
              color: AppTheme.accentTeal,
            ),
            _buildToolIcon(
              icon: Icons.window_outlined,
              label: '+ Window',
              enabled: true,
              onTap: onAddWindow,
              color: Colors.amber,
            ),
            if (hasSelection) ...[
              _buildDivider(),
              _buildToolIcon(
                icon: Icons.call_split,
                label: 'Split',
                enabled: true,
                onTap: onSplitWall,
                color: AppTheme.primaryBlue,
              ),
              _buildToolIcon(
                icon: Icons.delete_outline,
                label: 'Delete',
                enabled: true,
                onTap: onDeleteSelected,
                color: AppTheme.dangerRed,
              ),
            ],
            _buildDivider(),
            _buildToolIcon(
              icon: showGrid ? Icons.grid_on : Icons.grid_off,
              label: 'Grid',
              enabled: true,
              onTap: onToggleGrid,
              color: showGrid ? AppTheme.accentTeal : AppTheme.textSecondary,
            ),
            _buildToolIcon(
              icon: Icons.ios_share,
              label: 'Export',
              enabled: true,
              onTap: onExport,
              color: AppTheme.textPrimary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolIcon({
    required IconData icon,
    required String label,
    required bool enabled,
    VoidCallback? onTap,
    Color? color,
  }) {
    final effectiveColor = enabled ? (color ?? AppTheme.textPrimary) : AppTheme.textTertiary;
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: effectiveColor, size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(color: effectiveColor, fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 28,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: AppTheme.borderDark,
    );
  }
}
