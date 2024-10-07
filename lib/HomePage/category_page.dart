import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final String label;

  const CategoryPage({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(
        child: Text('Products in $label category'),
      ),
    );
  }
}
