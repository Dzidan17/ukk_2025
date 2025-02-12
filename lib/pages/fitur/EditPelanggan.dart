import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Widget Stateful untuk mengedit data pelanggan
class EditPelanggan extends StatefulWidget {
  final Map<String, dynamic> pelanggan; // Menerima data pelanggan yang akan diedit

  const EditPelanggan({super.key, required this.pelanggan});

  @override
  State<EditPelanggan> createState() => _EditPelangganState();
}

class _EditPelangganState extends State<EditPelanggan> {
  SupabaseClient supabaseClient = Supabase.instance.client; // Inisialisasi Supabase client
  final _formKey = GlobalKey<FormState>(); // Key untuk validasi form

  // Controller untuk input data
  late TextEditingController nama;
  late TextEditingController alamat;
  late TextEditingController telepon;

  @override
  void initState() {
    super.initState();
    // Mengisi controller dengan data pelanggan yang ada saat ini
    nama = TextEditingController(text: widget.pelanggan['nama_pelanggan']);
    alamat = TextEditingController(text: widget.pelanggan['alamat']);
    telepon = TextEditingController(text: widget.pelanggan['nomor_telepon']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Pelanggan"), // Judul halaman edit pelanggan
      ),
      body: Form(
        key: _formKey, // Menghubungkan form dengan key untuk validasi
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Input Nama Pelanggan
              TextFormField(
                controller: nama,
                decoration: InputDecoration(labelText: "Nama"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nama tidak boleh kosong";
                  }
                  return null;
                },
              ),
              // Input Alamat Pelanggan
              TextFormField(
                controller: alamat,
                decoration: InputDecoration(labelText: "Alamat"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Alamat tidak boleh kosong";
                  }
                  return null;
                },
              ),
              // Input Nomor Telepon Pelanggan
              TextFormField(
                controller: telepon,
                decoration: InputDecoration(labelText: "No Telepon"),
                keyboardType: TextInputType.phone, // Menyesuaikan input untuk nomor telepon
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nomor telepon tidak boleh kosong";
                  }
                  if (value.length < 10) {
                    return "Nomor telepon minimal 10 digit";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Tombol untuk menyimpan perubahan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await updatePelanggan(); // Jalankan fungsi update jika validasi berhasil
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

  // Fungsi untuk memperbarui pelanggan di database
  Future<void> updatePelanggan() async {
    try {
      await supabaseClient.from('pelanggan').update({
        'nama_pelanggan': nama.text.trim(),
        'alamat': alamat.text.trim(),
        'nomor_telepon': telepon.text.trim(),
      }).eq('pelanggan_id', widget.pelanggan['pelanggan_id']); // Menentukan pelanggan berdasarkan ID

      // Menampilkan notifikasi sukses dan kembali ke halaman sebelumnya
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pelanggan berhasil diperbarui")),
      );
      Navigator.pop(context);
    } catch (e) {
      debugPrint("Error update pelanggan: ${e.toString()}");
      // Menampilkan notifikasi jika gagal memperbarui pelanggan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memperbarui pelanggan: ${e.toString()}")),
      );
    }
  }
}
