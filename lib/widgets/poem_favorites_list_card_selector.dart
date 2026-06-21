import 'package:flutter/material.dart';

class PoemFavoritesListCardSelector extends StatelessWidget {
  final bool isSelected;
  final ColorScheme colorScheme;

  const PoemFavoritesListCardSelector({
    super.key,
    required this.isSelected,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? colorScheme.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? colorScheme.primary : colorScheme.outline,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }
}
