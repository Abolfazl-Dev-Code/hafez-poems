import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_screen_book_cover.dart';
import 'package:hafez_poems/homeScreenUnit/faalUnit/fal_screen.dart';

const _kPanel = Color(0xFF141A3A);
const _kGold = Color(0xFFD4AF37);
const _kCream = Color(0xFFF3ECD9);

class FalBiography extends StatelessWidget {
  const FalBiography({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(42, 36, 42, 36),
        decoration: BoxDecoration(
          color: _kPanel,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _kGold.withValues(alpha: 0.22)),
          boxShadow: [
            BoxShadow(
              color: _kGold.withValues(alpha: 0.06),
              blurRadius: 30,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'یک رسمِ هزارساله',
              style: TextStyle(
                fontFamily: 'vazir',
                fontSize: 14,
                letterSpacing: 3.5,
                color: _kGold.withValues(alpha: 0.88),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'فالی از حافظ',
              style: TextStyle(
                fontFamily: 'vazir',
                fontSize: 23,
                color: _kCream,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'برای گرفتن فال، روی کتاب بزن',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'vazir',
                fontSize: 13,
                color: _kCream.withValues(alpha: 0.52),
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const FalScreen()));
              },
              child: const BookCover(),
            ),
          ],
        ),
      ),
    );
  }
}
