import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/pages/penjualan/TambahPenjualan.dart';

class PenjualanScreen extends StatefulWidget {
  const PenjualanScreen({super.key});

  @override
  State<PenjualanScreen> createState() => _PenjualanScreenState();
}

class _PenjualanScreenState extends State<PenjualanScreen> {
  final SupabaseClient supabaseClient = Supabase.instance.client;
  List<Map<String, dynamic>> penjualanList = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPenjualan();
  }

  Future<void> fetchPenjualan({String? keyword}) async {
    setState(() => isLoading = true);
    try {
      var query = supabaseClient.from('penjualan').select();
      
      if (keyword != null && keyword.isNotEmpty) {
        query = query.ilike('tanggal_penjualan', '%$keyword%');
      }
      
      final response = await query;
      setState(() {
        penjualanList = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching penjualan: ${e.toString()}");
      setState(() => isLoading = false);
    }
  }

  void hapusPenjualan(int penjualanId) async {
    try {
      await supabaseClient.from('penjualan').delete().eq('penjualan_id', penjualanId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Penjualan berhasil dihapus")),
      );
      fetchPenjualan();
    } catch (e) {
      debugPrint("Error hapus penjualan: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus penjualan: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Penjualan"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchPenjualan,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Cari Penjualan",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => fetchPenjualan(keyword: searchController.text),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : penjualanList.isEmpty
                    ? const Center(child: Text("Belum ada penjualan"))
                    : ListView.builder(
                        itemCount: penjualanList.length,
                        itemBuilder: (context, index) {
                          final penjualan = penjualanList[index];
                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text("Tanggal: ${penjualan['tanggal_penjualan']}",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text("Total Harga: Rp ${penjualan['total_harga']}"),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => hapusPenjualan(penjualan['penjualan_id']),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahPenjualan()),
          );
          fetchPenjualan();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}