import 'dart:async';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:TravelBalance/Utils/custom_snack_bar.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
            Provider.of<UserProvider>(context, listen: false)
                .user!
                .setPremiumUser(true);

            //WEBHOOK OR API SEND FOR SAVING IN DB
            //

            // Wyświetlenie okienka z danymi
            final purchaseData = '''
Transaction ID: ${purchaseDetails.purchaseID ?? "NULL"}
Product ID: ${purchaseDetails.productID}
Purchase Token Android: ${purchaseDetails.verificationData.serverVerificationData}
Purchase Token IOS: ${purchaseDetails.verificationData.localVerificationData}
Platform: ${Theme.of(context).platform}
    ''';

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Purchase Details'),
                  content: SingleChildScrollView(
                    child: SelectableText(purchaseData),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: purchaseData));
                        Navigator.of(context).pop(); // Zamknięcie dialogu
                        showCustomSnackBar(
                          context: context,
                          message: 'Copied to clipboard.',
                          type: SnackBarType.correct,
                        );
                      },
                      child: const Text('Copy to Clipboard'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Zamknięcie dialogu
                      },
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );

            //
            // Send to API!
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
  Future<bool> buyNonConsumableProduct(
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
        return false;
      }
      final ProductDetails productDetails = response.productDetails.first;
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productDetails);
      return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      showCustomSnackBar(
          context: context,
          message: 'Failed to buy non-consumable product: $e',
          type: SnackBarType.error);
      return false;
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
