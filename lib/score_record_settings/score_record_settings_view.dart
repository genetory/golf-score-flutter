import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../common/widgets/common_course_item_view.dart';
import '../common/widgets/common_image_view.dart';
import '../common/widgets/common_navigation_view.dart';
import '../common/widgets/common_chip_view.dart';
import '../common/widgets/common_alert_view.dart';
import '../common/widgets/common_textfield_view.dart';
import '../common/widgets/common_rounded_button.dart';
import '../score_record_play/score_record_play_view.dart';

class ScoreRecordSettingsView extends StatefulWidget {
  const ScoreRecordSettingsView({
    super.key,
    this.courseName,
  });

  final String? courseName;

  @override
  State<ScoreRecordSettingsView> createState() =>
      _ScoreRecordSettingsViewState();
}

class _ScoreRecordSettingsViewState extends State<ScoreRecordSettingsView> {
  int _selectedHoles = 18;
  int? _customHoles;
  String _selectedTee = '화이트';
  int _startingHole = 1;

  Future<void> _showCustomHolesInput(BuildContext context) async {
    final TextEditingController controller = TextEditingController(
      text: _customHoles?.toString() ?? '',
    );

    final String? result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return CommonAlertView(
          title: '홀 수 직접 입력',
          content: CommonTextFieldView(
            controller: controller,
            hintText: '예: 12',
            keyboardType: TextInputType.number,
          ),
          primaryButtonTitle: '확인',
          secondaryButtonTitle: '취소',
          onPrimaryTap: () =>
              Navigator.of(dialogContext).pop(controller.text.trim()),
          onSecondaryTap: () => Navigator.of(dialogContext).pop(),
        );
      },
    );

    final parsed = int.tryParse(result ?? '');
    if (parsed != null && parsed > 0) {
      setState(() {
        _customHoles = parsed;
        _selectedHoles = parsed;
      });
    }
  }

  Future<void> _showCustomStartHoleInput(BuildContext context) async {
    final TextEditingController controller = TextEditingController(
      text: _startingHole.toString(),
    );

    final String? result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return CommonAlertView(
          title: '시작 홀 입력',
          content: CommonTextFieldView(
            controller: controller,
            hintText: '예: 1',
            keyboardType: TextInputType.number,
          ),
          primaryButtonTitle: '확인',
          secondaryButtonTitle: '취소',
          onPrimaryTap: () =>
              Navigator.of(dialogContext).pop(controller.text.trim()),
          onSecondaryTap: () => Navigator.of(dialogContext).pop(),
        );
      },
    );

    final parsed = int.tryParse(result ?? '');
    if (parsed != null && parsed >= 1 && parsed <= 18) {
      setState(() {
        _startingHole = parsed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = [
      '18홀',
      '9홀',
      _selectedHoles == 18 || _selectedHoles == 9
          ? '직접입력'
          : '${_selectedHoles}홀',
    ];
    final selectedLabel = _selectedHoles == 18
        ? '18홀'
        : _selectedHoles == 9
            ? '9홀'
            : labels[2];
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: SizedBox(
            height: 52,
            child: CommonRoundedButton(
              title: '시작하기',
              radius: 14,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ScoreRecordPlayView(
                      courseName: widget.courseName,
                      holes: _selectedHoles,
                      tee: _selectedTee,
                      startingHole: _startingHole,
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
              left: const Icon(PhosphorIconsRegular.caretLeft),
              onLeftTap: () => Navigator.of(context).maybePop(),
              backgroundColor: Colors.white,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  const SizedBox(height: 8),
                  Text(
                    '라운드 옵션을\n설정해주세요',
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 24,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _CourseCard(
                    courseName:
                        (widget.courseName == null || widget.courseName!.isEmpty)
                        ? '직접 입력한 코스'
                        : widget.courseName!,
                    location: '지역 미지정',
                    holes: _selectedHoles,
                    tee: _selectedTee,
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(title: '홀 수'),
                  const SizedBox(height: 10),
                  _SegmentedOptions(
                    options: labels,
                    selected: selectedLabel,
                    onSelected: (value) {
                      if (value == labels[2]) {
                        _showCustomHolesInput(context);
                        return;
                      }
                      setState(() {
                        _selectedHoles = value == '9홀' ? 9 : 18;
                        if (_selectedHoles == 9 && _startingHole != 1 && _startingHole != 10) {
                          _startingHole = 1;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(title: '시작 홀'),
                  const SizedBox(height: 10),
                  _SegmentedOptions(
                    options: _selectedHoles == 9
                        ? const ['1', '10']
                        : const ['1', '10', '직접입력'],
                    selected: _startingHole == 10 ? '10' : '1',
                    onSelected: (value) {
                      if (value == '직접입력') {
                        _showCustomStartHoleInput(context);
                        return;
                      }
                      setState(() {
                        _startingHole = value == '10' ? 10 : 1;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(title: '티 선택'),
                  const SizedBox(height: 10),
                  _SegmentedOptions(
                    options: const ['블랙', '블루', '화이트', '시니어', '레이디'],
                    selected: _selectedTee,
                    onSelected: (value) {
                      setState(() {
                        _selectedTee = value;
                      });
                    },
                  ),
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

class _CourseCard extends StatelessWidget {
  const _CourseCard({
    required this.courseName,
    required this.location,
    required this.holes,
    required this.tee,
  });

  final String courseName;
  final String location;
  final int holes;
  final String tee;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 56,
              height: 56,
              child: CommonImageView(
                backgroundColor: const Color(0xFFEFF3FF),
                fit: BoxFit.cover,
              ),
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
                  '$location · ${holes}홀 · $tee',
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
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF8E8E93),
      ),
    );
  }
}

class _SegmentedOptions extends StatelessWidget {
  const _SegmentedOptions({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(options.length, (index) {
          final label = options[index];
          final bool isActive = label == selected;
          return Padding(
            padding: EdgeInsets.only(right: index == options.length - 1 ? 0 : 8),
            child: CommonChipView(
              label: label,
              isSelected: isActive,
              onTap: () => onSelected(label),
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          );
        }),
      ),
    );
  }
}
