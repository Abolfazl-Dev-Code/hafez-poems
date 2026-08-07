part of 'splash_screen.dart';

class _DecorativeCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _DecorativeCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _LogoWidget extends StatelessWidget {
  final Color primaryColor;
  final bool isLight;

  const _LogoWidget({required this.primaryColor, required this.isLight});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primaryColor.withValues(alpha: 0.1),
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.15),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Image.asset(
            'assets/icons/hafez-logo.png',
            width: 100,
            height: 100,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'حافظ',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 36,
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.bold,
            color: primaryColor,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'دیوان شعر',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 14,
            fontFamily: AppTextStyles.fontFamily,
            color: primaryColor.withValues(alpha: 0.6),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _StatusWidget extends StatelessWidget {
  final _ConnectionStatus status;
  final Color primaryColor;
  final bool isLight;

  const _StatusWidget({
    required this.status,
    required this.primaryColor,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, message, color) = switch (status) {
      _ConnectionStatus.online => (
        Icons.check_circle_outline_rounded,
        'اتصال شما به اینترنت برقرار است',
        const Color(0xFF2E7D32),
      ),
      _ConnectionStatus.offline => (
        Icons.wifi_off_rounded,
        'اتصال شما به اینترنت برقرار نیست \n اشعار آفلاین در دسترس هستند',
        const Color(0xFFE65100),
      ),
      _ConnectionStatus.vpn => (
        Icons.vpn_lock_rounded,
        'برای کارکرد صحیح برنامه و پخش شدن اشعار\n لطفا VPN خود را خاموش کنید',
        const Color(0xFF1565C0),
      ),
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isLight ? 0.08 : 0.15),
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              message,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontFamily: AppTextStyles.fontFamily,
                color: color,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _ConnectionStatus { online, offline, vpn }
