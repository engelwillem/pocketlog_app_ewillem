import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketlog_app_ewillem/models/catalog_item.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class AddEditItemPage extends StatefulWidget {
  final Object? routeExtra;
  const AddEditItemPage({super.key, this.routeExtra});

  @override
  State<AddEditItemPage> createState() => _AddEditItemPageState();
}

class _AddEditItemPageState extends State<AddEditItemPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _barcodeController;

  CatalogItem? _itemForEditing;

  bool get _isEditing => _itemForEditing != null;

  @override
  void initState() {
    super.initState();

    String initialTitle = '';
    String initialCategory = '';
    String initialDescription = '';
    String initialBarcode = '';

    if (widget.routeExtra is CatalogItem) {
      _itemForEditing = widget.routeExtra as CatalogItem;
      initialTitle = _itemForEditing!.title;
      initialCategory = _itemForEditing!.category;
      initialDescription = _itemForEditing!.description;
      initialBarcode = _itemForEditing!.barcode ?? '';
    } else if (widget.routeExtra is Map<String, String>) {
      final prefillData = widget.routeExtra as Map<String, String>;
      initialTitle = prefillData['title'] ?? '';
      initialCategory = prefillData['category'] ?? '';
      initialBarcode = prefillData['barcode'] ?? '';
    }

    _titleController = TextEditingController(text: initialTitle);
    _categoryController = TextEditingController(text: initialCategory);
    _descriptionController = TextEditingController(text: initialDescription);
    _barcodeController = TextEditingController(text: initialBarcode);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final catalogBox = Hive.box<CatalogItem>('catalog');
      final id = _itemForEditing?.id ?? uuid.v4();

      final newItem = CatalogItem(
        id: id,
        title: _titleController.text,
        category: _categoryController.text,
        description: _descriptionController.text,
        barcode: _barcodeController.text,
        imagePath: _itemForEditing?.imagePath, 
        videoPath: _itemForEditing?.videoPath,
      );

      catalogBox.put(id, newItem);
      
      // Pop once to leave the add/edit page.
      context.pop();

      // If we were editing, the detail page is still on the stack, so pop again.
      if (_isEditing) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Item' : 'Tambah Item'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kategori tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _barcodeController,
                decoration: const InputDecoration(
                  labelText: 'Barcode',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                 validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
