import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CommonCourseItemView extends StatelessWidget {
  const CommonCourseItemView({
    super.key,
    required this.courseName,
    required this.location,
    required this.holes,
    this.onTap,
    this.trailing,
  });

  final String courseName;
  final String location;
  final int holes;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              PhosphorIconsRegular.flag,
              size: 20,
              color: Color(0xFF3D5AFE),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$location · ${holes}홀',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 13,
                    color: Color(0xFF7A7A7A),
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else
            const Icon(
              PhosphorIconsRegular.caretRight,
              size: 18,
              color: Color(0xFFB0B0B0),
            ),
        ],
      ),
    );

    return onTap == null
        ? content
        : InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: content,
          );
  }
}
