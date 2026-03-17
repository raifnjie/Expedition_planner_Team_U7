import 'package:flutter/material.dart';

class ExpeditionCard extends StatelessWidget {
  final String title;
  final String dates;
  final String riskLevel;
  final VoidCallback onTap;

  const ExpeditionCard({
    super.key,
    required this.title,
    required this.dates,
    required this.riskLevel,
    required this.onTap,
  });

  Color _riskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'high':
        return Colors.red.shade400;
      case 'medium':
        return Colors.orange.shade400;
      default:
        return Colors.green.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final riskColor = _riskColor(riskLevel);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.green.shade100,
                child: const Icon(Icons.terrain, color: Colors.green),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dates,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: riskColor.withAlpha(35),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$riskLevel Risk',
                        style: TextStyle(
                          color: riskColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}