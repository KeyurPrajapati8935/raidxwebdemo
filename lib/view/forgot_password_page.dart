import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practical_test/base/constant.dart';
import 'package:flutter_practical_test/base/palette.dart';
import 'package:flutter_practical_test/base/sql_helper.dart';
import 'package:flutter_practical_test/view/login_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({Key? key}) : super(key: key);

  @override
  _ForgotPassPageState createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final FocusNode focusEmail = FocusNode();
  final FocusNode focusPassword = FocusNode();
  final FocusNode focusConfirmPassword = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  _backHandle() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        body: WillPopScope(
          onWillPop: () => _backHandle(),
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
                            height: MediaQuery.of(context).size.height - 100,
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
                                    style: const TextStyle(
                                        fontSize: 16.0, color: Colors.black),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.envelope,
                                          color: Colors.black,
                                          size: 22.0,
                                        ),
                                        hintText: "Enter email",
                                        hintStyle: TextStyle(fontSize: 18.0)),
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
                                    style: const TextStyle(
                                        fontSize: 16.0, color: Colors.black),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return Constant.kEnterNewPassWord;
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.lock,
                                          color: Colors.black,
                                          size: 22.0,
                                        ),
                                        hintText: "Enter new password",
                                        hintStyle: TextStyle(fontSize: 18.0)),
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
                                    focusNode: focusConfirmPassword,
                                    controller: confirmPasswordController,
                                    style: const TextStyle(
                                        fontSize: 16.0, color: Colors.black),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return Constant
                                            .kEnterNewConfirmPassWord;
                                      } else if (passwordController
                                              .text.isNotEmpty &&
                                          passwordController.text != value) {
                                        return Constant.kEnterPassDoesNotMatch;
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.lock,
                                          color: Colors.black,
                                          size: 22.0,
                                        ),
                                        hintText: 'Confirm new password',
                                        hintStyle: TextStyle(fontSize: 18.0)),
                                  ),
                                ),
                                Container(
                                  width: 250.0,
                                  height: 1.0,
                                  color: Colors.grey,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 40.0),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
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
                                        Constant.kSubmit,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22.0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_formkey.currentState!.validate()) {
                                        Navigator.pop(context);
                                        var test = await SQLHelper.forGotPassword(emailController.text, confirmPasswordController.text);
                                        return;
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
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
                                fontSize: 16.0,
                              ),
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
}
