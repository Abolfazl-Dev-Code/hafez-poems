import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_screen.dart';

class BiographyBanner extends StatelessWidget {
  const BiographyBanner(ThemeData theme, {super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HafezBiographyScreen()),
            );
          },
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.38),
                width: 1,
              ),
              image: const DecorationImage(
                image: AssetImage('assets/icons/hafez-banner.png'),
                fit: BoxFit.cover,
                opacity: 1,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 39),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
