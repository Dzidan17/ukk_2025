import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/pages/fitur/EditPelanggan.dart';
import 'package:ukk_2025/pages/pelanggan/tambahpelanggan.dart';

// Widget Stateful untuk menampilkan daftar pelanggan
class Pelanggan extends StatefulWidget {
  const Pelanggan({super.key});

  @override
  State<Pelanggan> createState() => _PelangganState();
}

class _PelangganState extends State<Pelanggan> {
  final SupabaseClient supabaseClient = Supabase.instance.client; // Inisialisasi Supabase Client
  List<Map<String, dynamic>> pelangganList = []; // List untuk menyimpan data pelanggan
  bool isLoading = true; // Status untuk menampilkan loading indicator

  @override
  void initState() {
    super.initState();
    fecthPelanggan(); // Ambil data pelanggan saat pertama kali halaman dibuka
  }

  // Fungsi untuk mengambil data pelanggan dari Supabase
  Future<void> fecthPelanggan() async {
    setState(() {
      isLoading = true; // Tampilkan loading saat data diambil
    });

    try {
      final response = await supabaseClient.from('pelanggan').select();
      setState(() {
        pelangganList = List<Map<String, dynamic>>.from(response); // Simpan hasil query ke dalam list
        isLoading = false; // Sembunyikan loading setelah data diterima
      });
    } catch (e) {
      debugPrint("Error fetching pelanggan: ${e.toString()}");
      setState(() {
        isLoading = false; // Tetap sembunyikan loading meskipun terjadi error
      });
    }
  }

  // Fungsi untuk menghapus pelanggan dari database
  void hapusPelanggan(int pelangganId) async {
    try {
      await supabaseClient
          .from('pelanggan')
          .delete()
          .eq('pelanggan_id', pelangganId); // Hapus pelanggan berdasarkan ID

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pelanggan berhasil dihapus")),
        );
      }

      fecthPelanggan(); // Perbarui daftar pelanggan setelah dihapus
    } catch (e) {
      debugPrint("Error hapus pelanggan: ${e.toString()}");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menghapus pelanggan: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pelanggan"), // Judul halaman
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), // Tombol untuk menyegarkan daftar pelanggan
            onPressed: fecthPelanggan,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Tampilkan loading jika data belum siap
          : pelangganList.isEmpty
              ? const Center(child: Text("Belum ada pelanggan")) // Tampilkan teks jika tidak ada data
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: pelangganList.length,
                  itemBuilder: (context, index) {
                    final pelanggan = pelangganList[index];

                    // Validasi nomor telepon jika kosong
                    String nomorTelepon =
                        pelanggan['nomor_telepon']?.toString() ?? "Tidak tersedia";

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            pelanggan['nama_pelanggan'][0].toUpperCase(), // Menampilkan inisial nama pelanggan
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          pelanggan['nama_pelanggan'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Alamat: ${pelanggan['alamat']}",
                                style: TextStyle(color: Colors.grey[700])),
                            Text("Telepon: $nomorTelepon",
                                style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Tombol Edit
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditPelanggan(pelanggan: pelanggan),
                                  ),
                                ).then((_) => fecthPelanggan()); // Perbarui daftar pelanggan setelah kembali dari halaman edit
                              },
                            ),
                            // Tombol Hapus
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  hapusPelanggan(pelanggan['pelanggan_id']),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Tambahpelanggan()), // Navigasi ke halaman tambah pelanggan
          );
          fecthPelanggan(); // Perbarui daftar pelanggan setelah kembali dari halaman tambah
        },
        child: const Icon(Icons.add, color: Colors.white), // Tombol tambah pelanggan
      ),
    );
  }
}
