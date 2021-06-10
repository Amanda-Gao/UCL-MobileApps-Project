import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_path/page/login_register_page.dart';
import 'package:pet_path/page/splash_page.dart';
import 'package:pet_path/value/color_app.dart';
import 'package:pet_path/value/route_app.dart';

void main() {
  final statusStyle = SystemUiOverlayStyle(
      statusBarColor: ColorApp.primary,
      statusBarIconBrightness: Brightness.light
  );

  SystemChrome.setSystemUIOverlayStyle(statusStyle);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pet Path',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.grey
        ),
        home: SplashPage(),
        routes: <String, WidgetBuilder>{
          RouteApp.login: (BuildContext context) => LoginRegisterPage(),
        },
    );
  }
}