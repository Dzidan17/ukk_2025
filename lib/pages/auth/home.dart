import 'package:flutter/material.dart'; // Mengimpor pustaka Flutter untuk membangun UI.
import 'package:ukk_2025/pages/pelanggan/pelanggan.dart'; // Mengimpor halaman pelanggan.
import 'package:ukk_2025/pages/produk/Produk.dart'; // Mengimpor halaman produk.
import 'package:ukk_2025/pages/penjualan/Penjualan.dart'; // Mengimpor halaman penjualan.

// Kelas utama HomePage yang merupakan StatefulWidget
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

// State untuk HomePage
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Utama'), // Menampilkan judul di AppBar
      ),
      body: Padding(
        padding: EdgeInsets.all(16), // Memberikan jarak di sekitar konten
        child: Column(
          children: [
            // Membuat daftar menu navigasi
            menu('Pelanggan', () => pindahKePelanggan()),
            menu('Produk', () => pindahKeProduk()),
            menu('Penjualan', () => pindahKePenjualan()),
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat item menu dalam bentuk kartu
  Widget menu(String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap, // Ketika diklik, akan menjalankan fungsi yang diberikan
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10), // Memberikan padding dalam kartu
          margin: EdgeInsets.only(bottom: 8), // Memberikan jarak antar menu
          child: Row(
            children: [Text(title)], // Menampilkan teks judul menu
          ),
        ),
      ),
    );
  }

  // Fungsi untuk pindah ke halaman Pelanggan
  void pindahKePelanggan() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Pelanggan()));
  }

  // Fungsi untuk pindah ke halaman Produk
  void pindahKeProduk() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Produk()));
  }

  // Fungsi untuk pindah ke halaman Penjualan
  void pindahKePenjualan() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PenjualanScreen()));
  }
}
