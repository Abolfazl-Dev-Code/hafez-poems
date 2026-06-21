import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/text_style.dart';

class CarouselScreenWidget extends StatefulWidget {
  final String initialGhazal;
  final String imagePath;
  final String changeButtonIcon;
  final String darkImagePath; // عکس تم شب  ← اضافه شد
  final Color lightColor;
  final Color darkColor;
  final VoidCallback onChangeGhazal;

  const CarouselScreenWidget({
    super.key,
    required this.initialGhazal,
    required this.imagePath,
    required this.darkImagePath, // ← اضافه شد
    required this.changeButtonIcon,
    required this.onChangeGhazal,
    required this.lightColor,
    required this.darkColor,
  });

  @override
  State<CarouselScreenWidget> createState() => _CarouselScreenWidgetState();
}

class _CarouselScreenWidgetState extends State<CarouselScreenWidget> {
  double _turns = 0.0;
  late String _displayedGhazal;

  @override
  void initState() {
    super.initState();
    _displayedGhazal = _extractFirstFourMesras(widget.initialGhazal);
  }

  @override
  void didUpdateWidget(covariant CarouselScreenWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialGhazal != widget.initialGhazal) {
      _displayedGhazal = _extractFirstFourMesras(widget.initialGhazal);
    }
  }

  String _extractFirstFourMesras(String text) {
    final normalized = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    final lines = normalized
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .take(4)
        .toList();

    return lines.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? widget.darkColor : widget.lightColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: isDark ? 0.25 : 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: isDark ? 0.28 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: SizedBox(
              width: 145,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      isDark ? widget.darkImagePath : widget.imagePath,
                      fit: BoxFit.cover,
                    ),
                    if (isDark)
                      Container(
                        color: const Color(0xFF2A211B).withValues(alpha: 0.0),
                      ),
                  ],
                ),
              ),
            ),
          ),
          //* text edit
          Positioned(
            top: 12,
            right: 12,
            left: 120,
            bottom: 0,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Text(
                _displayedGhazal,
                textAlign: TextAlign.right,
                softWrap: true,
                overflow: TextOverflow.visible,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colorScheme.onSurface,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 11,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () async {
                  setState(() {
                    _turns += 1;
                  });

                  await Future.delayed(const Duration(milliseconds: 600));

                  if (mounted) {
                    widget.onChangeGhazal();
                  }
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(
                          alpha: isDark ? 0.28 : 0.22,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: AnimatedRotation(
                    turns: _turns,
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeInOutCubic,
                    child: Icon(
                      Icons.refresh,
                      size: 22,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
