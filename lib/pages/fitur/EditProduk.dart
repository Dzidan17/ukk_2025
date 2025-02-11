import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProduk extends StatefulWidget {
  final Map<String, dynamic> produk;

  const EditProduk({super.key, required this.produk});

  @override
  State<EditProduk> createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  SupabaseClient supabaseClient = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nama_produk;
  late TextEditingController harga;
  late TextEditingController stok;

  @override
  void initState() {
    super.initState();
    nama_produk = TextEditingController(text: widget.produk['nama_produk']);
    harga = TextEditingController(text: widget.produk['alamat']);
    stok = TextEditingController(text: widget.produk['nomor_telepon']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Pelanggan"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextFormField(controller: nama, decoration: InputDecoration(labelText: "Nama")),
              TextFormField(controller: alamat, decoration: InputDecoration(labelText: "Alamat")),
              TextFormField(controller: telepon, decoration: InputDecoration(labelText: "No Telepon")),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await updatePelanggan();
                    }
                  },
                  child: Text("Simpan"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updatePelanggan() async {
    try {
      await supabaseClient.from('pelanggan').update({
        'nama_pelanggan': nama.text,
        'alamat': alamat.text,
        'nomor_telepon': telepon.text,
      }).eq('pelanggan_id', widget.pelanggan['pelanggan_id']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pelanggan berhasil diperbarui")),
      );
      Navigator.pop(context);
    } catch (e) {
      debugPrint("Error update pelanggan: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memperbarui pelanggan: ${e.toString()}")),
      );
    }
  }
}
