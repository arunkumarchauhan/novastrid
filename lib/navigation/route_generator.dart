import 'package:flutter/material.dart';
import 'package:novastrid/feature/home/presentation/home_page.dart';
import 'package:novastrid/navigation/routes_path.dart';

class Routegenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case RoutePath.home:
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Error"),
            centerTitle: true,
          ),
          body: const Center(
            child: Text("Page not found"),
          ),
        );
      },
    );
  }
}
