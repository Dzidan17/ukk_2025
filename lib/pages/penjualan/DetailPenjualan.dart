import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahPenjualan extends StatefulWidget {
  const TambahPenjualan({super.key});

  @override
  State<TambahPenjualan> createState() => _TambahPenjualanState();
}

class _TambahPenjualanState extends State<TambahPenjualan> {
  final SupabaseClient supabaseClient = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  TextEditingController tanggalPenjualan = TextEditingController();
  TextEditingController totalHarga = TextEditingController();
  TextEditingController pelangganId = TextEditingController();
  TextEditingController produkId = TextEditingController();
  TextEditingController jumlahProduk = TextEditingController();
  TextEditingController subTotal = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Penjualan"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextFormField(
                controller: tanggalPenjualan,
                decoration: const InputDecoration(labelText: "Tanggal Penjualan"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Tanggal tidak boleh kosong";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: totalHarga,
                decoration: const InputDecoration(labelText: "Total Harga"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Total harga tidak boleh kosong";
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return "Total harga harus berupa angka positif";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: pelangganId,
                decoration: const InputDecoration(labelText: "Pelanggan ID"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Pelanggan ID tidak boleh kosong";
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return "Pelanggan ID harus berupa angka positif";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: produkId,
                decoration: const InputDecoration(labelText: "Produk ID"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Produk ID tidak boleh kosong";
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return "Produk ID harus berupa angka positif";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: jumlahProduk,
                decoration: const InputDecoration(labelText: "Jumlah Produk"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Jumlah produk tidak boleh kosong";
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return "Jumlah produk harus berupa angka positif";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: subTotal,
                decoration: const InputDecoration(labelText: "Sub Total"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Sub total tidak boleh kosong";
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return "Sub total harus berupa angka positif";
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
      final response = await supabaseClient.from('penjualan').insert({
        'tanggal_penjualan': tanggalPenjualan.text.trim(),
        'total_harga': double.parse(totalHarga.text.trim()),
        'pelanggan_id': int.parse(pelangganId.text.trim()),
      }).select();

      if (response.isNotEmpty) {
        final penjualanId = response[0]['penjualan_id'];

        await supabaseClient.from('detail_penjualan').insert({
          'penjualan_id': penjualanId,
          'produk_id': int.parse(produkId.text.trim()),
          'jumlah_produk': int.parse(jumlahProduk.text.trim()),
          'sub_total': double.parse(subTotal.text.trim()),
        });
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Penjualan dan detail berhasil ditambahkan")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Error tambahData : ${e.toString()}');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menambah data: ${e.toString()}")),
        );
      }
    }
  }
}