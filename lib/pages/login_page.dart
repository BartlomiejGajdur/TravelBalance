import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/google_signin_api.dart';
import '../components/custom_text_field.dart';
import '../pages/forgot_password_page.dart';
import '../pages/sign_up_page.dart';
import '../Utils/globals.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GoogleSignInAccount? _user; // Przechowywanie danych zalogowanego użytkownika
  GoogleSignInAuthentication? _googleAuth;
  Future<void> signIn(BuildContext context) async {
    final user = await GoogleSignInApi.login(context);
    setState(() {
      _user = user;
    });
    if (_user != null) {
      final googleAuth = await _user!.authentication;
      setState(() {
        _googleAuth = googleAuth;
      });
    }
  }

  Future<void> logOut(BuildContext context) async {
    bool isUserLogedOut = await GoogleSignInApi.logout(context);
    if (isUserLogedOut) {
      setState(() {
        _user = null;
      });
    }
  }

  Future<bool> loginAS() async {
    return await ApiService()
        .login(usernameController.text, passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 108.h),
          Padding(
            padding: EdgeInsets.only(left: 28.w),
            child: Text("Welcome back wanderer!", style: mainTextStyle),
          ),
          Text(
            "Sign In to your account",
            style: secondaryTextStyle,
          ),
          SizedBox(height: 80.h),
          CustomTextField(
            hintText: "Username",
            controller: usernameController,
            obscureText: false,
            horizontalPadding: 0.w,
          ),
          CustomTextField(
            hintText: "Password",
            controller: passwordController,
            obscureText: true,
            horizontalPadding: 22.w,
          ),
          SizedBox(height: 10.h),
          CustomButton(onPressed: loginAS, buttonText: "Login"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage()),
                    );
                  },
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: const Text(
                    "Sign up",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
            label: const Text('Sign Up with Google'),
            onPressed: () {
              signIn(context);
            },
          ),
          if (_user != null)
            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Column(
                children: [
                  Text(
                    '''
                    Logged in as: ${_user!.displayName} 
                    ${_user!.email}
                    ${_user!.id}''',
                    style: TextStyle(fontSize: 8.sp),
                  ),
                ],
              ),
            ),
          if (_user != null)
            ElevatedButton(
                onPressed: () => logOut(context), child: const Text("Logout")),
          if (_googleAuth != null)
            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Column(
                children: [
                  Text(
                    '''
                    Authorization in as: 
                    IDToken:
                    ${_googleAuth!.idToken} 
                    AccessToken:
                    ${_googleAuth!.accessToken}''',
                    style: TextStyle(fontSize: 8.sp),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
