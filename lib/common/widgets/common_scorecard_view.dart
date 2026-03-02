import 'package:flutter/material.dart';

class CommonScorecardEntry {
  const CommonScorecardEntry({
    required this.strokes,
    required this.par,
    required this.putts,
  });

  final int strokes;
  final int par;
  final int putts;
}

class CommonScorecardView extends StatelessWidget {
  const CommonScorecardView({
    super.key,
    required this.holes,
    required this.startingHole,
    required this.scores,
    required this.onHoleTap,
  });

  final int holes;
  final int startingHole;
  final Map<int, CommonScorecardEntry> scores;
  final ValueChanged<int> onHoleTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '스코어카드',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          _ScoreCardTable(
            holes: holes,
            startingHole: startingHole,
            scores: scores,
            onHoleTap: onHoleTap,
          ),
        ],
      ),
    );
  }
}

class _ScoreCardTable extends StatelessWidget {
  const _ScoreCardTable({
    required this.holes,
    required this.startingHole,
    required this.scores,
    required this.onHoleTap,
  });

  final int holes;
  final int startingHole;
  final Map<int, CommonScorecardEntry> scores;
  final ValueChanged<int> onHoleTap;

  @override
  Widget build(BuildContext context) {
    final holesList = List<int>.generate(
      holes,
      (index) => ((startingHole - 1 + index) % 18) + 1,
    );
    final chunks = <List<int>>[];
    for (var i = 0; i < holesList.length; i += 9) {
      chunks.add(
        holesList.sublist(
          i,
          i + 9 > holesList.length ? holesList.length : i + 9,
        ),
      );
    }

    return Column(
      children: List.generate(chunks.length, (index) {
        final chunk = chunks[index];
        final totalLabel = chunk.length == 9 ? 'T' : '';
        return Padding(
          padding: EdgeInsets.only(bottom: index == chunks.length - 1 ? 0 : 8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final tableWidth = constraints.maxWidth;
              const labelWidth = 62.0;
              final valueCount = chunk.length + (totalLabel.isNotEmpty ? 1 : 0);
              final cellWidth =
                  ((tableWidth - labelWidth) / valueCount).floorToDouble();

              return Column(
                children: [
                  _HeaderRow(
                    labelWidth: labelWidth,
                    cellWidth: cellWidth,
                    holes: chunk,
                    totalLabel: totalLabel,
                  ),
                  const SizedBox(height: 6),
                  _ValueRow(
                    label: 'PAR',
                    labelWidth: labelWidth,
                    cellWidth: cellWidth,
                    values: chunk
                        .map((hole) => scores[hole]?.par.toString() ?? '')
                        .toList(),
                    totalLabel: totalLabel,
                    totalValue: _sumValues(
                      chunk.map((hole) => scores[hole]?.par).toList(),
                    ),
                    onTap: null,
                  ),
                  _ValueRow(
                    label: 'SCORE',
                    labelWidth: labelWidth,
                    cellWidth: cellWidth,
                    values: chunk
                        .map((hole) => scores[hole]?.strokes.toString() ?? '')
                        .toList(),
                    scoreDiffs: chunk
                        .map((hole) {
                          final entry = scores[hole];
                          if (entry == null) return null;
                          return entry.strokes - entry.par;
                        })
                        .toList(),
                    totalLabel: totalLabel,
                    totalValue: _sumValues(
                      chunk.map((hole) => scores[hole]?.strokes).toList(),
                    ),
                    onTap: (index) => onHoleTap(chunk[index]),
                  ),
                  _ValueRow(
                    label: 'PUTT',
                    labelWidth: labelWidth,
                    cellWidth: cellWidth,
                    values: chunk
                        .map((hole) => scores[hole]?.putts.toString() ?? '')
                        .toList(),
                    totalLabel: totalLabel,
                    totalValue: _sumValues(
                      chunk.map((hole) => scores[hole]?.putts).toList(),
                    ),
                    onTap: null,
                    showDivider: false,
                  ),
                ],
              );
            },
          ),
        );
      }),
    );
  }

  String _sumValues(List<int?> values) {
    final sum = values.fold<int>(0, (acc, val) => acc + (val ?? 0));
    return sum == 0 ? '' : sum.toString();
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.labelWidth,
    required this.cellWidth,
    required this.holes,
    required this.totalLabel,
  });

  final double labelWidth;
  final double cellWidth;
  final List<int> holes;
  final String totalLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: labelWidth),
        ...holes.map(
          (hole) => _HeaderCell(
            width: cellWidth,
            label: hole.toString(),
          ),
        ),
        if (totalLabel.isNotEmpty)
          _HeaderCell(
            width: cellWidth,
            label: totalLabel,
          ),
      ],
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({
    required this.label,
    required this.labelWidth,
    required this.cellWidth,
    required this.values,
    required this.totalLabel,
    required this.totalValue,
    required this.onTap,
    this.scoreDiffs,
    this.showDivider = true,
  });

  final String label;
  final double labelWidth;
  final double cellWidth;
  final List<String> values;
  final String totalLabel;
  final String totalValue;
  final ValueChanged<int>? onTap;
  final List<int?>? scoreDiffs;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final dividerColor = const Color(0xFFF0F0F0);
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: labelWidth,
          height: 28,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: dividerColor),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9A9288),
            ),
          ),
        ),
        ...values.asMap().entries.map(
          (entry) => InkWell(
            onTap: onTap == null ? null : () => onTap!(entry.key),
            child: Container(
              width: cellWidth,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: dividerColor),
                ),
              ),
              child: _ScoreCellText(
                label: label,
                text: entry.value,
                diff: scoreDiffs != null ? scoreDiffs![entry.key] : null,
              ),
            ),
          ),
        ),
        if (totalLabel.isNotEmpty)
          Container(
            width: cellWidth,
            height: 28,
            alignment: Alignment.center,
            child: Text(
              totalValue,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6F665E),
              ),
            ),
          ),
      ],
    );

    return Column(
      children: [
        row,
        if (showDivider) Container(height: 1, color: dividerColor),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    required this.width,
    required this.label,
  });

  final double width;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 18,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF7E756D),
          ),
        ),
      ),
    );
  }
}

class _ScoreCellText extends StatelessWidget {
  const _ScoreCellText({
    required this.label,
    required this.text,
    required this.diff,
  });

  final String label;
  final String text;
  final int? diff;

  @override
  Widget build(BuildContext context) {
    if (label != 'SCORE' || text.isEmpty || diff == null) {
      return Text(
        text,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: label == 'SCORE' ? Colors.black : const Color(0xFF6F665E),
        ),
      );
    }

    final isBirdie = diff! < 0;
    final isBogey = diff! > 0;
    final borderColor =
        isBirdie ? const Color(0xFFE05A5A) : const Color(0xFF5B8CFF);

    if (!isBirdie && !isBogey) {
      return Text(
        text,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      );
    }

    final ringCount = isBirdie
        ? (diff! <= -2 ? 2 : 1)
        : (diff! >= 2 ? 2 : 1);
    final outerSize = 24.0;
    final innerSize = 20.0;

    return SizedBox(
      width: outerSize,
      height: outerSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: outerSize,
            height: outerSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 1.5),
              shape: isBirdie ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: isBirdie ? null : BorderRadius.circular(0),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
          if (ringCount == 2)
            Container(
              width: innerSize,
              height: innerSize,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1.5),
                shape: isBirdie ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: isBirdie ? null : BorderRadius.circular(0),
              ),
            ),
        ],
      ),
    );
  }
}
