import 'package:flutter/material.dart';
import '../../theme/perfekt_theme.dart';

enum PerfektButtonType { primary, secondary, outline, text }

class PerfektButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final PerfektButtonType type;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final double fontSize;

  const PerfektButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = PerfektButtonType.primary,
    this.icon,
    this.trailingIcon,
    this.isFullWidth = true,
    this.backgroundColor,
    this.textColor,
    this.height = 52,
    this.fontSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 20,
            color: _getTextColor(),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: PerfektTheme.fontSemiBold(
            fontSize,
            color: _getTextColor(),
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(
            trailingIcon,
            size: 18,
            color: _getTextColor(),
          ),
        ],
      ],
    );

    Widget button;

    switch (type) {
      case PerfektButtonType.primary:
      case PerfektButtonType.secondary:
        button = Container(
          height: height,
          width: isFullWidth ? double.infinity : null,
          decoration: BoxDecoration(
            color: backgroundColor ?? _getBackgroundColor(),
            borderRadius: PerfektTheme.radiusButton,
            boxShadow: type == PerfektButtonType.primary
                ? PerfektTheme.buttonShadow
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: PerfektTheme.radiusButton,
              child: Center(child: content),
            ),
          ),
        );
        break;
      case PerfektButtonType.outline:
        button = Container(
          height: height,
          width: isFullWidth ? double.infinity : null,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: PerfektTheme.radiusButton,
            border: Border.all(
              color: PerfektTheme.borderLight,
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: PerfektTheme.radiusButton,
              child: Center(child: content),
            ),
          ),
        );
        break;
      case PerfektButtonType.text:
        button = TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: _getTextColor(),
            minimumSize: Size(isFullWidth ? double.infinity : 40, height),
          ),
          child: content,
        );
        break;
    }

    return button;
  }

  Color _getBackgroundColor() {
    switch (type) {
      case PerfektButtonType.primary:
        return PerfektTheme.primaryBlue;
      case PerfektButtonType.secondary:
        return PerfektTheme.surfaceDarkGrey;
      case PerfektButtonType.outline:
        return Colors.white;
      case PerfektButtonType.text:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    if (textColor != null) return textColor!;
    switch (type) {
      case PerfektButtonType.primary:
      case PerfektButtonType.secondary:
        return Colors.white;
      case PerfektButtonType.outline:
        return PerfektTheme.textDark;
      case PerfektButtonType.text:
        return PerfektTheme.primaryBlue;
    }
  }
}
