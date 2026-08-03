import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/color_style.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hafez_poems/poemsUnit/poems/persian_numbers.dart';

class FalDialog extends StatefulWidget {
  final String title;
  final String poemText;
  final String tabirText;
  final String falNumber;
  const FalDialog({
    super.key,
    required this.title,
    required this.poemText,
    required this.tabirText,
    required this.falNumber,
  });

  @override
  State<FalDialog> createState() => _FalDialogState();
}

class _FalDialogState extends State<FalDialog> {
  late final ScrollController _scrollController;
  bool _showScrollHint = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_scrollController.position.maxScrollExtent > 0) {
        setState(() => _showScrollHint = true);
      }
      _scrollController.addListener(() {
        if (!mounted) return;
        final atBottom =
            _scrollController.offset >=
            _scrollController.position.maxScrollExtent - 16;
        setState(() => _showScrollHint = !atBottom);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: AppRadius.xxlRadius,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ──
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // غزل و شماره — وسط
                    if (widget.falNumber.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.08),
                          borderRadius: AppRadius.smRadius,
                        ),
                        child: Text(
                          'غزل ${widget.falNumber}'.toPersianNumbers(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    // فال حافظ — گوشه راست
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.12),
                          borderRadius: AppRadius.xlRadius,
                        ),
                        child: const Text(
                          'فال حافظ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Scrollable body + fade ──
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.poemText,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(height: 2.2, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          if (widget.tabirText.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Icon(
                                  Icons.auto_awesome_rounded,
                                  size: 14,
                                  color: Color(0xFFA0783A),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'تفسیر',
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Divider(
                                    height: 1,
                                    color: Theme.of(
                                      context,
                                    ).dividerColor.withValues(alpha: 0.35),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.06),
                                borderRadius: AppRadius.mdRadius,
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.15),
                                ),
                              ),
                              child: Text(
                                widget.tabirText,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.9,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ],
                      ),
                    ),

                    // ── fade + arrow ──
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: AnimatedOpacity(
                        opacity: _showScrollHint ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 250),
                        child: IgnorePointer(
                          child: Container(
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Theme.of(context).scaffoldBackgroundColor
                                      .withValues(alpha: 0.0),
                                  Theme.of(context).scaffoldBackgroundColor
                                      .withValues(alpha: 0.95),
                                ],
                              ),
                            ),
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.7),
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Footer ──
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: TextButton(
                    onPressed: Get.back,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.mdRadius,
                      ),
                    ),
                    child: const Text('بستن'),
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
