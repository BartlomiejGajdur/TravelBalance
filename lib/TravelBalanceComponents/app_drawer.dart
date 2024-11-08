import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/Utils/blur_dialog.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:TravelBalance/services/google_signin_api.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:TravelBalance/pages/login_page.dart';

enum Option {
  currency,
  changePassword,
  sendFeedback,
  about,
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300.w,
      child: SafeArea(
        bottom: true,
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Text(
              "Hey, Captain of Control!",
              style: GoogleFonts.outfit(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: mainTextColor,
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              "Feel like tweaking something?\nUpdate your settings here - your app, your rules!",
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 21.w),
              child: const Divider(color: Color(0xFFD9D9D9)),
            ),
            SizedBox(height: 15.h),
            SvgPicture.asset(
              "lib/assets/TwoGuysOneTent.svg",
              height: 214.h,
              width: 270.w,
            ),
            SizedBox(height: 53.h),
            clickableListTile(context, "Currency", Option.currency),
            clickableListTile(
                context, "Change password", Option.changePassword),
            clickableListTile(context, "Send feedback", Option.sendFeedback),
            clickableListTile(context, "About", Option.about),
            const Spacer(), // Użyj Spacer, aby wypchnąć SVG na dół
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                  final tokenType = ApiService().getToken();
                  if (tokenType == BaseTokenType.Token) {
                    Provider.of<UserProvider>(context, listen: false).logout();
                  } else if (tokenType == BaseTokenType.Bearer) {
                    GoogleSignInApi().logout(context);
                  }
                },
                child: SvgPicture.asset(
                  "lib/assets/Logout.svg",
                  height: 27.h,
                  width: 114.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget clickableListTile(
      BuildContext context, String givenText, Option option,
      [String? moveTo]) {
    final String baseCurrencyCode = Provider.of<UserProvider>(
      context,
      listen: true,
    ).user!.baseCurrency.code;

    return GestureDetector(
      onTap: () {
        switch (option) {
          case Option.currency:
            showCurrency(context);
            break;
          case Option.changePassword:
            moveToChangePassword(context);
            break;
          case Option.sendFeedback:
            showSendFeedback(context);
            break;
          case Option.about:
            showAbout(context);
            break;

          default:
        }
      },
      child: ListTile(
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: secondaryColor,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              givenText,
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: mainTextColor,
              ),
            ),
            option == Option.currency
                ? Text(
                    baseCurrencyCode,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: secondaryTextColor,
                    ),
                  )
                : const Text(""),
          ],
        ),
      ),
    );
  }
}

void showAbout(BuildContext context) {
  showBlurDialog(
      context: context,
      childBuilder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(0),
          width: 335.w,
          height: 300.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "About Travel Balance",
                style: GoogleFonts.outfit(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: mainTextColor,
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.0.w),
                child: Text(
                  "Travel Balance is an app designed to simplify expense management during your travels. It helps you monitor costs, manage budgets, and log travel-related expenses effortlessly. Our goal is to provide a convenient tool for tracking expenses across different countries, making it easier to manage your finances on the go.",
                  style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF718096),
                      letterSpacing: 0.3),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        );
      });
}

void showSendFeedback(BuildContext context) {
  final TextEditingController feedbackController = TextEditingController();
  const int maxLength = 200;
  Set<String> _messageType = {"Other"};

  void onSelectionChanged(Set<String> newMessageType) {
    _messageType = newMessageType;
  }

  showBlurDialog(
      context: context,
      childBuilder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(0),
          width: 335.w,
          height: 460.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 15.h),
              GestureDetector(
                onTap: () => print(_messageType.first),
                child: Text(
                  "Share your feedback",
                  style: GoogleFonts.outfit(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: mainTextColor,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.0.w),
                child: Text(
                  "We value your input! Let us know how we can improve.",
                  style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF718096),
                      letterSpacing: 0.3),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: CustomSegmentedWidget(
                  onSelectionChanged: onSelectionChanged,
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 17.0.w),
                  child: TextField(
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    maxLength: maxLength,
                    controller: feedbackController,
                    minLines: 8,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText:
                          "How’s the app treating you? Found any hidden travel gems yet?",
                      hintStyle: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF718096),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: primaryColor, width: 1.0),
                        borderRadius: BorderRadius.circular(16.0.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: secondaryColor, width: 2.0),
                        borderRadius: BorderRadius.circular(16.0.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 7.0.h,
                        horizontal: 16.0,
                      ),
                    ),
                  )),
              SizedBox(height: 4.h),
              const CustomButton(buttonText: "Send Feedback")
            ],
          ),
        );
      });
}

class CustomSegmentedWidget extends StatefulWidget {
  void Function(Set<String>) onSelectionChanged;
  CustomSegmentedWidget({super.key, required this.onSelectionChanged});

  @override
  State<CustomSegmentedWidget> createState() => _CustomSegmentedWidgetState();
}

class _CustomSegmentedWidgetState extends State<CustomSegmentedWidget> {
  Set<String> _selected = {"Other"};
  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      segments: <ButtonSegment<String>>[
        ButtonSegment<String>(value: "Issue", label: Text("Issue")),
        ButtonSegment<String>(value: "Suggestion", label: Text("Suggestion")),
        ButtonSegment<String>(value: "Other", label: Text("Other")),
      ],
      selected: _selected,
      showSelectedIcon: false,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return secondaryColor;
            }
            return Colors.grey[200]!;
          },
        ),
      ),
      onSelectionChanged: (Set<String> newValue) {
        setState(() {
          _selected = newValue;
        });
        widget.onSelectionChanged(newValue);
      },
    );
  }
}

void moveToChangePassword(BuildContext context) {}

void showCurrency(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(
    context,
    listen: false,
  );
  showCurrencyPicker(
    context: context,
    showFlag: true,
    showCurrencyName: true,
    showCurrencyCode: true,
    onSelect: (Currency newCurrency) {
      userProvider.setBaseCurrency(newCurrency);
    },
  );
}
