import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() async {
    try {
      // Attempt to sign in the user
      final GoogleSignInAccount? user = await _googleSignIn.signIn();
      return user;
    } on Exception catch (e) {
      // Handle any exceptions that occur during the sign-in process
      print('Error during Google Sign-In: $e');
      return null;
    }
  }

  static Future<bool> logout() async {
    try {
      await _googleSignIn.signOut();
      print('User signed out successfully.');
      return true;
    } on Exception catch (e) {
      // Handle any exceptions that occur during the sign-out process
      print('Error during Google Sign-Out: $e');
      return false;
    }
  }
}
