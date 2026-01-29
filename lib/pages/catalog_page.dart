import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketlog_app_ewillem/models/catalog_item.dart';
import 'dart:io';
import 'package:pocketlog_app_ewillem/pages/barcode_scanner_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String? _selectedCategory;

  Future<void> _scanBarcode() async {
    // Navigate to the scanner page and wait for a result
    final barcode = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const BarcodeScannerPage(),
      ),
    );

    if (barcode != null && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Scanned barcode: $barcode. Fetching data...')),
        );
      
      try {
        final productInfo = await _fetchProductInfo(barcode);
        if (context.mounted) {
          if (productInfo != null) {
            context.go('/item/new', extra: productInfo);
          } else {
            ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Product not found for barcode: $barcode')),
            );
            context.go('/item/new', extra: {'barcode': barcode});
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text('Error fetching product data: $e')),
          );
          context.go('/item/new', extra: {'barcode': barcode});
        }
      }
    }
  }

  Future<Map<String, String>?> _fetchProductInfo(String barcode) async {
    // Using Open Food Facts API
    final url = Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 1) {
        final product = data['product'];
        return {
          'title': product['product_name'] ?? '',
          'category': product['categories']?.split(',').first.trim() ?? 'Uncategorized',
          'barcode': barcode,
        };
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final catalogBox = Hive.box<CatalogItem>('catalog');

    return Scaffold(
      appBar: AppBar(
        title: const Text('PocketLog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanBarcode,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: catalogBox.listenable(),
              builder: (context, Box<CatalogItem> box, _) {
                final categories = [
                  'All',
                  ...box.values.map((e) => e.category).toSet()
                ];
                return SizedBox(
                  height: 60,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return FilterChip(
                        label: Text(category),
                        selected: _selectedCategory == category ||
                            (_selectedCategory == null && category == 'All'),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedCategory =
                                  category == 'All' ? null : category;
                            } else {
                              _selectedCategory = null;
                            }
                          });
                        },
                      );
                    },
                  ),
                );
              },
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: catalogBox.listenable(),
                builder: (context, Box<CatalogItem> box, _) {
                  final items = box.values.where((item) {
                    return _selectedCategory == null ||
                        item.category == _selectedCategory;
                  }).toList();

                  if (items.isEmpty) {
                    return const Center(
                      child: Text('No items in this category.'),
                    );
                  }
                  return MasonryGridView.count(
                    padding: const EdgeInsets.all(16),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return InkWell(
                        onTap: () => context.go('/item/${item.id}', extra: item),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.imagePath != null)
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: Image.file(
                                    File(item.imagePath!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style:
                                          Theme.of(context).textTheme.titleMedium,
                                    ),
                                    Text(
                                      item.category,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/item/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}