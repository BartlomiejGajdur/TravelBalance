import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:TravelBalance/components/custom_text_field.dart';
import 'package:TravelBalance/components/login_button_component.dart';
import 'package:TravelBalance/pages/forgot_password_page.dart';
import 'package:TravelBalance/pages/sign_up_page.dart';
import '../components/globals.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String appleCredentials = 'NONE';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20.h),
                  child: const Icon(
                    Icons.houseboat_sharp,
                    color: leadingColor,
                    size: 40,
                  ),
                ),
                Text(
                  "Welcome back wanderer!",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Text(
                    "Create your next journey here.",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
                SizedBox(
                  height: 80.h,
                ),
                CustomTextField(
                  hintText: "Username",
                  controller: usernameController,
                  obscureText: false,
                  horizontalPadding: 22.w,
                ),
                CustomTextField(
                  hintText: "Password",
                  controller: passwordController,
                  obscureText: true,
                  horizontalPadding: 22.w,
                ),
                SignInWithAppleButton(
                  onPressed: () async {
                    try {
                      final AuthorizationCredentialAppleID credential =
                          await SignInWithApple.getAppleIDCredential(
                        scopes: [
                          AppleIDAuthorizationScopes.email,
                          AppleIDAuthorizationScopes.fullName,
                        ],
                        // webAuthenticationOptions: WebAuthenticationOptions(
                        //   clientId: 'SignInWithAppleKey',
                        //   redirectUri: Uri.parse('your_redirect_uri'),
                        // ),
                      );

                      setState(() {
                        appleCredentials = '''
                        Email: ${credential.email ?? 'N/A'}
                        Full Name: ${credential.givenName ?? 'N/A'} ${credential.familyName ?? 'N/A'}
                        User ID: ${credential.userIdentifier}
                        ''';
                      });
                    } catch (error) {
                      setState(() {
                        appleCredentials =
                            "Error during Apple Sign-In: ${error}";
                      });
                    }
                  },
                ),
                if (appleCredentials.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.all(20.h),
                    child: Text(
                      appleCredentials,
                      style: TextStyle(
                        fontSize: 6.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                SizedBox(height: 10.h),
                LoginButtonComponent(
                  usernameController: usernameController,
                  passwordController: passwordController,
                  horizontalPadding: 22.w,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage()));
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
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()));
                        },
                        child: const Text("Sign up",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
