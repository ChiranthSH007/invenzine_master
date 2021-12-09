import 'package:flutter/material.dart';
import 'package:invenzine/constants/route_names.dart';
import 'package:invenzine/pages/home_pages/bot_navbar.dart';
import 'package:invenzine/pages/home_pages/full_view.dart';
import 'package:invenzine/pages/home_pages/main_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeView:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: MyHomePage(),
      );
    case FullView:
      var docid = settings.arguments as String;
      print(docid);
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: Full_view(
          docid: docid,
        ),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
