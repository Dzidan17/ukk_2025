import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/pages/fitur/EditPelanggan.dart';
import 'package:ukk_2025/pages/pelanggan/tambahpelanggan.dart';

class Produk extends StatefulWidget {
  const Produk({super.key});

  @override
  State<Produk> createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
  final SupabaseClient supabaseClient = Supabase.instance.client;
  List<Map<String, dynamic>> produkList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fecthProduk();
  }

  Future<void> fecthProduk() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await supabaseClient.from('produk').select();
      setState(() {
        produkList = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching produk: ${e.toString()}");
      setState(() {
        isLoading = false;
      });
    }
  }

  void hapusProduk(int produkId) async {
    try {
      await supabaseClient
          .from('produk')
          .delete()
          .eq('produk_id', produkId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("produk berhasil dihapus")),
        );
      }

      fecthProduk(); // Perbarui daftar produk
    } catch (e) {
      debugPrint("Error hapus produk: ${e.toString()}");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menghapus produk: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Produk"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fecthProduk,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : produkList.isEmpty
              ? const Center(child: Text("Belum ada produk"))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: produkList.length,
                  itemBuilder: (context, index) {
                    final produk = produkList[index];

                    // Validasi nomor telepon
                    String nomorTelepon =
                        produk['nomor_telepon']?.toString() ??
                            "Tidak tersedia";

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            produk['nama_produk'][0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          produk['nama_produk'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Alamat: ${produk['alamat']}",
                                style: TextStyle(color: Colors.grey[700])),
                            Text("Telepon: $nomorTelepon",
                                style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditProduk(produk: produk),
                                  ),
                                ).then((_) => fecthProduk());
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  hapusProduk(produk['produk_id']),
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
            MaterialPageRoute(builder: (context) => const TambahProduk()),
          );
          fecthProduk();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
