import 'package:TravelBalance/Utils/country_picker.dart';
import 'package:TravelBalance/pages/add_expense_page.dart';
import 'package:TravelBalance/pages/forgotPassword/create_new_password_page.dart';
import 'package:TravelBalance/pages/forgotPassword/reset_password_page.dart';
import 'package:TravelBalance/pages/forgotPassword/verification_code_page.dart';
import 'package:TravelBalance/pages/introduction_screens.dart';
import 'package:TravelBalance/pages/login_page.dart';
import 'package:TravelBalance/pages/sign_up_page.dart';
import 'package:TravelBalance/pages/trip_list_page.dart';
import 'package:TravelBalance/pages/create_trip_page.dart';
import 'package:TravelBalance/providers/trip_provider.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:TravelBalance/services/hive_currency_rate_storage.dart';
import 'package:TravelBalance/services/hive_last_used_currency_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
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

  await Hive.initFlutter();
  await CurrencyRatesStorage().initialize();
  await LastUsedCurrencyStorage().initialize();

  await CountryPicker.loadCountryData();

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
            ),
          ),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case 'LoginPage':
                return MaterialPageRoute(
                    builder: (context) => const LoginPage());
              case 'SignUpPage':
                return MaterialPageRoute(
                    builder: (context) => const SignUpPage());
              case 'TripListPage':
                return MaterialPageRoute(
                    builder: (context) => const TripListPage());
              case 'ForgotPasswordPage':
                return MaterialPageRoute(
                    builder: (context) => ForgotPasswordPage());
              case 'VerificationCodePage':
                final email = settings.arguments as String;
                return MaterialPageRoute(
                  builder: (context) => VerificationCodePage(email: email),
                );
              case 'CreateNewPasswordPage':
                final args = settings.arguments as Map<String, String>;
                final email = args['email']!;
                final verificationCode = args['verificationCode']!;
                return MaterialPageRoute(
                  builder: (context) => CreateNewPasswordPage(
                      email: email, verificationCode: verificationCode),
                );
              case 'CreateListPage':
                final mainPageContext = settings.arguments as BuildContext;
                return MaterialPageRoute(
                    builder: (context) =>
                        CreateTripPage(mainPageContext: mainPageContext));
              case 'CreateExpensePage':
                final arguments = settings.arguments as Map<String, dynamic>;
                final expenseListPageContext =
                    arguments['expenseListPageContext'] as BuildContext;
                final tripProvider = arguments['tripProvider'] as TripProvider;
                return MaterialPageRoute(
                  builder: (context) => CreateExpensePage(
                    expenseListPageContext: expenseListPageContext,
                    tripProvider: tripProvider,
                  ),
                );
              default:
                return null;
            }
          },
        ),
      ),
    );
  }
}
