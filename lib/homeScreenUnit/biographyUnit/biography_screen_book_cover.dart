import 'package:flutter/material.dart';

const _kGold = Color(0xFFD4AF37);
const _kGoldDark = Color(0xFFB68B20);

class BookCover extends StatelessWidget {
  const BookCover({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 205,
      height: 275,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 8,
            bottom: 8,
            child: Container(
              width: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xffE6D7A6),
                    Color(0xffD8C48D),
                    Color(0xffC9B57E),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 10,
            top: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff7B2234),
                    Color(0xff651B2B),
                    Color(0xff511321),
                  ],
                ),
                border: Border.all(color: _kGoldDark, width: 1.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .45),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: -40,
                    top: -20,
                    child: Transform.rotate(
                      angle: -.35,
                      child: Container(
                        width: 90,
                        height: 360,
                        color: Colors.white.withValues(alpha: .035),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _kGold.withValues(alpha: .55),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _kGold.withValues(alpha: .25),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 26,
                          color: _kGold.withValues(alpha: .9),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 118,
                          height: 1,
                          color: _kGold.withValues(alpha: .5),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'دیوان',
                          style: TextStyle(
                            fontFamily: 'vazir',
                            color: _kGold,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'حافظ',
                          style: TextStyle(
                            fontFamily: 'vazir',
                            color: _kGold,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          width: 118,
                          height: 1,
                          color: _kGold.withValues(alpha: .5),
                        ),
                        const SizedBox(height: 14),
                        Icon(
                          Icons.auto_awesome,
                          size: 20,
                          color: _kGold.withValues(alpha: .75),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
