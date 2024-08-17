import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/google_signin_api.dart';
import '../components/custom_text_field.dart';
import '../components/login_button_component.dart';
import '../pages/forgot_password_page.dart';
import '../pages/sign_up_page.dart';
import '../components/globals.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                SizedBox(height: 80.h),
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
                                    const ForgotPasswordPage()),
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
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()),
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
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                    minimumSize: Size(double.infinity, 0),
                  ),
                  icon:
                      const FaIcon(FontAwesomeIcons.google, color: Colors.red),
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
                      onPressed: () => logOut(context), child: Text("Logout")),
                if (_googleAuth != null && _user != null)
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Column(
                      children: [
                        Text(
                          '''
                          Authorization in as: 
                          ${_googleAuth!.idToken} 
                          ${_googleAuth!.accessToken}''',
                          style: TextStyle(fontSize: 8.sp),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
