import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/default_reciter_controller.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/poem_category_plural_labels.dart';

class DefaultReciterStar extends StatefulWidget {
  final String category;
  final String reciterKey;
  final ColorScheme cs;
  final VoidCallback? onSetDefault;
  final String reciterDisplayName;

  const DefaultReciterStar({
    super.key,
    required this.category,
    required this.reciterKey,
    required this.cs,
    this.onSetDefault,
    required this.reciterDisplayName,
  });

  @override
  State<DefaultReciterStar> createState() => _DefaultReciterStarState();
}

class _DefaultReciterStarState extends State<DefaultReciterStar> {
  late final DefaultReciterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<DefaultReciterController>();
    _controller.addListener(_onChanged);
    _controller.ensureLoaded(widget.category);
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_controller.defaultFor(widget.category)?.reciterKey ==
        widget.reciterKey) {
      return;
    }
    await _controller.setDefault(
      widget.category,
      widget.reciterKey,
      widget.reciterDisplayName,
    );
    if (!mounted) return;
    widget.onSetDefault?.call();
    final label = PoemCategoryPluralLabels.labelFor(widget.category);
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppSnackBarService.success(
        'خواننده پیش‌فرض برای تمامی $label تغییر کرد',
        duration: const Duration(seconds: 3),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDefault =
        _controller.defaultFor(widget.category)?.reciterKey ==
        widget.reciterKey;

    return IconButton(
      icon: Icon(
        isDefault ? Icons.star_rounded : Icons.star_border_rounded,
        size: 20,
        color: isDefault
            ? Colors.amber.shade600
            : widget.cs.onSurface.withValues(alpha: 0.4),
      ),
      onPressed: isDefault ? null : _toggle,
    );
  }
}
