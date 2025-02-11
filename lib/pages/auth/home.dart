import 'package:flutter/material.dart';
import 'package:ukk_2025/pages/pelanggan/pelanggan.dart';
import 'package:ukk_2025/pages/produk/Produk.dart';
import 'package:ukk_2025/pages/penjualan/Penjualan.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Utama'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            menu('Pelanggan', () => pindahKePelanggan()),
            menu('Produk', () => pindahKeProduk()),
            menu('Penjualan', () => pindahKePenjualan()),
          ],
        ),
      ),
    );
  }

  Widget menu(String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          margin: EdgeInsets.only(bottom: 8),
          child: Row(
            children: [Text(title)],
          ),
        ),
      ),
    );
  }

  void pindahKePelanggan() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Pelanggan()));
  }

  void pindahKeProduk() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Produk()));
  }

  void pindahKePenjualan() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Penjualan()));
  }
}
