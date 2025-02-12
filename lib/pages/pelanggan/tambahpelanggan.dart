import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/model/PelangganModel.dart'; // Model untuk pelanggan
import 'package:ukk_2025/pages/widget/Textform.dart'; // Widget custom untuk input form

// Halaman untuk menambahkan pelanggan baru
class Tambahpelanggan extends StatefulWidget {
  const Tambahpelanggan({super.key});

  @override
  State<Tambahpelanggan> createState() => _TambahpelangganState();
}

class _TambahpelangganState extends State<Tambahpelanggan> {
  SupabaseClient supabaseClient = Supabase.instance.client; // Inisialisasi Supabase Client
  final _formKey = GlobalKey<FormState>(); // Kunci untuk validasi form

  // Controller untuk input form
  TextEditingController nama = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController telepon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Pelanggan"), // Judul halaman
      ),
      body: Form(
        key: _formKey, // Form dengan validasi
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Textform(controller: nama, judul: "Nama"), // Input nama pelanggan
              Textform(controller: alamat, judul: "Alamat"), // Input alamat pelanggan
              Textform(controller: telepon, judul: "No Telepon"), // Input nomor telepon pelanggan
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    simpanPelanggan(); // Panggil fungsi simpan pelanggan
                  },
                  child: const Text("Simpan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk validasi dan menyimpan pelanggan
  void simpanPelanggan() {
    if (_formKey.currentState!.validate()) {
      debugPrint('Form Valid');
      _formKey.currentState!.save(); // Simpan nilai dari form

      tambahData(); // Lanjutkan dengan menyimpan ke database
    } else {
      debugPrint('Form Tidak Valid');
    }
  }

  // Fungsi untuk menyimpan data pelanggan ke database Supabase
  void tambahData() async {
    debugPrint('tambahData dipanggil');

    try {
      // Cek apakah nama pelanggan sudah terdaftar (mencegah duplikasi)
      final existing = await supabaseClient
          .from('pelanggan')
          .select('nama_pelanggan')
          .eq('nama_pelanggan', nama.text)
          .maybeSingle(); // Mengambil satu data jika ada

      if (existing != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama pelanggan sudah terdaftar')),
        );
        return;
      }

      // Jika tidak ada duplikat, buat objek model pelanggan
      PelangganModel model = PelangganModel(
        namaPelanggan: nama.text,
        alamat: alamat.text,
        nomortelepon: telepon.text.isNotEmpty ? telepon.text : "Tidak tersedia",
      );

      // Simpan data pelanggan ke tabel 'pelanggan'
      final response = await supabaseClient.from('pelanggan').insert(model.toMap());

      // Tampilkan notifikasi dan kembali ke halaman sebelumnya jika berhasil
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pelanggan berhasil ditambahkan")),
        );
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      }
    } catch (e) {
      debugPrint('Error tambahData : ${e.toString()}');

      // Tampilkan notifikasi jika gagal menambahkan pelanggan
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menambah pelanggan: ${e.toString()}")),
        );
      }
    }
  }
}
