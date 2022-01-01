import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_practical_test/base/constant.dart';
import 'package:flutter_practical_test/base/palette.dart';
import 'package:flutter_practical_test/base/sql_helper.dart';
import 'package:flutter_practical_test/view/dashbaord_page.dart';
import 'package:flutter_practical_test/view/forgot_password_page.dart';
import 'package:flutter_practical_test/view/signup_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final FocusNode focusEmail = FocusNode();
  final FocusNode focusPassword = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  _handleBack(){
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        body: WillPopScope(
          onWillPop: () => _handleBack(),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Container(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.antiAlias,
                      children: <Widget>[
                        Card(
                          elevation: 2.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 200,
                            child: Column(
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: FlutterLogo(
                                    size: 60,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0,
                                      bottom: 20.0,
                                      left: 25.0,
                                      right: 25.0),
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    focusNode: focusEmail,
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: GoogleFonts.lato(
                                        fontSize: 16.0, color: Colors.black),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return Constant.kEnterEmail;
                                      }
                                      if (!RegExp(
                                              "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                          .hasMatch(value)) {
                                        return Constant.kEnterVaildEmail;
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: const Icon(
                                        FontAwesomeIcons.envelope,
                                        color: Colors.black,
                                        size: 22.0,
                                      ),
                                      hintText: "Enter email",
                                      hintStyle: GoogleFonts.lato(
                                          fontSize: 16.0, color: Colors.black),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 250.0,
                                  height: 1.0,
                                  color: Colors.grey,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0,
                                      bottom: 20.0,
                                      left: 25.0,
                                      right: 25.0),
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    focusNode: focusPassword,
                                    controller: passwordController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return Constant.kEnterPassWord;
                                      }
                                      return null;
                                    },
                                    style: GoogleFonts.lato(
                                        fontSize: 16.0, color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: const Icon(
                                        FontAwesomeIcons.lock,
                                        color: Colors.black,
                                        size: 22.0,
                                      ),
                                      hintText: "Enter password",
                                      hintStyle: GoogleFonts.lato(
                                          fontSize: 18.0, color: Colors.black),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 250.0,
                                  height: 1.0,
                                  color: Colors.grey,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 60.0, bottom: 26.0),
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5.0)),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Palette.colorStart,
                                            offset: Offset(1.0, 6.0),
                                            blurRadius: 20.0),
                                        BoxShadow(
                                            color: Palette.colorEnd,
                                            offset: Offset(1.0, 6.0),
                                            blurRadius: 20.0),
                                      ],
                                      gradient: LinearGradient(
                                          colors: [
                                            Palette.colorEnd,
                                            Palette.colorStart
                                          ],
                                          begin: FractionalOffset(0.2, 0.2),
                                          end: FractionalOffset(1.0, 1.0),
                                          stops: [0.1, 1.0],
                                          tileMode: TileMode.clamp)),
                                  child: MaterialButton(
                                      highlightColor: Colors.transparent,
                                      splashColor: Palette.colorEnd,
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 42.0),
                                        child: Text(
                                          Constant.kLogin,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22.0),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (_formkey.currentState!.validate()) {
                                          final data = await SQLHelper.getItems();
                                          if(data.isNotEmpty){
                                            setState(() {
                                              var isLoggedIn = 0;
                                              for (var element in data) {
                                                element['email'] == emailController.text && element['password'] == passwordController.text
                                                    ? isLoggedIn = 0
                                                    : isLoggedIn = 1;
                                              }
                                              isLoggedIn == 0
                                                  ? Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                      const DashBoardPage()))
                                                  : displaySnackBar(Constant.kEnterValidEmail);
                                            });
                                          }else{
                                            displaySnackBar(Constant.kEnterValidEmail);
                                          }
                                          return;
                                        }
                                      }),
                                ),
                                TextButton(
                                  child: const Text(
                                    Constant.kForgotPassWord,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgotPassPage()));
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextButton(
                        child: const Text(
                          Constant.kNotHaveAccount,
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          gradient: LinearGradient(
                              colors: [Colors.white, Colors.white],
                              begin: FractionalOffset(0.2, 0.2),
                              end: FractionalOffset(0.5, 0.5),
                              stops: [0.1, 0.5],
                              tileMode: TileMode.clamp)),
                      child: MaterialButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.white70,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 42.0),
                          child: Text(
                            Constant.kSignUp,
                            style: TextStyle(color: Colors.black, fontSize: 22.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpPage()));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.white10,
                                    Colors.white,
                                  ],
                                  begin: FractionalOffset(0.0, 0.0),
                                  end: FractionalOffset(1.0, 1.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            width: 100.0,
                            height: 1.0,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Text(
                              "",
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                  fontSize: 16.0),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.white10,
                                  ],
                                  begin: FractionalOffset(0.0, 0.0),
                                  end: FractionalOffset(1.0, 1.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            width: 100.0,
                            height: 1.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void displaySnackBar(String value) {
    ScaffoldMessenger.of(_formkey.currentState!.context).showSnackBar(SnackBar(
      content: Text(
        value,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      backgroundColor: Colors.blue,
      duration: const Duration(seconds: 3),
    ));
  }
}
