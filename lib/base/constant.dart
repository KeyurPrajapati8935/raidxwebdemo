import 'package:firebase_auth/firebase_auth.dart';

class Constant {

  static String loggedUserName = '';
  static String loggedUserEmail = '';
  static String loggedUserImage = '';

  static FirebaseAuth? auth;

  static const String kNewsApp = "News App";
  static const String kBookmarkPage = "Bookmark Page";
  static const String kNewsDesc = "News Description'";
  static const String kGoogleSignIn = "Sign In with Google";
  static const String kSignOut = "SignOut";
  static const String kFetchAllContent = "You have fetched all of the content";
}
