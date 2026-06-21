import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafez_poems/screens/fal_screen.dart';

class FalBanner extends StatelessWidget {
  const FalBanner(ThemeData theme, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const FalScreen()));
          },
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.38),
                width: 1,
              ),
              image: const DecorationImage(
                image: AssetImage('assets/icon/faal-banner.png'),
                fit: BoxFit.fitWidth,
                opacity: 1,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
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
