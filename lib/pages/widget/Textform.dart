import 'package:flutter/material.dart';

class Textform extends StatelessWidget {
  final TextEditingController controller;
  final String judul;
  const Textform({super.key, required this.controller, required this.judul});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12,),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: judul,
            border: OutlineInputBorder()
          ),
        ),
      ],
    );
  }
}