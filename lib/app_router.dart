import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketlog_app_ewillem/pages/add_edit_item_page.dart';
import 'package:pocketlog_app_ewillem/pages/catalog_page.dart';
import 'package:pocketlog_app_ewillem/pages/product_detail_page.dart';
import 'package:pocketlog_app_ewillem/models/catalog_item.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CatalogPage(),
      routes: [
        GoRoute(
            path: 'item/new',
            builder: (context, state) {
              // Pass the extra data (if any) to the AddEditItemPage
              return AddEditItemPage(routeExtra: state.extra);
            }),
        GoRoute(
            path: 'item/:id',
            builder: (context, state) {
              final item = state.extra as CatalogItem?;
              if (item != null) {
                return ProductDetailPage(item: item);
              }
              return const Scaffold(
                body: Center(
                  child: Text('Item not found'),
                ),
              );
            },
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) {
                  // The 'extra' for this route is passed down from the parent
                  final item = state.extra as CatalogItem?;
                  if (item != null) {
                    // Pass the item to be edited to the AddEditItemPage
                    return AddEditItemPage(routeExtra: item);
                  }
                  return const Scaffold(
                    body: Center(
                      child: Text('Item not found for editing'),
                    ),
                  );
                },
              ),
            ]),
      ],
    ),
  ],
);
