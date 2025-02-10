import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/model/ModelProduk.dart';
import 'package:ukk_2025/pages/widget/Textform.dart';

class TambahProduk extends StatefulWidget {
  const TambahProduk({super.key});

  @override
  State<TambahProduk> createState() => _TambahprodukState();
}

class _TambahprodukState extends State<TambahProduk> {
  SupabaseClient supabaseClient = Supabase.instance.client;
  final _keyProduk = GlobalKey<FormState>();

  TextEditingController produk = TextEditingController();
  TextEditingController harga = TextEditingController();
  TextEditingController stok = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Produk"),
      ),
      body: Form(
        key: _keyProduk,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Textform(controller: produk, judul: "Produk"),
              Textform(controller: harga, judul: "Harga"),
              Textform(controller: stok, judul: "Stok"),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => simpanProduk(), child: Text("Simpa")))
            ],
          ),
        ),
      ),
    );
  }

  void simpanProduk() {
    if (_keyProduk.currentState!.validate()) {
      debugPrint('called');
      _keyProduk.currentState!.save();
    }
  }

  void tambahData() async {
    debugPrint('tambahData us called');
    ModelProduk model = ModelProduk(
        namaProduk: produk.text, harga: harga.text, stok: int.parse(stok.text));

    try {
      final response =
          await supabaseClient.from('produk').insert(model.toMap());
    } catch (e) {
      debugPrint('Error tambahData : ${e.toString()}');
    }
  }
}
