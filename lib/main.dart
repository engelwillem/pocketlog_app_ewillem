import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketlog_app_ewillem/app_router.dart';
import 'package:pocketlog_app_ewillem/models/catalog_item.dart';
import 'package:pocketlog_app_ewillem/theme.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(CatalogItemAdapter());
  final box = await Hive.openBox<CatalogItem>('catalog');

  // Isi data awal jika database kosong
  if (box.isEmpty) {
    final demoItems = List.generate(
      12,
      (i) => CatalogItem(
        id: 'item_${i + 1}',
        title: 'Item ${i + 1}',
        category: 'Kategori ${(i % 4) + 1}',
        description:
            'deskripsi item ${i + 1}',
      ),
    );
    for (var item in demoItems) {
      box.put(item.id, item);
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PocketLog',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: appRouter,
    );
  }
}
