import 'package:hafez_poems/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_theme.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:flutter/services.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_screen_book_cover.dart';
import 'package:hafez_poems/homeScreenUnit/faalUnit/fal_screen.dart';

const _kPanelTop = Color(0xFF1B2147);
const _kPanelBottom = Color(0xFF121735);

const _kGold = BiographyColors.gold;
const _kCream = BiographyColors.cream;

class FalBiography extends StatelessWidget {
  const FalBiography({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: AppRadius.xxlRadius,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_kPanelTop, _kPanelBottom],
        ),
        border: Border.all(color: _kGold.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: _kGold.withValues(alpha: 0.05),
            blurRadius: 35,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 25,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: AppRadius.xxlRadius,
          border: Border.all(color: Colors.white.withValues(alpha: .035)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(42, 38, 42, 42),
          child: Column(
            children: [
              Text(
                'رسمی از هزار سال عشق',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16,
                  letterSpacing: 4,
                  color: _kGold.withValues(alpha: .9),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: _kGold.withValues(alpha: .25),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Icon(
                      Icons.auto_awesome,
                      size: 18,
                      color: _kGold.withValues(alpha: .85),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: _kGold.withValues(alpha: .25),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'دل به حافظ بسپار و برای\nدیدن راهت روی کتاب بزن',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 14,
                  height: 1.8,
                  color: _kCream.withValues(alpha: .68),
                ),
              ),
              const SizedBox(height: 36),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: AppRadius.smRadius,
                  splashColor: _kGold.withValues(alpha: .10),
                  highlightColor: Colors.transparent,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FalScreen()),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(AppSpacing.xs),
                    child: BookCover(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
