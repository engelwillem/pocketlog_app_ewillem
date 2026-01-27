import 'package:flutter/material.dart';

import 'pages/catalog_page.dart';
import 'pages/product_detail_page.dart';

class Routes {
  static const catalog = '/';
  static const detail = '/detail';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.catalog:
        return MaterialPageRoute(builder: (_) => const CatalogPage());

      case Routes.detail:
        final args = settings.arguments;
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: args),
          );
        }
        return _errorRoute('Argumen detail tidak valid');

      default:
        return _errorRoute('Route tidak ditemukan: ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
