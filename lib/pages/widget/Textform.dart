import 'package:flutter/material.dart';

class Textform extends StatelessWidget {
  final TextEditingController controller;
  final String judul;
  const Textform({super.key, required this.controller, required this.judul});
  // final String? Function(String?)? validator;
  // const Textform({
  //   required this.controller,
  //   required this.judul,
  //   this.validator,
  //   Key? key,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        TextFormField(
          controller: controller,
          decoration:
              InputDecoration(labelText: judul, border: OutlineInputBorder()),
        ),
      ],
    );
    // return TextFormField(
    //     controller: controller,
    //     decoration: InputDecoration(
    //       labelText: judul,
    //       border: OutlineInputBorder(),
    //     ));
    
  }
}
