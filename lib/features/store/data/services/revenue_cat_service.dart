import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  static final RevenueCatService _instance = RevenueCatService._internal();

  factory RevenueCatService() => _instance;

  RevenueCatService._internal();

  // TODO: Replace with your actual RevenueCat API Key
  // It is recommended to use separate keys for Android and iOS if they are different in RevenueCat
  final String _apiKey = Platform.isAndroid 
      ? "goog_ThwLpqGEEJZZExebhWEendmSKtI" 
      : "test_ZINONBWFkkvrJOqtTGBVPbxYkon";

  final StreamController<CustomerInfo> _customerInfoController = StreamController<CustomerInfo>.broadcast();
  Stream<CustomerInfo> get customerInfoStream => _customerInfoController.stream;

  Future<void> init() async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration;
    configuration = PurchasesConfiguration(_apiKey);
    
    await Purchases.configure(configuration);

    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      _customerInfoController.add(customerInfo);
    });
  }

  Future<Offerings?> getOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        debugPrint("Lalala");
        return offerings;
      } else {
        debugPrint("No current offerings found");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching offerings: $e");
      return null;
    }
  }

  Future<void> purchasePackage(Package package, String expectedUserId) async {
    try {
      final appUserID = await Purchases.appUserID;
      if (appUserID != expectedUserId) {
        debugPrint("User ID mismatch detected. Auto-logging in as $expectedUserId");
        await logIn(expectedUserId);
        
        final newAppUserID = await Purchases.appUserID;
        if (newAppUserID != expectedUserId) {
           throw PlatformException(
            code: 'USER_ID_MISMATCH_AFTER_LOGIN',
            message: 'User ID mismatch persists after login attempt. Purchase aborted.',
            details: {'expected': expectedUserId, 'actual': newAppUserID},
          );
        }
      }

      CustomerInfo customerInfo = (await Purchases.purchasePackage(package)).customerInfo;
      // Update our stream with the new info
      _customerInfoController.add(customerInfo);
      
      bool isPro = customerInfo.entitlements.all["premium"]?.isActive ?? false;
      if (isPro) {
        debugPrint("User is now premium!");
      }
    } catch (e) {
        // User cancelled is a common error to handle
        if (e is PlatformException) {
          var errorCode = PurchasesErrorHelper.getErrorCode(e);
          if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
            debugPrint("Error purchasing package: $e");
          }
        } else {
             debugPrint("Error purchasing package: $e");
        }
    }
  }

  Future<void> restorePurchases() async {
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      _customerInfoController.add(customerInfo);
    } catch (e) {
      debugPrint("Error restoring purchases: $e");
    }
  }

  Future<void> logIn(String userId) async {
    try {
      CustomerInfo customerInfo = await Purchases.logIn(userId).then((value) => value.customerInfo);
      debugPrint("RevenueCat login successful for user: $userId");
      _customerInfoController.add(customerInfo);
    } catch (e) {
      debugPrint("Error logging in to RevenueCat: $e");
    }
  }

  Future<void> logOut() async {
    try {
      await Purchases.logOut();
      debugPrint("RevenueCat logout successful");
    } catch (e) {
      debugPrint("Error logging out from RevenueCat: $e");
    }
  }

  Future<String> get appUserID async => await Purchases.appUserID;
}
