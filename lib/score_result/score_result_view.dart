import 'package:flutter/material.dart';

import '../common/widgets/common_navigation_view.dart';

class ScoreResultView extends StatelessWidget {
  const ScoreResultView({
    super.key,
    this.courseName,
    required this.totalStrokes,
    required this.totalPar,
    required this.totalPutts,
    required this.holes,
    required this.teeLeft,
    required this.teeCenter,
    required this.teeRight,
    required this.teeTotal,
  });

  final String? courseName;
  final int totalStrokes;
  final int totalPar;
  final int totalPutts;
  final int holes;
  final int teeLeft;
  final int teeCenter;
  final int teeRight;
  final int teeTotal;

  String _diffLabel() {
    final diff = totalStrokes - totalPar;
    if (diff == 0) return 'E';
    return diff > 0 ? '+$diff' : diff.toString();
  }

  String _percentLabel(int value) {
    if (teeTotal == 0) return '0%';
    final pct = (value / teeTotal * 100).round();
    return '$pct%';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            CommonNavigationView(
              left: const Icon(Icons.arrow_back),
              onLeftTap: () => Navigator.of(context).maybePop(),
              backgroundColor: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '라운드 요약',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  if (courseName != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      courseName!,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  _SummaryCard(
                    items: [
                      _SummaryItem(label: '홀 수', value: '${holes}홀'),
                      _SummaryItem(label: '총 타수', value: totalStrokes.toString()),
                      _SummaryItem(label: '총 파', value: totalPar.toString()),
                      _SummaryItem(label: '스코어', value: _diffLabel()),
                      _SummaryItem(label: '총 퍼팅', value: totalPutts.toString()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SummarySection(
                    title: '내 티샷 평균',
                    child: Row(
                      children: [
                        _TeeStatItem(
                          label: '좌',
                          imagePath: 'assets/images/img_draw.webp',
                          value: _percentLabel(teeLeft),
                        ),
                        const SizedBox(width: 10),
                        _TeeStatItem(
                          label: '센터',
                          imagePath: 'assets/images/img_straight.webp',
                          value: _percentLabel(teeCenter),
                        ),
                        const SizedBox(width: 10),
                        _TeeStatItem(
                          label: '우',
                          imagePath: 'assets/images/img_fade.webp',
                          value: _percentLabel(teeRight),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SummarySection(
                    title: '퍼팅 요약',
                    child: _SummaryCard(
                      items: [
                        _SummaryItem(label: '총 퍼팅', value: totalPutts.toString()),
                        _SummaryItem(
                          label: '홀당 평균',
                          value: (holes == 0
                                  ? 0
                                  : (totalPutts / holes))
                              .toStringAsFixed(1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem {
  const _SummaryItem({required this.label, required this.value});

  final String label;
  final String value;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.items});

  final List<_SummaryItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      item.value,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _TeeStatItem extends StatelessWidget {
  const _TeeStatItem({
    required this.label,
    required this.imagePath,
    required this.value,
  });

  final String label;
  final String imagePath;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: 36,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
