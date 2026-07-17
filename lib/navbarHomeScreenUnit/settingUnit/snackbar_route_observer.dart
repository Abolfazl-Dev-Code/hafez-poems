import 'package:flutter/material.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';

class AppRouteObserver extends NavigatorObserver {
  void _dismissIfPage(Route<dynamic>? route) {
    if (route is PageRoute) {
      AppSnackBarService.dismiss();
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _dismissIfPage(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _dismissIfPage(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

final appRouteObserver = AppRouteObserver();
