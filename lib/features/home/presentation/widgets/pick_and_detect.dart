// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';
//
// class FoodRecognizer {
//   final picker = ImagePicker();
//   final clarifai = ClarifaiService();
//
//   Future<void> pickAndDetect(BuildContext context) async {
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//
//     if (picked == null) return;
//
//     File file = File(picked.path);
//
//     final result = await clarifai.detectFood(file);
//
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(result != null
//             ? "Detected: $result"
//             : "Error detecting food")),
//       );
//     }
//   }
// }
