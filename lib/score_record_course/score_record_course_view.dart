import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../common/widgets/common_alert_view.dart';
import '../common/widgets/common_navigation_view.dart';
import '../common/widgets/common_rounded_button.dart';
import '../common/widgets/common_textfield_view.dart';
import '../score_record_settings/score_record_settings_view.dart';

class ScoreRecordCourseView extends StatefulWidget {
  const ScoreRecordCourseView({super.key});

  @override
  State<ScoreRecordCourseView> createState() => _ScoreRecordCourseViewState();
}

class _ScoreRecordCourseViewState extends State<ScoreRecordCourseView> {
  final TextEditingController _courseController = TextEditingController();

  @override
  void dispose() {
    _courseController.dispose();
    super.dispose();
  }

  Future<void> _showManualInput(BuildContext context) async {
    final TextEditingController manualController = TextEditingController(
      text: _courseController.text,
    );

    final String? result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return CommonAlertView(
          title: '골프장 직접 입력',
          content: CommonTextFieldView(
            controller: manualController,
            hintText: '골프장 이름',
            // prefixIcon: const Icon(PhosphorIconsRegular.mapPinLine),
          ),
          primaryButtonTitle: '확인',
          secondaryButtonTitle: '취소',
          onPrimaryTap: () => Navigator.of(dialogContext)
              .pop(manualController.text.trim()),
          onSecondaryTap: () => Navigator.of(dialogContext).pop(),
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _courseController.text = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: SizedBox(
            height: 52,
            child: CommonRoundedButton(
              title: '다음으로',
              radius: 14,
              onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ScoreRecordSettingsView(
                        courseName: _courseController.text.trim(),
                      ),
                    ),
                  );
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            CommonNavigationView(
              left: const Icon(PhosphorIconsRegular.x),
              onLeftTap: () => Navigator.of(context).maybePop(),
              backgroundColor: Colors.white,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  const SizedBox(height: 8),
                  Text(
                    '어느 골프장으로\n가시나요?',
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 24,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CommonTextFieldView(
                    controller: _courseController,
                    hintText: '골프장 검색',
                    prefixIcon: const Icon(PhosphorIconsRegular.magnifyingGlass),
                  ),
                  const SizedBox(height: 10),
                  _PrimaryGhostButton(
                    icon: PhosphorIconsRegular.pencilSimpleLine,
                    label: '직접 입력',
                    onTap: () => _showManualInput(context),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryGhostButton extends StatelessWidget {
  const _PrimaryGhostButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: const Color(0xFF5A5A5A),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3A3A3A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
