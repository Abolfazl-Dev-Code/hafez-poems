import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';

class AvatarCropScreen extends StatefulWidget {
  final Uint8List imageBytes;

  const AvatarCropScreen({super.key, required this.imageBytes});

  @override
  State<AvatarCropScreen> createState() => _AvatarCropScreenState();
}

class _AvatarCropScreenState extends State<AvatarCropScreen> {
  final CropController _cropController = CropController();
  bool _isCropping = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 12),
              Expanded(
                child: Stack(
                  children: [
                    Crop(
                      image: widget.imageBytes,
                      controller: _cropController,
                      withCircleUi: true,
                      baseColor: Colors.black,
                      maskColor: Colors.black.withValues(alpha: 0.55),
                      radius: 20,
                      cornerDotBuilder: (_, _) => const SizedBox.shrink(),
                      interactive: true,
                      onCropped: (result) {
                        if (!mounted) return;

                        switch (result) {
                          case CropSuccess(:final croppedImage):
                            setState(() => _isCropping = false);
                            Navigator.of(context).pop(croppedImage);
                            break;
                          case CropFailure():
                            setState(() => _isCropping = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('برش تصویر انجام نشد'),
                              ),
                            );
                            break;
                        }
                      },
                    ),

                    if (_isCropping)
                      Container(
                        color: Colors.black26,
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Text(
                  'تصویر را جوری تنظیم کنید که چهره داخل دایره قرار بگیرد.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: _isCropping ? null : () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const Expanded(
            child: Text(
              'برش تصویر پروفایل',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: _isCropping
                ? null
                : () {
                    setState(() => _isCropping = true);
                    _cropController.crop();
                  },
            child: const Text(
              'تأیید',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
