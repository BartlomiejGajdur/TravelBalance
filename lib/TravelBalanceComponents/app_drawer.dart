import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/Utils/blur_dialog.dart';
import 'package:TravelBalance/Utils/custom_snack_bar.dart';
import 'package:TravelBalance/models/user.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/providers/user_provider.dart';

enum Option {
  currency,
  changePassword,
  sendFeedback,
  about,
  deleteAccount,
  premiumAccount
}

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage(TravelBalanceProBackgroundPath), context);
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
            const Spacer(),
            clickableListTile(context, "Currency", Option.currency),
            clickableListTile(
                context, "Change password", Option.changePassword),
            clickableListTile(context, "Send feedback", Option.sendFeedback),
            clickableListTile(context, "About us", Option.about),
            clickableListTile(context, "Delete Account", Option.deleteAccount),
            clickableListTile(
                context, "TravelBalance Pro", Option.premiumAccount),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: GestureDetector(
                onTap: () {
                  Provider.of<UserProvider>(context, listen: false)
                      .logout(context);
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
    final User? user = Provider.of<UserProvider>(
      context,
      listen: true,
    ).user;
    String baseCurrencyCode;
    if (user != null) {
      baseCurrencyCode = user.baseCurrency.code;
    } else {
      baseCurrencyCode = defaultCurrencyCode;
    }

    final bool isChangePasswordUnaccessible = option == Option.changePassword &&
        ApiService().loginType != LoginType.Email;
    final bool isPremiumAccount = option == Option.premiumAccount;
    Color setTextColor() {
      if (isPremiumAccount) return premiumColor;

      if (isChangePasswordUnaccessible) return Colors.grey;

      return mainTextColor;
    }

    return GestureDetector(
      onTap: () async {
        if (user == null) return;

        switch (option) {
          case Option.currency:
            showCurrency(context);
            break;
          case Option.changePassword:
            if (!isChangePasswordUnaccessible) {
              moveToChangePassword(context);
            }
            break;
          case Option.sendFeedback:
            showSendFeedback(context);
            break;
          case Option.about:
            showAbout(context);
            break;
          case Option.deleteAccount:
            showDeleteAccount(context);
            break;
          case Option.premiumAccount:
            Navigator.pushNamed(context, "TravelBalanceProPage");
            break;

          default:
        }
      },
      child: ListTile(
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: isChangePasswordUnaccessible ? Colors.grey : secondaryColor,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              givenText,
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: setTextColor(),
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
        padding: EdgeInsets.all(16.w),
        width: 335.w,
        height: 650.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "About Us",
              style: GoogleFonts.outfit(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: mainTextColor,
              ),
            ),

            // Podział na sekcje z ikonami i kolorami
            Expanded(
              child: ListView(
                children: [
                  // Sekcja 1
                  _buildSection(
                    icon: Icons.favorite_rounded,
                    iconColor: Colors.redAccent,
                    title: "Who we are 💡",
                    content:
                        "We are a team of young, passionate developers and avid travelers who created Travel Balance out of our love for both programming and exploring the world.",
                  ),

                  SizedBox(height: 24.h),

                  // Sekcja 2
                  _buildSection(
                    icon: Icons.explore_rounded,
                    iconColor: Colors.greenAccent,
                    title: "Our Inspiration 🌍",
                    content:
                        "As travelers ourselves, we wanted to build a tool that would not only help us track and manage our expenses during our trips but also provide others with an easy and efficient way to handle their travel finances.",
                  ),

                  SizedBox(height: 24.h),

                  // Sekcja 3
                  _buildSection(
                    icon: Icons.check_circle_rounded,
                    iconColor: Colors.tealAccent,
                    title: "Our Goal 🎯",
                    content:
                        "Our goal is to offer a practical solution for managing finances across different countries, helping travelers stay organized and stress-free, no matter where they are.",
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

// Helper do budowania sekcji
Widget _buildSection({
  required IconData icon,
  required Color iconColor,
  required String title,
  required String content,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      SizedBox(height: 8.h),
      Text(
        content,
        style: GoogleFonts.outfit(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF718096),
          letterSpacing: 0.3,
        ),
        textAlign: TextAlign.left,
      ),
    ],
  );
}

void showSendFeedback(BuildContext context) {
  final TextEditingController feedbackController = TextEditingController();
  const int maxLength = 200;
  Set<String> messageType = {"Other"};

  void onSelectionChanged(Set<String> newMessageType) {
    messageType = newMessageType;
  }

  Future<bool> sendFeedback(
      BuildContext context, String message, String type) async {
    bool result = await ApiService()
        .sendFeedback(feedbackController.text, messageType.first);
    if (result == true) {
      Navigator.of(context).pop();
      return true;
    }
    return false;
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
                onTap: () => print(messageType.first),
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
              CustomButton(
                buttonText: "Send Feedback",
                onPressed: () => sendFeedback(
                    context, feedbackController.text, messageType.first),
              )
            ],
          ),
        );
      });
}

class CustomSegmentedWidget extends StatefulWidget {
  final void Function(Set<String>) onSelectionChanged;
  const CustomSegmentedWidget({super.key, required this.onSelectionChanged});

  @override
  State<CustomSegmentedWidget> createState() => _CustomSegmentedWidgetState();
}

class _CustomSegmentedWidgetState extends State<CustomSegmentedWidget> {
  Set<String> _selected = {"Other"};
  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      segments: const <ButtonSegment<String>>[
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

void moveToChangePassword(BuildContext context) {
  Navigator.pushNamed(context, "ChangePasswordPage");
}

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
    onSelect: (Currency newCurrency) async {
      User? user = userProvider.user;
      if (user != null) {
        userProvider.setBaseCurrency(newCurrency);
        try {
          await ApiService().updateBaseCurrency(newCurrency);
        } catch (error) {
          showCustomSnackBar(
              context: context,
              message: error.toString(),
              type: SnackBarType.error);
        }
      }
    },
  );
}

void showDeleteAccount(BuildContext context) {
  TextEditingController confirmationController = TextEditingController();
  ValueNotifier<String?> errorNotifier = ValueNotifier<String?>(null);

  Future<bool> deleteAccount() async {
    if (confirmationController.text == "I want to delete this account") {
      await ApiService().deleteUser();
      Navigator.pop(context);
      Provider.of<UserProvider>(context, listen: false).logout(context);
      return true;
    } else {
      errorNotifier.value = "Type 'I want to delete this account' exactly.";
      return false;
    }
  }

  showBlurDialog(
      context: context,
      childBuilder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red, // Red border for the container
              width: 2.w,
            ),
            borderRadius: BorderRadius.circular(24.r),
          ),
          padding: const EdgeInsets.all(0),
          width: 335.w,
          height: 400.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Danger Zone!",
                style: GoogleFonts.outfit(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.red, // Red text for the heading
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.0.w),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text:
                        "Deleting your account is permanent and cannot be undone. Please confirm your decision by typing ",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF718096),
                      letterSpacing: 0.3,
                    ),
                    children: [
                      TextSpan(
                        text: "'I want to delete this account'",
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.red,
                        ),
                      ),
                      TextSpan(
                        text: " in the box below.",
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.0.w),
                child: ValueListenableBuilder<String?>(
                  valueListenable: errorNotifier,
                  builder: (context, error, _) {
                    return Column(
                      children: [
                        TextFormField(
                          controller: confirmationController,
                          decoration: InputDecoration(
                            hintText: "I want to delete this account",
                            hintStyle: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              color: const Color(0xFF718096),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: primaryColor,
                              ),
                            ),
                            errorText: error,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              CustomButton(
                buttonText: "Delete Account",
                onPressed: deleteAccount,
              ),
            ],
          ),
        );
      });
}
