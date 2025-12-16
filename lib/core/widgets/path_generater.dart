import 'dart:convert';
import 'package:flutter/services.dart';

Future<Map<String, List<String>>> loadCategoryAssets() async {
  final String manifest = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = jsonDecode(manifest);

  // Все ассеты внутри Categories/
  final assetPaths = manifestMap.keys
      .where((p) => p.startsWith("assets/Categories/"))
      .toList();

  final Map<String, List<String>> categories = {};

  for (var path in assetPaths) {
    // assets/Categories/Fruits/apple.png → ["assets", "Categories", "Fruits", "apple.png"]
    final parts = path.split('/');
    if (parts.length < 4) continue;

    final categoryName = parts[2]; // Fruits, Meat, etc

    categories.putIfAbsent(categoryName, () => []);
    categories[categoryName]!.add(path);
  }

  return categories;
}
