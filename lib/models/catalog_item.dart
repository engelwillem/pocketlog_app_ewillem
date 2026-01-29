import 'package:hive/hive.dart';

part 'catalog_item.g.dart';

@HiveType(typeId: 1)
class CatalogItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String category;

  @HiveField(3)
  String description;

  @HiveField(4)
  String? imagePath;

  @HiveField(5)
  String? videoPath;

  @HiveField(6)
  String? barcode;

  CatalogItem({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    this.imagePath,
    this.videoPath,
    this.barcode,
  });
}
