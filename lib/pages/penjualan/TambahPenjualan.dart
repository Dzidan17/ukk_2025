import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class TambahPenjualan extends StatefulWidget {
  const TambahPenjualan({super.key});

  @override
  State<TambahPenjualan> createState() => _TambahPenjualanState();
}

class _TambahPenjualanState extends State<TambahPenjualan> {
  final SupabaseClient supabaseClient = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  TextEditingController tanggalPenjualan = TextEditingController();
  TextEditingController jumlahProdukController = TextEditingController();

  String? pelangganId;
  String? produkId;
  String pelangganNama = "";
  String produkNama = "";
  double hargaProduk = 0.0;
  double totalHarga = 0.0;

  List<Map<String, dynamic>> pelangganList = [];
  List<Map<String, dynamic>> produkList = [];

  @override
  void initState() {
    super.initState();
    tanggalPenjualan.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    fetchPelanggan();
    fetchProduk();
  }

  Future<void> fetchPelanggan() async {
    final response = await supabaseClient.from('pelanggan').select('pelanggan_id, nama_pelanggan');
    setState(() {
      pelangganList = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> fetchProduk() async {
    final response = await supabaseClient.from('produk').select('produk_id, nama_produk, harga');
    setState(() {
      produkList = List<Map<String, dynamic>>.from(response);
    });
  }

  void updateTotalHarga() {
    if (produkId != null && jumlahProdukController.text.isNotEmpty) {
      final selectedProduct = produkList.firstWhere((produk) => produk['produk_id'].toString() == produkId);
      setState(() {
        produkNama = selectedProduct['nama_produk'];
        hargaProduk = selectedProduct['harga'].toDouble();
        totalHarga = hargaProduk * int.parse(jumlahProdukController.text);
      });
    }
  }

  void showStruk() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Struk Penjualan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("📅 Tanggal: ${tanggalPenjualan.text}"),
              Text("🛒 Produk: $produkNama"),
              Text("💲 Harga Satuan: Rp ${hargaProduk.toStringAsFixed(2)}"),
              Text("📦 Jumlah: ${jumlahProdukController.text}"),
              Text("👤 Pelanggan: $pelangganNama"),
              Text("💰 Total Harga: Rp ${totalHarga.toStringAsFixed(2)}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Penjualan")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextFormField(
                controller: tanggalPenjualan,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Tanggal Penjualan",
                  suffixIcon: Icon(Icons.date_range),
                ),
              ),
              DropdownButtonFormField<String>(
                value: pelangganId,
                decoration: const InputDecoration(labelText: "Pilih Pelanggan"),
                items: pelangganList.map((pelanggan) {
                  return DropdownMenuItem<String>(
                    value: pelanggan['pelanggan_id'].toString(),
                    child: Text(pelanggan['nama_pelanggan']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    pelangganId = value;
                    pelangganNama = pelangganList.firstWhere(
                      (pelanggan) => pelanggan['pelanggan_id'].toString() == value,
                    )['nama_pelanggan'];
                  });
                },
                validator: (value) => value == null ? "Pilih pelanggan" : null,
              ),
              DropdownButtonFormField<String>(
                value: produkId,
                decoration: const InputDecoration(labelText: "Pilih Produk"),
                items: produkList.map((produk) {
                  return DropdownMenuItem<String>(
                    value: produk['produk_id'].toString(),
                    child: Text(produk['nama_produk']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    produkId = value;
                    updateTotalHarga();
                  });
                },
                validator: (value) => value == null ? "Pilih produk" : null,
              ),
              TextFormField(
                controller: jumlahProdukController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Jumlah Produk"),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    updateTotalHarga();
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Jumlah produk harus diisi";
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return "Jumlah produk harus berupa angka positif";
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
      // Insert ke tabel penjualan
      final response = await supabaseClient.from('penjualan').insert({
        'tanggal_penjualan': tanggalPenjualan.text.trim(),
        'total_harga': totalHarga,
        'pelanggan_id': int.parse(pelangganId!),
      }).select();

      if (response.isNotEmpty) {
        int penjualanId = response[0]['penjualan_id'];

        // Insert ke tabel detail_penjualan
        await supabaseClient.from('detail_penjualan').insert({
          'penjualan_id': penjualanId,
          'produk_id': int.parse(produkId!),
          'jumlah_produk': int.parse(jumlahProdukController.text),
          'sub_total': totalHarga,
        });

        if (context.mounted) {
          showStruk();
        }
      }
    } catch (e) {
      debugPrint('Error tambahData : ${e.toString()}');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menambah penjualan: ${e.toString()}")),
        );
      }
    }
  }
}
