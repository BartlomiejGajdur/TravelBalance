import 'package:TravelBalance/Utils/custom_snack_bar.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:TravelBalance/services/in_app_purchase_service.dart';
import 'package:url_launcher/url_launcher.dart';

class TravelBalanceProPage extends StatefulWidget {
  TravelBalanceProPage({super.key});

  @override
  State<TravelBalanceProPage> createState() => _TravelBalanceProPageState();
}

class _TravelBalanceProPageState extends State<TravelBalanceProPage> {
  final InAppPurchaseUtils inAppPurchaseUtils = InAppPurchaseUtils();
  final String productId = "com.domainname.travelbalance.premium";
  Future<String?>? productPrice;

  @override
  void initState() {
    inAppPurchaseUtils.initialize(context);
    productPrice = inAppPurchaseUtils.getProductPrice(context, productId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "TravelBalance Pro",
          style: GoogleFonts.outfit(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        backgroundColor: premiumColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(TravelBalanceProBackgroundPath),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.h),
            Row(
              children: [
                SizedBox(
                  width: 21.w,
                ),
                RichText(
                  text: TextSpan(
                      style: GoogleFonts.outfit(
                          fontSize: 24.sp, color: mainTextColor),
                      children: [
                        TextSpan(text: "Upgrade to\n"),
                        TextSpan(
                          text: "TravelBalance",
                          style: GoogleFonts.outfit(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                        TextSpan(text: " Pro")
                      ]),
                ),
              ],
            ),
            SizedBox(height: 65.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 21.w),
              child: Text(
                "Enjoy a fully ad-free experience and support the two passionate creators behind the app!",
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.outfit(fontSize: 16.sp, color: mainTextColor),
              ),
            ),
            SizedBox(height: 15.h),
            FeatureItem(text: "🚫 Ad-free experience"),
            FeatureItem(text: "🤝 Support independent creators"),
            FeatureItem(text: "📊 Access to new features first"),
            FeatureItem(text: "🌟 Lifetime access"),
            SizedBox(height: 15.h),
            FutureBuilder<String?>(
              future: productPrice,
              builder: (context, snapshot) {
                String buttonText;

                if (snapshot.connectionState == ConnectionState.waiting) {
                  buttonText = "Loading...";
                } else if (snapshot.hasError) {
                  buttonText = "Error loading price";
                } else if (snapshot.hasData && snapshot.data != null) {
                  buttonText = "${snapshot.data} / Lifetime";
                } else {
                  buttonText = "Unavailable";
                }

                return InAppPurchaseButton(
                  buttonText: buttonText,
                  onPressed: () async {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData &&
                        snapshot.data != null) {
                      return await inAppPurchaseUtils.buyNonConsumableProduct(
                          context, productId);
                    } else {
                      showCustomSnackBar(
                          context: context,
                          message: "Price not available",
                          type: SnackBarType.warning);

                      return false;
                    }
                  },
                  type: InAppPurchaseButtonType.purchase,
                );
              },
            ),
            SizedBox(height: 20.h),
            InAppPurchaseButton(
                buttonText: "Restore purchase",
                onPressed: () async {
                  // showCustomSnackBar(
                  //     context: context,
                  //     message: "To be implemented soon! :) ",
                  //     type: SnackBarType.information);
                  // return false;
                  return await inAppPurchaseUtils.restorePurchases(context);
                },
                type: InAppPurchaseButtonType.restore),
            SizedBox(height: 23.h),
            InfoText(),
          ],
        ),
      ),
    );
  }
}

class InfoText extends StatelessWidget {
  const InfoText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 220.w,
        height: 64.h,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                color: secondaryTextColor,
              ),
              children: [
                TextSpan(
                  text: "This is a one-time purchase.\n",
                ),
                WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20.0.h),
                  ),
                ),
                TextSpan(text: "No recurring fees, no surprises.\n"),
                WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20.0.h),
                  ),
                ),
                hyperlinkTextSpan(
                    "Terms of Use", "https://travelbalance.pl/terms-of-use/"),
                WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(right: 5.0),
                  ),
                ),
                hyperlinkTextSpan("Privacy Policy",
                    "https://travelbalance.pl/privacy-policy/"),
              ]),
        ),
      ),
    );
  }
}

TextSpan hyperlinkTextSpan(String text, String url) {
  return TextSpan(
    text: text,
    style: const TextStyle(
      color: premiumColor,
      decoration: TextDecoration.underline,
    ),
    recognizer: TapGestureRecognizer()..onTap = () => launchUrl(Uri.parse(url)),
  );
}

class FeatureItem extends StatelessWidget {
  final String text;

  const FeatureItem({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0.h, horizontal: 64.w),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: "Outfit",
          fontSize: 16,
          color: mainTextColor,
        ),
      ),
    );
  }
}

enum InAppPurchaseButtonType { purchase, restore }

class InAppPurchaseButton extends StatefulWidget {
  final String buttonText;
  final Future<bool> Function() onPressed;
  final InAppPurchaseButtonType type;
  InAppPurchaseButton(
      {super.key,
      required this.buttonText,
      required this.onPressed,
      required this.type});

  @override
  State<InAppPurchaseButton> createState() => _InAppPurchaseButtonState();
}

class _InAppPurchaseButtonState extends State<InAppPurchaseButton> {
  bool isLoading = false;

  void onPressed() {
    setState(() {
      isLoading = true;
    });
    widget.onPressed();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isPurchase() {
      return widget.type == InAppPurchaseButtonType.purchase;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(Size(double.infinity, 56.h)),
          backgroundColor: WidgetStateProperty.all(
              isPurchase() ? premiumColor : Colors.white),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius),
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: Colors.white,
                ),
              )
            : Text(widget.buttonText,
                style: isPurchase() ? buttonTextStyle : buttonTextStyle_2),
      ),
    );
  }
}
