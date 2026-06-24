import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/text_style.dart';

// بعد
class CarouselScreenWidget extends StatefulWidget {
  final String initialGhazal;
  final String ghazalNumber; // شماره غزلی که هم‌اکنون نمایش داده می‌شود
  final String imagePath;
  final String changeButtonIcon;
  final String darkImagePath; // عکس تم شب  ← اضافه شد
  final Color lightColor;
  final Color darkColor;
  final VoidCallback onChangeGhazal;

  const CarouselScreenWidget({
    super.key,
    required this.initialGhazal,
    required this.ghazalNumber,
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
  late String _displayedGhazalNumber;

  @override
  void initState() {
    super.initState();
    _displayedGhazal = _extractFirstFourMesras(widget.initialGhazal);
    _displayedGhazalNumber = widget.ghazalNumber;
  }

  @override
  void didUpdateWidget(covariant CarouselScreenWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialGhazal != widget.initialGhazal) {
      _displayedGhazal = _extractFirstFourMesras(widget.initialGhazal);
    }
    if (oldWidget.ghazalNumber != widget.ghazalNumber) {
      _displayedGhazalNumber = widget.ghazalNumber;
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
          // بعد
          Positioned(
            top: 12,
            right: 12,
            left: 120,
            bottom: 0,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 380),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  final slide = Tween<Offset>(
                    begin: const Offset(0, 0.06),
                    end: Offset.zero,
                  ).animate(animation);
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: slide, child: child),
                  );
                },
                child: Text(
                  _displayedGhazal,
                  key: ValueKey(_displayedGhazal),
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
          ),
          // بعد
          Positioned(
            bottom: 8,
            right: 11,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Material(
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
                        duration: const Duration(milliseconds: 320),
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
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    final slide = Tween<Offset>(
                      begin: const Offset(0, 0.06),
                      end: Offset.zero,
                    ).animate(animation);
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: slide, child: child),
                    );
                  },
                  child: Column(
                    key: ValueKey(_displayedGhazalNumber),
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // در محیط RTL یعنی راست‌چین
                    children: [
                      Text(
                        'دیوان حافظ',
                        textAlign: TextAlign.right,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'غزل $_displayedGhazalNumber',
                        textAlign: TextAlign.right,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.55),
                          fontWeight: FontWeight.w400,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
