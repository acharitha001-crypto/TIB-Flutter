import 'package:flutter/material.dart';

/// Horizontal bar chart of subject averages drawn with CustomPainter.
class ScoreBarChart extends StatelessWidget {
  const ScoreBarChart({super.key, required this.data, required this.target});

  final Map<String, double> data;
  final double target;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: data.length * 44.0 + 8,
      child: CustomPaint(
        size: Size.infinite,
        painter: _BarPainter(data, target, scheme.primary, scheme.error,
            scheme.onSurface),
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  _BarPainter(this.data, this.target, this.good, this.bad, this.text);

  final Map<String, double> data;
  final double target;
  final Color good;
  final Color bad;
  final Color text;

  @override
  void paint(Canvas canvas, Size size) {
    const labelW = 120.0;
    final barMax = size.width - labelW - 48;
    var y = 4.0;
    for (final e in data.entries) {
      _text(canvas, e.key, Offset(0, y + 8), labelW - 8, 12);
      final bg = Paint()..color = text.withValues(alpha: 0.08);
      final rect = RRect.fromLTRBR(
          labelW, y + 6, labelW + barMax, y + 30, const Radius.circular(6));
      canvas.drawRRect(rect, bg);
      final fill = Paint()..color = e.value >= target ? good : bad;
      canvas.drawRRect(
          RRect.fromLTRBR(labelW, y + 6, labelW + barMax * e.value / 100,
              y + 30, const Radius.circular(6)),
          fill);
      _text(canvas, '${e.value.round()}%',
          Offset(labelW + barMax + 6, y + 9), 44, 12);
      y += 44;
    }
    // target line
    final tx = labelW + barMax * target / 100;
    final dash = Paint()
      ..color = text.withValues(alpha: 0.5)
      ..strokeWidth = 1.5;
    for (var dy = 0.0; dy < size.height; dy += 8) {
      canvas.drawLine(Offset(tx, dy), Offset(tx, dy + 4), dash);
    }
  }

  void _text(Canvas c, String s, Offset o, double w, double fs) {
    final tp = TextPainter(
      text: TextSpan(text: s, style: TextStyle(color: text, fontSize: fs)),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: w);
    tp.paint(c, o);
  }

  @override
  bool shouldRepaint(covariant _BarPainter old) =>
      old.data != data || old.target != target;
}
