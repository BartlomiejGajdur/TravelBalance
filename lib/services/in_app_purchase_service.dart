import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:TravelBalance/Utils/custom_snack_bar.dart';

class InAppPurchaseUtils {
  // Instance of InAppPurchase
  final InAppPurchase _iap = InAppPurchase.instance;

  // StreamSubscription for purchase updates
  late StreamSubscription<List<PurchaseDetails>> _purchasesSubscription;

  // Method to initialize the purchase process
  Future<void> initialize(BuildContext context) async {
    if (!(await _iap.isAvailable())) {
      showCustomSnackBar(
          context: context,
          message: "In-app purchases are not available on this device.",
          type: SnackBarType.error);
      return;
    }

    // Listen to purchase updates
    _purchasesSubscription = _iap.purchaseStream.listen((purchaseDetailsList) {
      handlePurchaseUpdates(context, purchaseDetailsList);
    }, onDone: () {
      _purchasesSubscription.cancel();
    }, onError: (error) {
      showCustomSnackBar(
          context: context, message: "Error: $error", type: SnackBarType.error);
    });
  }

  // Handle purchase updates
  Future<void> handlePurchaseUpdates(
      BuildContext context, List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      var purchaseStatus = purchaseDetails.status;
      switch (purchaseStatus) {
        case PurchaseStatus.pending:
          showCustomSnackBar(context: context, message: 'Purchase is pending.');
          break;
        case PurchaseStatus.error:
          showCustomSnackBar(
              context: context,
              message: 'Purchase failed with error.',
              type: SnackBarType.error);
          break;
        case PurchaseStatus.canceled:
          showCustomSnackBar(
              context: context,
              message: 'Purchase was canceled.',
              type: SnackBarType.warning);
          break;
        case PurchaseStatus.purchased:
          showCustomSnackBar(context: context, message: 'Purchase successful.');
          if (purchaseDetails.pendingCompletePurchase) {
            await _iap.completePurchase(purchaseDetails);
            showCustomSnackBar(
                context: context,
                message: 'Purchase completed.',
                type: SnackBarType.correct);
            //
            // Send to Api !
            //
          }
          break;
        case PurchaseStatus.restored:
          showCustomSnackBar(
              context: context,
              message: 'Purchase restored.',
              type: SnackBarType.correct);
          break;
      }
    }
  }

  // Method to purchase a non-consumable product
  Future<void> buyNonConsumableProduct(
      BuildContext context, String productId) async {
    try {
      Set<String> productIds = {productId};
      final ProductDetailsResponse response =
          await _iap.queryProductDetails(productIds);
      if (response.error != null) {
        showCustomSnackBar(
            context: context,
            message: 'Failed to load products: ${response.error}',
            type: SnackBarType.error);
        return;
      }
      final ProductDetails productDetails = response.productDetails.first;
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productDetails);
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      showCustomSnackBar(
          context: context,
          message: 'Failed to buy non-consumable product: $e',
          type: SnackBarType.error);
    }
  }

  Future<String?> getProductPrice(
      BuildContext context, String productId) async {
    try {
      Set<String> productIds = {productId};
      final ProductDetailsResponse response =
          await _iap.queryProductDetails(productIds);

      if (response.error != null || response.productDetails.isEmpty) {
        return null;
      }

      final ProductDetails productDetails = response.productDetails.first;
      return productDetails.price;
    } catch (e) {
      return null;
    }
  }

  // Method to purchase a consumable product
  Future<void> buyConsumableProduct(
      BuildContext context, String productId) async {
    try {
      Set<String> productIds = {productId};
      final ProductDetailsResponse response =
          await _iap.queryProductDetails(productIds);
      if (response.error != null) {
        showCustomSnackBar(
            context: context,
            message: 'Failed to load products: ${response.error}',
            type: SnackBarType.error);
        return;
      }
      final ProductDetails productDetails = response.productDetails.first;
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productDetails);
      await _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: true);
    } catch (e) {
      showCustomSnackBar(
          context: context,
          message: 'Failed to buy consumable product: $e',
          type: SnackBarType.error);
    }
  }

  // Method to restore purchases
  Future<bool> restorePurchases(BuildContext context) async {
    try {
      await _iap.restorePurchases();
      showCustomSnackBar(
          context: context,
          message: 'Restore purchases correct!',
          type: SnackBarType.correct);
      return true;
    } catch (error) {
      showCustomSnackBar(
          context: context,
          message: 'Failed to restore purchases: $error',
          type: SnackBarType.error);
      return false;
    }
  }
}