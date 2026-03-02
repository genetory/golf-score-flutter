import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../common/widgets/common_navigation_view.dart';
import '../common/widgets/common_rounded_button.dart';
import '../common/widgets/common_scorecard_view.dart';

class ScoreRecordPlayView extends StatefulWidget {
  const ScoreRecordPlayView({
    super.key,
    this.courseName,
    int? holes,
    String? tee,
    int? startingHole,
  })  : holes = holes ?? 18,
        tee = tee ?? '화이트',
        startingHole = startingHole ?? 1;

  final String? courseName;
  final int? holes;
  final String? tee;
  final int startingHole;

  @override
  State<ScoreRecordPlayView> createState() => _ScoreRecordPlayViewState();
}

class _ScoreRecordPlayViewState extends State<ScoreRecordPlayView> {
  int _currentIndex = 0;
  final Map<int, _HoleEntry> _entries = {};
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<int> _holesList() {
    final count = widget.holes ?? 18;
    return List<int>.generate(
      count,
      (index) => ((widget.startingHole - 1 + index) % 18) + 1,
    );
  }

  int _defaultPar(int hole) {
    const parByHole = {
      1: 5,
      2: 4,
      3: 4,
      4: 3,
      5: 5,
      6: 4,
      7: 3,
      8: 4,
      9: 4,
      10: 4,
      11: 5,
      12: 3,
      13: 4,
      14: 4,
      15: 5,
      16: 4,
      17: 3,
      18: 4,
    };
    return parByHole[hole] ?? 4;
  }

  void _updateEntry(int hole, _HoleEntry entry) {
    setState(() {
      _entries[hole] = entry;
      final holes = _holesList();
      final index = holes.indexOf(hole);
      if (index != -1) {
        _currentIndex = index;
      }
    });
  }

