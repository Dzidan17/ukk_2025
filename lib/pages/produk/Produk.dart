import 'package:flutter/material.dart';
import 'package:ukk_2025/pages/produk/TambahProduk.dart';

class Produk extends StatefulWidget {
  const Produk({super.key});

  @override
  State<Produk> createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produk"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => tambahproduk(),
        child: const Icon(
          Icons.add,
          color: Colors.blue,
        ),
      ),
    );
  }

  void tambahproduk() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TambahProduk()),
    );
  }
}
