import 'package:flutter/material.dart';

/// Gradient card on the dashboard showing today's progress.
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.completionRate,
    required this.pending,
    required this.overall,
  });

  final double completionRate;
  final int pending;
  final double overall;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            height: 84,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: completionRate,
                    strokeWidth: 8,
                    backgroundColor: Colors.white24,
                    color: Colors.white,
                  ),
                ),
                Text('${(completionRate * 100).round()}%',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tasks completed',
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 4),
                Text('$pending pending',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Overall score ${overall.toStringAsFixed(1)}%',
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
