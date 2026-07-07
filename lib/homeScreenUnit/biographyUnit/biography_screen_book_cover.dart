import 'package:flutter/material.dart';

const _kGold = Color(0xFFD4AF37);
const _kGoldSoft = Color(0xFFC9A227);
const _kWine = Color(0xFF7A2436);

class BookCover extends StatelessWidget {
  const BookCover({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 256,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6B1A28), _kWine, Color(0xFF4D1320)],
        ),
        border: Border.all(color: _kGoldSoft, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_rounded, color: _kGold, size: 40),
          SizedBox(height: 12),
          Text(
            'دیوان حافظ',
            style: TextStyle(
              fontFamily: 'vazir',
              color: _kGold,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
