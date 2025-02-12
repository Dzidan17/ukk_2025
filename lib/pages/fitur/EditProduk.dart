import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/pages/widget/Textform.dart'; // Menggunakan widget khusus untuk input form

// Widget Stateful untuk mengedit data produk
class EditProduk extends StatefulWidget {
  final Map<String, dynamic> produk; // Menerima data produk yang akan diedit

  const EditProduk({super.key, required this.produk});

  @override
  State<EditProduk> createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  final SupabaseClient supabaseClient = Supabase.instance.client; // Inisialisasi Supabase client
  final _formKey = GlobalKey<FormState>(); // Key untuk validasi form

  // Controller untuk input data
  late TextEditingController namaProduk;
  late TextEditingController harga;
  late TextEditingController stok;

  @override
  void initState() {
    super.initState();
    // Mengisi controller dengan data produk yang ada saat ini
    namaProduk = TextEditingController(text: widget.produk['nama_produk']);
    harga = TextEditingController(text: widget.produk['harga'].toString());
    stok = TextEditingController(text: widget.produk['stok'].toString());
  }

  @override
  void dispose() {
    // Membersihkan controller untuk menghindari kebocoran memori
    namaProduk.dispose();
    harga.dispose();
    stok.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Produk")), // Judul halaman edit
      body: Form(
        key: _formKey, // Menghubungkan form dengan key untuk validasi
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Input Nama Produk
              Textform(
                controller: namaProduk,
                judul: "Nama Produk",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Produk tidak boleh kosong";
                  }
                  return null;
                },
              ),
              // Input Harga Produk
              Textform(
                controller: harga,
                judul: "Harga",
                keyboardType: TextInputType.number, // Input berupa angka
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Harga tidak boleh kosong";
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return "Harga harus berupa angka positif";
                  }
                  return null;
                },
              ),
              // Input Stok Produk
              Textform(
                controller: stok,
                judul: "Stok",
                keyboardType: TextInputType.number, // Input berupa angka
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Stok tidak boleh kosong";
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                    return "Stok harus berupa angka dan tidak boleh negatif";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Tombol untuk menyimpan perubahan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      updateProduk(); // Jalankan fungsi update jika validasi berhasil
                    }
                  },
                  child: const Text("Simpan Perubahan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk memperbarui produk ke database
  Future<void> updateProduk() async {
    try {
      await supabaseClient.from('produk').update({
        'nama_produk': namaProduk.text.trim(),
        'harga': double.parse(harga.text.trim()),
        'stok': int.parse(stok.text.trim()),
      }).eq('produk_id', widget.produk['produk_id']); // Menentukan produk berdasarkan ID

      if (context.mounted) {
        // Menampilkan notifikasi sukses dan kembali ke halaman sebelumnya
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Produk berhasil diperbarui")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Error updateProduk: ${e.toString()}');
      if (context.mounted) {
        // Menampilkan notifikasi jika gagal memperbarui produk
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memperbarui produk: ${e.toString()}")),
        );
      }
    }
  }
}
