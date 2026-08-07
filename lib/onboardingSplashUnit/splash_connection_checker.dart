part of 'splash_screen.dart';

extension _SplashConnectionChecker on _SplashScreenState {
  Future<bool> _isVpnActive() async {
    try {
      final interfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.any,
      );

      for (final interface in interfaces) {
        final name = interface.name.toLowerCase();

        if (name.contains('tun') ||
            name.contains('ppp') ||
            name.contains('pptp') ||
            name.contains('ipsec') ||
            name.contains('utun') ||
            name.contains('wg')) {
          return true;
        }
      }
    } catch (_) {}
    return false;
  }

  Future<bool> _hasInternetAccess() async {
    HttpClient? client;
    try {
      client = HttpClient()..connectionTimeout = const Duration(seconds: 5);
      final request = await client.getUrl(
        Uri.parse('https://clients3.google.com/generate_204'),
      );
      final response = await request.close();
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (_) {
      return false;
    } finally {
      client?.close(force: true);
    }
  }

  Future<_ConnectionStatus> _checkConnection() async {
    try {
      final result = await Connectivity().checkConnectivity();
      if (result.contains(ConnectivityResult.none)) {
        return _ConnectionStatus.offline;
      }
      if (result.contains(ConnectivityResult.vpn)) {
        return _ConnectionStatus.vpn;
      }
      if (await _isVpnActive()) {
        return _ConnectionStatus.vpn;
      }
      final hasInternet = await _hasInternetAccess();
      return hasInternet ? _ConnectionStatus.online : _ConnectionStatus.offline;
    } catch (_) {
      return _ConnectionStatus.offline;
    }
  }

  Future<void> _startSequence() async {
    await _logoController.forward();
    _pulseController.repeat();
    final status = await _checkConnection();
    _pulseController.stop();
    await _pulseController.animateTo(1.0);
    if (!mounted) return;
    _setConnectionStatus(status);
    await _statusController.forward();
    await Future.delayed(
      status == _ConnectionStatus.vpn
          ? const Duration(seconds: 2)
          : const Duration(milliseconds: 1500),
    );
    await _navigate();
  }

  Future<void> _navigate() async {
    if (_navigated || !mounted) return;
    _navigated = true;
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;
    Get.offAll(
      () => seenOnboarding ? const BottomNavBar() : const OnboardingScreen(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 600),
    );
  }
}
