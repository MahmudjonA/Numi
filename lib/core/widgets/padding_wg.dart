import 'package:flutter/material.dart';

class PaddingWg extends StatelessWidget {
  final Widget child;

  const PaddingWg({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SafeArea(
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}
