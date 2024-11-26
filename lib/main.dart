import 'package:TravelBalance/Utils/country_picker.dart';
import 'package:TravelBalance/pages/add_expense_page.dart';
import 'package:TravelBalance/pages/change_password_page.dart';
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
import 'package:TravelBalance/services/api_service.dart';
import 'package:TravelBalance/services/hive_currency_rate_storage.dart';
import 'package:TravelBalance/services/hive_last_used_currency_storage.dart';
import 'package:TravelBalance/services/secure_storage_service.dart';
import 'package:TravelBalance/services/shared_prefs_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

/* HELPERS
Navigator.pushNamed(context, LoginPage);

SvgPicture.asset(
                  "lib/assets/Logout.svg",
                  height: 27.h,
                  width: 114.w,
                ),
*/

Future<SecretKeys> loadSecrets() async {
  const String missingVariable = "MISSING";

  // Load variables from `dart-define`
  const GOOGLE_CLIENT_ID =
      String.fromEnvironment('GOOGLE_CLIENT_ID', defaultValue: missingVariable);

  const GOOGLE_CLIENT_SECRET = String.fromEnvironment('GOOGLE_CLIENT_SECRET',
      defaultValue: missingVariable);

  const APPLE_CLIENT_SECRET = String.fromEnvironment('APPLE_CLIENT_SECRET',
      defaultValue: missingVariable);

  const APPLE_CLIENT_ID =
      String.fromEnvironment('APPLE_CLIENT_ID', defaultValue: missingVariable);

  if (GOOGLE_CLIENT_ID == missingVariable ||
      GOOGLE_CLIENT_SECRET == missingVariable ||
      APPLE_CLIENT_SECRET == missingVariable ||
      APPLE_CLIENT_ID == missingVariable) {
    // throw Exception(
    //     'One or more required environment variables are missing:\n');
    debugPrint("VALUES ARE MISSING");
  }

  return SecretKeys(
    GOOGLE_CLIENT_ID: GOOGLE_CLIENT_ID,
    GOOGLE_CLIENT_SECRET: GOOGLE_CLIENT_SECRET,
    APPLE_CLIENT_SECRET: APPLE_CLIENT_SECRET,
    APPLE_CLIENT_ID: APPLE_CLIENT_ID,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Future.wait([
    CurrencyRatesStorage().initialize(),
    LastUsedCurrencyStorage().initialize(),
    CountryPicker.loadCountryData(),
    SharedPrefsStorage().initialize(),
  ]);
  ApiService().initializeSecrets(await loadSecrets());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _setStartingPage() async {
    try {
      final bool wasIntroductionScreenShown =
          SharedPrefsStorage().getBool('wasIntroductionScreenShown');

      if (!wasIntroductionScreenShown) {
        return IntroductionPage();
      }

      final authentication = await SecureStorage().getAuthentication();
      if (authentication != null) {
        ApiService().setAuthentication(authentication);
        return const TripListPage();
      }

      return const LoginPage();
    } catch (e) {
      debugPrint('Error determining starting page: $e');
      return const LoginPage();
    }
  }

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
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
            ),
          ),
          home: FutureBuilder<Widget>(
            future: _setStartingPage(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return snapshot.data ?? const LoginPage();
              } else {
                return const LoginPage();
              }
            },
          ),
          onGenerateRoute: _onGenerateRoute,
        ),
      ),
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'LoginPage':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case 'SignUpPage':
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case 'TripListPage':
        return MaterialPageRoute(builder: (_) => const TripListPage());
      case 'ForgotPasswordPage':
        return MaterialPageRoute(builder: (_) => ForgotPasswordPage());
      case 'ChangePasswordPage':
        return MaterialPageRoute(builder: (_) => ChangePasswordPage());
      case 'VerificationCodePage':
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => VerificationCodePage(email: email),
        );
      case 'CreateNewPasswordPage':
        final args = settings.arguments as Map<String, String>;
        final email = args['email']!;
        final verificationCode = args['verificationCode']!;
        return MaterialPageRoute(
          builder: (_) => CreateNewPasswordPage(
            email: email,
            verificationCode: verificationCode,
          ),
        );
      case 'CreateListPage':
        final mainPageContext = settings.arguments as BuildContext;
        return MaterialPageRoute(
          builder: (_) => CreateTripPage(mainPageContext: mainPageContext),
        );
      case 'CreateExpensePage':
        final arguments = settings.arguments as Map<String, dynamic>;
        final expenseListPageContext =
            arguments['expenseListPageContext'] as BuildContext;
        final tripProvider = arguments['tripProvider'] as TripProvider;
        return MaterialPageRoute(
          builder: (_) => CreateExpensePage(
            expenseListPageContext: expenseListPageContext,
            tripProvider: tripProvider,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
