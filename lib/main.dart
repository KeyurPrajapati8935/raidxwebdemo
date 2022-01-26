import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practical_test/base/constant.dart';
import 'package:flutter_practical_test/base/theme/palette.dart';
import 'package:flutter_practical_test/ui/dashbaord/widget/dashboard.dart';

import 'base/routes/routes.dart';
import 'ui/signin/signin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constant.kNewsApp,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Palette.appThemeColor,
      ),
      onGenerateRoute: (settings) {
        Widget? screen;
        String name = '';
        switch (settings.name) {
          case Routes.SIGN_IN:
            screen = const SignInPage();
            name = Routes.SIGN_IN;
            break;
          case Routes.DASHBOARD:
            screen = const Dashboard();
            name = Routes.DASHBOARD;
            break;
        }
        if (name != '') {
          return NoAnimationMaterialPageRoute(
            builder: (context) => screen!,
            settings: RouteSettings(name: name),
          );
        }
        return null;
      },
      initialRoute: Routes.LAUNCHER,
      home: const SignInPage(),
    );
  }
}

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    @required WidgetBuilder? builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder!,
            maintainState: maintainState,
            settings: settings,
            fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
