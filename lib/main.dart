import 'package:flutter/material.dart';
import 'package:invenzine/pages/home_pages/full_view.dart';
import 'package:invenzine/pages/home_pages/main_page.dart';
import 'package:invenzine/pages/splash_screen.dart';
import 'package:invenzine/services/dynamiclinks.dart';
import 'package:invenzine/services/locator.dart';
import 'package:invenzine/services/navigation_service.dart';
import 'package:invenzine/services/router.dart';

void main() {
  setupLocator();//This is importent For GetIT 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INVENZINE',
      navigatorKey: locator<NavigationService>().navigationKey,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}
