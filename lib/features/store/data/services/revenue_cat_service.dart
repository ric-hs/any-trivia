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

  Future<void> purchasePackage(Package package) async {
    try {
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
}
