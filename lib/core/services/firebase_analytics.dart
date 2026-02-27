import 'dart:developer';
import 'package:endless_trivia/core/services/analytics_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService implements AnalyticsService {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsService();

  @override
  Future<void> logLogin({required String method}) async {
    return await analytics.logLogin(loginMethod: method);
  }

  @override
  Future<void> logSignUp({required String method}) async {
    return await analytics.logSignUp(signUpMethod: method);
  }

  @override
  Future<void> logAppOpen() async {
    return await analytics.logAppOpen();
  }

  @override
  Future<void> logError({
    required dynamic error,
    String? customErrorName,
    StackTrace? stackTrace,
    String? screen,
    String? action,
    String? details,
    Map<String, Object>? parameters,
  }) async {
    log('Logging error: $error');
    return await analytics.logEvent(
      name: customErrorName ?? 'error',
      parameters: {
        'error': error.toString(),
        if (stackTrace != null)
          'stackTrace': stackTrace.toString().substring(0, 500),
        if (screen != null) 'screen': screen,
        if (action != null) 'action': action,
        if (details != null) 'details': details,
        ...?parameters,
      },
    );
  }

  @override
  Future<void> logWarning({
    required String warning,
    String? details,
    Map<String, Object>? parameters,
  }) async {
    log('Logging warning: $warning with parameters: $parameters');
    return await analytics.logEvent(
      name: 'warning',
      parameters: {
        'warning': warning,
        if (details != null) 'details': details,
        ...?parameters,
      },
    );
  }

  @override
  Future<void> logInfo({
    required String info,
    Map<String, Object>? parameters,
  }) async {
    log('Logging info: $info with parameters: $parameters');
    return await analytics.logEvent(
      name: 'info',
      parameters: {'info': info, ...?parameters},
    );
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
    Map<String, Object>? parameters,
  }) async {
    return await analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
      parameters: parameters,
    );
  }

  @override
  Future<void> logEvent({
    required String eventName,
    Map<String, Object>? parameters,
  }) async {
    return await analytics.logEvent(name: eventName, parameters: parameters);
  }
}
