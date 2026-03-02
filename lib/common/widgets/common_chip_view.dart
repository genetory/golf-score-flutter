import 'package:flutter/material.dart';

class CommonChipView extends StatelessWidget {
  const CommonChipView({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.height = 36,
    this.padding = const EdgeInsets.symmetric(horizontal: 14),
    this.selectedBackgroundColor = Colors.black,
    this.unselectedBackgroundColor = const Color(0xFFF5F6F8),
    this.selectedTextColor = Colors.white,
    this.unselectedTextColor = const Color(0xFF3A3A3A),
    this.textStyle,
    this.radius = 999,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final double height;
  final EdgeInsetsGeometry padding;
  final Color selectedBackgroundColor;
  final Color unselectedBackgroundColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final TextStyle? textStyle;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final effectiveTextStyle = (textStyle ??
            const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ))
        .copyWith(color: isSelected ? selectedTextColor : unselectedTextColor);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: isSelected ? selectedBackgroundColor : unselectedBackgroundColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(
          child: Text(label, style: effectiveTextStyle),
        ),
      ),
    );
  }
}
