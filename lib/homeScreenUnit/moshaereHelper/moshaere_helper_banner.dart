import 'package:flutter/material.dart';

class MoshaereBanner extends StatelessWidget {
  const MoshaereBanner(ThemeData theme, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            null;
            // HapticFeedback.mediumImpact();
            // Navigator.of(
            //   context,
            // ).push(MaterialPageRoute(builder: (_) => const FalScreen()));
          },
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.68),
                width: 1,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 30),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      'کمک مشاعره به زودی...',
                      style: TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 18,
                        color: Color(0xFFD4AF37),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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
