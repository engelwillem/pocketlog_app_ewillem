import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketlog_app_ewillem/main.dart';
import 'package:pocketlog_app_ewillem/models/catalog_item.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    Hive.registerAdapter(CatalogItemAdapter());
    final box = await Hive.openBox<CatalogItem>('catalog');

    if (box.isEmpty) {
      final demoItems = List.generate(
        12,
        (i) => CatalogItem(
          id: 'item_${i + 1}',
          title: 'Item ${i + 1}',
          category: 'Kategori ${(i % 4) + 1}',
          description:
              'Ini deskripsi item ${i + 1}. Data masih lokal agar UI + navigasi stabil dan bisa digunakan offline.',
        ),
      );
      for (var item in demoItems) {
        box.put(item.id, item);
      }
    }
  });

  tearDown(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  testWidgets('PocketLog: Catalog page displays and filters correctly', (tester) async {
    // Run the app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the CatalogPage is displayed
    expect(find.text('PocketLog'), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 12'), findsOneWidget);

    // Verify that the filter chips are present
    expect(find.byType(FilterChip), findsWidgets);

    // Tap on the specific filter chip
    await tester.tap(find.widgetWithText(FilterChip, 'Kategori 1'));
    await tester.pumpAndSettle();

    // Verify that the list is filtered
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 2'), findsNothing);
    expect(find.text('Item 5'), findsOneWidget);
    expect(find.text('Item 9'), findsOneWidget);
  });
}
