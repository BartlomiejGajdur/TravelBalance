import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wanderer/components/custom_text_field.dart';
import 'package:wanderer/pages/login_page.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[400],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(19.w, 88.h, 0, 37.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create Account!",
                  style: GoogleFonts.montserrat(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "To get started now.",
                  style: GoogleFonts.montserrat(
                    fontSize: 23.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 70.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomTextField(
                      hintText: "Username",
                      controller: usernameController,
                      obscureText: false,
                      horizontalPadding: 22.w,
                      suffixIcon: const Icon(Icons.person),
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      hintText: "Email",
                      controller: emailController,
                      obscureText: false,
                      horizontalPadding: 22.w,
                      suffixIcon: const Icon(Icons.email),
                    ),
                    SizedBox(height: 16.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          hintText: "Password",
                          controller: passwordController,
                          obscureText: true,
                          horizontalPadding: 22.w,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22.w),
                          child: Text(
                            "Password should be at least 8 characters long",
                            style: GoogleFonts.montserrat(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF656565),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      hintText: "Repeat Password",
                      controller: repeatPasswordController,
                      obscureText: true,
                      horizontalPadding: 22.w,
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.w),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            minimumSize: WidgetStateProperty.all(
                                Size(double.infinity, 50.h)),
                            backgroundColor:
                                WidgetStateProperty.all(Colors.green[400]),
                          ),
                          child: const Text(
                            "SIGNUP",
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: GoogleFonts.montserrat(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          ),
                          child: Text(
                            "Login",
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.green[400],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
