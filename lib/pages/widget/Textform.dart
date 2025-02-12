import 'package:flutter/material.dart';

class Textform extends StatelessWidget {
  final TextEditingController controller;
  final String judul;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator; // Tambahkan validator

  const Textform({
    super.key,
    required this.controller,
    required this.judul,
    this.keyboardType,
    this.validator, // Tambahkan validator
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: judul),
      validator: validator, // Tambahkan validasi di sini
    );
  }
}
