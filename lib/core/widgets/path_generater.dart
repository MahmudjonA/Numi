import 'package:flutter/services.dart';

Future<Map<String, List<String>>> loadCategoryAssets() async {
  final AssetManifest manifest =
      await AssetManifest.loadFromAssetBundle(rootBundle);

  final assetPaths = manifest
      .listAssets()
      .where((p) => p.startsWith('assets/Categories/'))
      .toList();

  final Map<String, List<String>> categories = {};
  for (var path in assetPaths) {
    final parts = path.split('/');
    if (parts.length < 4) continue;
    final categoryName = parts[2];
    categories.putIfAbsent(categoryName, () => []);
    categories[categoryName]!.add(path);
  }
  return categories;
}
