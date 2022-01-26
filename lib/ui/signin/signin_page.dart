import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practical_test/base/constant.dart';
import 'package:flutter_practical_test/base/routes/routes.dart';
import 'package:flutter_practical_test/base/theme/images_link.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    Constant.auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.red,
              ],
            ),
          ),
          child: Card(
              margin: const EdgeInsets.only(
                  top: 200, bottom: 200, left: 30, right: 30),
              elevation: 20,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      Constant.kNewsApp,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 50,
                      child: GestureDetector(
                        onTap: () => googleSignUp(context),
                        child: Image.asset(
                          ImagesLink.GOOGLE_BUTTON,
                          height: 50,
                          width: 170,
                        ),
                      ),
                    ),
                  ]))),
    );
  }

  // Using Google SingIn
  Future<void> googleSignUp(BuildContext context) async {
    isLoading = true;

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      UserCredential result =
          await Constant.auth!.signInWithCredential(authCredential);

      Constant.loggedUserName = result.user!.displayName!;
      Constant.loggedUserEmail = result.user!.email!;
      Constant.loggedUserImage = result.user!.photoURL!;

      if (result.user != null) {
        isLoading = false;
        Navigator.of(context).pushNamed(Routes.DASHBOARD);
      }
    }
  }
}
