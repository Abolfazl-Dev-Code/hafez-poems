import 'package:flutter/material.dart';

const _kGold = Color(0xFFD4AF37);
const _kCream = Color(0xFFF3ECD9);

class AutoScrollButton extends StatelessWidget {
  final bool autoScrolling;
  final VoidCallback onTap;

  const AutoScrollButton({
    super.key,
    required this.autoScrolling,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xDD141A3A),
          border: Border.all(color: _kGold.withValues(alpha: 0.35)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              autoScrolling ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: _kGold,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              autoScrolling ? 'توقف اسکرول' : 'برای اسکرول خودکار کلیک کنید',
              style: TextStyle(
                fontFamily: 'vazir',
                fontSize: 12,
                color: _kCream.withValues(alpha: 0.80),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
