import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafez_poems/widgets/square_box.dart';

class BoxNamesAndSubNames extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const BoxNamesAndSubNames({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        children: [
          SquareActionBox(icon: icon, title: title, onTap: onTap),
          const SizedBox(height: 0),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontFamily: 'vazir',
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
