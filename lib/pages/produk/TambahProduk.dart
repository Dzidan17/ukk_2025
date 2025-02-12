import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/pages/widget/Textform.dart';

class TambahProduk extends StatefulWidget {
  const TambahProduk({super.key});

  @override
  State<TambahProduk> createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  final SupabaseClient supabaseClient = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  TextEditingController namaProduk = TextEditingController();
  TextEditingController harga = TextEditingController();
  TextEditingController stok = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Produk"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Textform(
                controller: namaProduk,
                judul: "Nama Produk",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nama produk tidak boleh kosong";
                  }
                  return null;
                },
              ),
              Textform(
                controller: harga,
                judul: "Harga",
                keyboardType: TextInputType.number,
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
              Textform(
                controller: stok,
                judul: "Stok",
                keyboardType: TextInputType.number,
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      tambahData();
                    }
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

  void tambahData() async {
    try {
      // Cek apakah nama barang sudah ada di database
      final existing = await supabaseClient
          .from('produk')
          .select('nama_produk')
          .eq('nama_produk', namaProduk.text.trim())
          .maybeSingle();

      if (existing != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk sudah terdaftar')),
        );
        return;
      }

      // Simpan data baru ke database
      await supabaseClient.from('produk').insert({
        'nama_produk': namaProduk.text.trim(),
        'harga': double.parse(harga.text.trim()),
        'stok': int.parse(stok.text.trim()),
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Produk berhasil ditambahkan")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Error tambahData : ${e.toString()}');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menambah produk: ${e.toString()}")),
        );
      }
    }
  }
}