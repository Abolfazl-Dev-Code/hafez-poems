import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';

class FalIntentionCard extends StatelessWidget {
  const FalIntentionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Text(
          'ابتدا نیت کنید:\n'
          'ای حافظ شیرازی! تو محرم هر رازی!\n'
          'تو را به خدا و به شاخ نباتت قسم می‌دهم\n'
          'که هر چه صلاح و مصلحت می‌بینی\n برایم آشکار کن\n'
          'و آرزوی مرا برآورده سازی.',
          style: textTheme.bodyLarge?.copyWith(height: 1.8, fontSize: 17.5),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
