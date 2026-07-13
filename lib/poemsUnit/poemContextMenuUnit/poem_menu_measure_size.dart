import 'package:flutter/widgets.dart';

class MeasureSize extends StatefulWidget {
  const MeasureSize({super.key, required this.child, required this.onChange});

  final Widget child;
  final ValueChanged<Size>? onChange;

  @override
  State<MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  Size? oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = context.size;

      if (size == null) return;

      if (oldSize == size) return;

      oldSize = size;

      widget.onChange?.call(size);
    });

    return widget.child;
  }
}
