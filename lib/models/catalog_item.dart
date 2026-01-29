import 'package:hive/hive.dart';

part 'catalog_item.g.dart';

@HiveType(typeId: 0)
class CatalogItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String subtitle;

  @HiveField(3)
  final String description;

  CatalogItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
  });
}