  void _jumpToHole(int hole) {
    final holes = _holesList();
    final index = holes.indexOf(hole);
    if (index == -1) return;
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: CommonRoundedButton(
                    title: '이전 홀',
                    radius: 14,
                    backgroundColor: const Color(0xFFF2F2F2),
                    textColor: Colors.black,
                    onTap: () {
                      setState(() {
                        if (_currentIndex > 0) {
                          _currentIndex -= 1;
                        }
                      });
                      _pageController.animateToPage(
                        _currentIndex,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: CommonRoundedButton(
                    title: '다음 홀',
                    radius: 14,
                    onTap: () {
                      setState(() {
                        final holes = _holesList();
                        if (_currentIndex < holes.length - 1) {
                          _currentIndex += 1;
                        }
                      });
                      _pageController.animateToPage(
                        _currentIndex,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                ),
              ),
          ],
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: CommonScorecardView(
                holes: widget.holes ?? 18,
                startingHole: widget.startingHole,
                scores: _entries.map(
                  (key, value) => MapEntry(
                    key,
                    CommonScorecardEntry(
                      strokes: value.strokes,
                      par: value.par,
                      putts: value.putts,
                    ),
                  ),
                ),
                onHoleTap: _jumpToHole,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _holesList().length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) {
                  final hole = _holesList()[index];
                  final entry =
                      _entries[hole] ?? _HoleEntry.empty(par: _defaultPar(hole));
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _HolePlayCard(
                      holeNumber: hole,
                      strokes: entry.strokes,
                      putts: entry.putts,
                      par: entry.par,
                      teeDirection: entry.teeDirection,
                      teeResult: entry.teeResult,
                      isActive: index == _currentIndex,
                      onCardTap: () => _jumpToHole(hole),
                      onStrokesChanged: (value) =>
                          _updateEntry(hole, entry.copyWith(strokes: value)),
                      onPuttsChanged: (value) =>
                          _updateEntry(hole, entry.copyWith(putts: value)),
                      onParChanged: (value) =>
                          _updateEntry(hole, entry.copyWith(par: value)),
                      onTeeDirectionSelected: (value) =>
                          _updateEntry(hole, entry.copyWith(teeDirection: value)),
                      onTeeResultSelected: (value) =>
                          _updateEntry(hole, entry.copyWith(teeResult: value)),
                      onPenaltyAdd: () {},
                      onGirToggle: () {},
                      asCard: false,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _HoleEntry {
  const _HoleEntry({
    required this.strokes,
    required this.putts,
    required this.par,
    required this.teeDirection,
    required this.teeResult,
  });

  final int strokes;
  final int putts;
  final int par;
  final String? teeDirection;
  final String teeResult;

  const _HoleEntry.empty({required this.par})
      : strokes = 5,
        putts = 2,
        teeDirection = null,
        teeResult = '정상';

  _HoleEntry copyWith({
    int? strokes,
    int? putts,
    int? par,
    String? teeDirection,
    String? teeResult,
  }) {
    return _HoleEntry(
      strokes: strokes ?? this.strokes,
      putts: putts ?? this.putts,
      par: par ?? this.par,
      teeDirection: teeDirection ?? this.teeDirection,
      teeResult: teeResult ?? this.teeResult,
    );
  }
}

class _HolePlayCard extends StatelessWidget {
  const _HolePlayCard({
    required this.holeNumber,
    required this.strokes,
    required this.putts,
    required this.par,
    required this.teeDirection,
    required this.teeResult,
    required this.isActive,
    required this.onCardTap,
    required this.onStrokesChanged,
    required this.onPuttsChanged,
    required this.onParChanged,
    required this.onTeeDirectionSelected,
    required this.onTeeResultSelected,
    required this.onPenaltyAdd,
    required this.onGirToggle,
    this.asCard = true,
  });

  final int holeNumber;
  final int strokes;
  final int putts;
  final int par;
  final String? teeDirection;
  final String teeResult;
  final bool isActive;
  final VoidCallback onCardTap;
  final ValueChanged<int> onStrokesChanged;
  final ValueChanged<int> onPuttsChanged;
  final ValueChanged<int> onParChanged;
  final ValueChanged<String> onTeeDirectionSelected;
  final ValueChanged<String> onTeeResultSelected;
  final VoidCallback onPenaltyAdd;
  final VoidCallback onGirToggle;
  final bool asCard;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$holeNumber번홀',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 17,
                height: 1.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 12),
            _ParStepper(
              par: par,
              onChanged: onParChanged,
            ),
          ],
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              _StepperRow(
                title: '타수',
                value: strokes,
                onChanged: onStrokesChanged,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: _SelectChip(
                      label: '이글',
                      isSelected: strokes == par - 2,
                      onTap: () => onStrokesChanged(par - 2),
                      expanded: true,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: _SelectChip(
                      label: '버디',
                      isSelected: strokes == par - 1,
                      onTap: () => onStrokesChanged(par - 1),
                      expanded: true,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: _SelectChip(
                      label: '파',
                      isSelected: strokes == par,
                      onTap: () => onStrokesChanged(par),
                      expanded: true,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: _SelectChip(
                      label: '보기',
                      isSelected: strokes == par + 1,
                      onTap: () => onStrokesChanged(par + 1),
                      expanded: true,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: _SelectChip(
                      label: '더블',
                      isSelected: strokes == par + 2,
                      onTap: () => onStrokesChanged(par + 2),
                      expanded: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              _StepperRow(
                title: '퍼팅(옵션)',
                value: putts,
                onChanged: onPuttsChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(title: '티샷 결과(드라이버)'),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: _SelectChip(
                      label: '좌',
                      isSelected: teeDirection == '좌',
                      onTap: () => onTeeDirectionSelected('좌'),
                      expanded: true,
                      icon: PhosphorIconsRegular.arrowBendUpLeft,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SelectChip(
                      label: '센터',
                      isSelected: teeDirection == '센터',
                      onTap: () => onTeeDirectionSelected('센터'),
                      expanded: true,
                      icon: PhosphorIconsRegular.arrowUp,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SelectChip(
                      label: '우',
                      isSelected: teeDirection == '우',
                      onTap: () => onTeeDirectionSelected('우'),
                      expanded: true,
                      icon: PhosphorIconsRegular.arrowBendUpRight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: _SelectChip(
                      label: '정상',
                      isSelected: teeResult == '정상',
                      onTap: () => onTeeResultSelected('정상'),
                      expanded: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SelectChip(
                      label: 'OB',
                      isSelected: teeResult == 'OB',
                      onTap: () => onTeeResultSelected('OB'),
                      danger: true,
                      expanded: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SelectChip(
                      label: '해저드',
                      isSelected: teeResult == '해저드',
                      onTap: () => onTeeResultSelected('해저드'),
                      danger: true,
                      expanded: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 0),
      ],
    );

    if (!asCard) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: content,
      );
    }

    return InkWell(
      onTap: onCardTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 360,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isActive
                ? const [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ]
                : const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
          ),
          child: content,
        ),
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
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }
}

class _StepperRow extends StatelessWidget {
  const _StepperRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        _StepButton(
          icon: Icons.remove,
          onTap: value > 0 ? () => onChanged(value - 1) : null,
        ),
        const SizedBox(width: 8),
        Container(
          width: 40,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6F8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value.toString(),
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 8),
        _StepButton(
          icon: Icons.add,
          onTap: () => onChanged(value + 1),
        ),
      ],
    );
  }
}

class _ParStepper extends StatelessWidget {
  const _ParStepper({
    required this.par,
    required this.onChanged,
  });

  final int par;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepButton(
          icon: Icons.remove,
          onTap: par > 3 ? () => onChanged(par - 1) : null,
        ),
        const SizedBox(width: 6),
        Container(
          width: 48,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Par $par',
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 6),
        _StepButton(
          icon: Icons.add,
          onTap: par < 6 ? () => onChanged(par + 1) : null,
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap == null ? const Color(0xFFBDBDBD) : Colors.black,
        ),
      ),
    );
  }
}

class _SelectChip extends StatelessWidget {
  const _SelectChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.danger = false,
    this.expanded = false,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool danger;
  final bool expanded;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final background = isSelected
        ? (danger ? const Color(0xFFFFE5E5) : const Color(0xFFE7F0FF))
        : const Color(0xFFF5F6F8);
    final color = isSelected
        ? (danger ? const Color(0xFFD93025) : const Color(0xFF1A73E8))
        : const Color(0xFF3A3A3A);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: expanded ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(
          child: icon == null
              ? Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 14, color: color),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3A3A3A),
          ),
        ),
      ),
    );
  }
}

class _GhostToggle extends StatelessWidget {
  const _GhostToggle({
    required this.label,
    required this.isOn,
    required this.onTap,
  });

  final String label;
  final bool isOn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isOn ? const Color(0xFF1A73E8) : const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isOn ? Colors.white : const Color(0xFF3A3A3A),
          ),
        ),
      ),
    );
  }
}


class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}
