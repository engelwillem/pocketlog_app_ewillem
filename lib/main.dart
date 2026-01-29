import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketlog_app_ewillem/models/catalog_item.dart';
import 'package:pocketlog_app_ewillem/pages/add_edit_item_page.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CatalogItemAdapter());
  final box = await Hive.openBox<CatalogItem>('catalog');

  // Isi data awal jika database kosong
  if (box.isEmpty) {
    final demoItems = List.generate(
      12,
      (i) => CatalogItem(
        id: 'item_${i + 1}',
        title: 'Item ${i + 1}',
        subtitle: 'Kategori ${(i % 4) + 1}',
        description:
            'Ini deskripsi item ${i + 1}. Data masih lokal agar UI + navigasi stabil dan bisa digunakan offline.',
      ),
    );
    for (var item in demoItems) {
      box.put(item.id, item);
    }
  }

  runApp(const MyApp());
}

// Menyimpan path gambar per item (untuk masa depan).
final ValueNotifier<Map<String, String>> itemImagePaths = ValueNotifier(
  <String, String>{},
);

// =====================
// App (Stateless)
// =====================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketLog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const HomePage(),
    );
  }
}

// =====================
// Home (Stateless)
// =====================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _thumb(BuildContext context, CatalogItem item) {
    return ValueListenableBuilder<Map<String, String>>(
      valueListenable: itemImagePaths,
      builder: (context, map, _) {
        final path = map[item.id];
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 56,
            height: 56,
            child: path == null
                ? Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image),
                  )
                : Image.file(File(path), fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogBox = Hive.box<CatalogItem>('catalog');

    return Scaffold(
      appBar: AppBar(
        title: const Text('PocketLog'),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: catalogBox.listenable(),
                builder: (context, Box<CatalogItem> box, _) {
                  if (box.isEmpty) {
                    return const Center(
                      child: Text('No items yet. Add one!'),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: box.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = box.getAt(index)!;
                      return Card(
                        elevation: 0,
                        child: ListTile(
                          leading: _thumb(context, item),
                          title: Text(item.title),
                          subtitle: Text(item.subtitle),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(item: item),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                'E B Willem',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditItemPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// =====================
// Detail (Stateless)
// =====================
class DetailPage extends StatelessWidget {
  final CatalogItem item;
  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        actions: [
          IconButton(
            tooltip: 'Edit',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditItemPage(item: item),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            tooltip: 'Delete',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Delete Item'),
                    content:
                        const Text('Are you sure you want to delete this item?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () {
                          item.delete();
                          Navigator.of(context).pop(); // Close the dialog
                          Navigator.of(context).pop(); // Go back to the list
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<Map<String, String>>(
                valueListenable: itemImagePaths,
                builder: (context, map, _) {
                  final path = map[item.id];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: path == null
                          ? Container(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              child: const Center(
                                child: Icon(Icons.image, size: 56),
                              ),
                            )
                          : Image.file(File(path), fit: BoxFit.cover),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                item.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                item.subtitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Text(
                item.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Fitur foto sementara dinonaktifkan untuk submission agar stabil.',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.photo_library),
                label: const Text('Pilih Foto & Crop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================
// Search (Stateful)
// =====================
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _thumb(BuildContext context, CatalogItem item) {
    return ValueListenableBuilder<Map<String, String>>(
      valueListenable: itemImagePaths,
      builder: (context, map, _) {
        final path = map[item.id];
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 56,
            height: 56,
            child: path == null
                ? Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image),
                  )
                : Image.file(File(path), fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogBox = Hive.box<CatalogItem>('catalog');
    final q = _query.trim().toLowerCase();
    final filtered = catalogBox.values.where((e) {
      if (q.isEmpty) return true;
      return e.title.toLowerCase().contains(q) ||
          e.subtitle.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Cari item',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear',
                          onPressed: () {
                            _controller.clear();
                            setState(() => _query = '');
                          },
                          icon: const Icon(Icons.close),
                        ),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('Tidak ada hasil'))
                    : ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return Card(
                            elevation: 0,
                            child: ListTile(
                              leading: _thumb(context, item),
                              title: Text(item.title),
                              subtitle: Text(item.subtitle),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailPage(item: item),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
