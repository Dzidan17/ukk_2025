import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/model/PelangganModel.dart';
import 'package:ukk_2025/pages/widget/Textform.dart';

class Tambahpelanggan extends StatefulWidget {
  const Tambahpelanggan({super.key});

  @override
  State<Tambahpelanggan> createState() => _TambahpelangganState();
}

class _TambahpelangganState extends State<Tambahpelanggan> {
  SupabaseClient supabaseClient = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  TextEditingController nama = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController telepon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Pelanggan"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Textform(controller: nama, judul: "Nama"),
              Textform(controller: alamat, judul: "Alamat"),
              Textform(controller: telepon, judul: "No Telepone"),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        simpanPelanggan();
                      },
                      child: Text("Simpan")))
            ],
          ),
        ),
      ),
    );
  }

  void simpanPelanggan() {
    if (_formKey.currentState!.validate()) {
      debugPrint('Form Valid');
      _formKey.currentState!.save();

      tambahData();
    } else {
      debugPrint('Form Tidak Valid');
    }
  }

  void tambahData() async {
    debugPrint('tambahData dipanggil');

    try {
      PelangganModel model = PelangganModel(
          namaPelanggan: nama.text,
          alamat: alamat.text,
          nomortelepon:
              telepon.text.isNotEmpty ? telepon.text : "Tidak tersedia");

      final response =
          await supabaseClient.from('pelanggan').insert(model.toMap());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pelanggan berhasil ditambahkan")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Error tambahData : ${e.toString()}');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("gagal menambah pelanggan: ${e.toString()}")),
        );
      }
    }
  }
}
