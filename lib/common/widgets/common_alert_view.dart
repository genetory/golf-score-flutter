import 'package:flutter/material.dart';

import 'common_rounded_button.dart';

class CommonAlertView extends StatelessWidget {
  const CommonAlertView({
    super.key,
    required this.title,
    this.subTitle,
    this.content,
    required this.primaryButtonTitle,
    this.secondaryButtonTitle,
    this.onPrimaryTap,
    this.onSecondaryTap,
  });

  final String title;
  final String? subTitle;
  final Widget? content;
  final String primaryButtonTitle;
  final String? secondaryButtonTitle;
  final VoidCallback? onPrimaryTap;
  final VoidCallback? onSecondaryTap;

  @override
  Widget build(BuildContext context) {
    final hasSecondary = secondaryButtonTitle != null;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Material(
      color: Colors.transparent,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                if (subTitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    subTitle!,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ],
                if (content != null) ...[
                  const SizedBox(height: 16),
                  content!,
                ],
                const SizedBox(height: 20),
                if (hasSecondary)
                  Row(
                    children: [
                      Expanded(
                        child: CommonRoundedButton(
                          title: secondaryButtonTitle!,
                          onTap: onSecondaryTap,
                          height: 44,
                          backgroundColor: const Color(0xFFF2F2F2),
                          textColor: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CommonRoundedButton(
                          title: primaryButtonTitle,
                          onTap: onPrimaryTap,
                          height: 44,
                        ),
                      ),
                    ],
                  )
                else
                  CommonRoundedButton(
                    title: primaryButtonTitle,
                    onTap: onPrimaryTap,
                    height: 44,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
