import 'package:TravelBalance/pages/forgotPassword/reset_password_page.dart';
import 'package:TravelBalance/pages/forgotPassword/verification_code_page.dart';
import 'package:TravelBalance/pages/introduction_screens.dart';
import 'package:TravelBalance/pages/sign_up_page.dart';
import 'package:TravelBalance/pages/trip_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:TravelBalance/pages/login_page.dart';

import 'package:TravelBalance/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* HELPERS
Navigator.pushNamed(context, LoginPage);


SvgPicture.asset(
                  "lib/assets/Logout.svg",
                  height: 27.h,
                  width: 114.w,
                ),
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool wasIntroductionScreenShown =
      prefs.getBool('wasIntroductionScreenShown') ?? false;

  runApp(MyApp(wasIntroductionScreenShown: wasIntroductionScreenShown));
}

class MyApp extends StatelessWidget {
  final bool wasIntroductionScreenShown;

  const MyApp({super.key, required this.wasIntroductionScreenShown});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          home: wasIntroductionScreenShown
              ? const LoginPage()
              : IntroductionPage(),
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
              )),
          routes: {
            'LoginPage': (context) => const LoginPage(),
            'SignUpPage': (context) => const SignUpPage(),
            'TripListPage': (context) => const TripListPage(),
            'ForgotPasswordPage': (context) => ForgotPasswordPage(),
            'VerificationCodePage': (context) => VerificationCodePage(),
          },
        ),
      ),
    );
  }
}
