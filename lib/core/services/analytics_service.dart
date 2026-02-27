import 'dart:developer';

abstract class AnalyticsService {
  Future<void> logLogin({required String method});
  Future<void> logSignUp({required String method});
  Future<void> logAppOpen();
  Future<void> logError({
    required dynamic error,
    String? customErrorName,
    String? screen,
    String? action,
    String? details,
    StackTrace? stackTrace,
    Map<String, Object>? parameters,
  });
  Future<void> logWarning({
    required String warning,
    String? details,
    Map<String, Object>? parameters,
  });
  Future<void> logInfo({required String info});
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
    Map<String, Object>? parameters,
  });
  Future<void> logEvent({
    required String eventName,
    Map<String, Object>? parameters,
  });
}

class FakeAnalyticsService implements AnalyticsService {
  @override
  Future<void> logAppOpen() async {}

  @override
  Future<void> logError({
    required dynamic error,
    String? customErrorName,
    String? screen,
    String? action,
    String? details,
    StackTrace? stackTrace,
    Map<String, Object>? parameters,
  }) async {
    log("Error log", error: error, stackTrace: stackTrace);
  }

  @override
  Future<void> logEvent({
    required String eventName,
    Map<String, Object>? parameters,
  }) async {
    log("Log Event: $eventName");
  }

  @override
  Future<void> logInfo({required String info}) async {
    log("Info: $info");
  }

  @override
  Future<void> logLogin({required String method}) async {
    log("Login with method: $method");
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
    Map<String, Object>? parameters,
  }) async {
    log("Screen View: $screenName, Class: $screenClass");
  }

  @override
  Future<void> logSignUp({required String method}) async {
    log("Sign Up with method: $method");
  }

  @override
  Future<void> logWarning({
    required String warning,
    String? details,
    Map<String, Object>? parameters,
  }) async {
    log("Warning: $warning, Details: $details");
  }
}
