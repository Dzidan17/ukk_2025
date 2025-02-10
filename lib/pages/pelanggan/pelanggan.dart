import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/pages/pelanggan/tambahpelanggan.dart';

class Pelanggan extends StatefulWidget {
  const Pelanggan({super.key});

  @override
  State<Pelanggan> createState() => _PelangganState();
}

class _PelangganState extends State<Pelanggan> {
  final SupabaseClient supabaseClient = Supabase.instance.client;
  List<Map<String, dynamic>> pelangganList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fecthPelanggan();
  }

  Future<void> fecthPelanggan() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await supabaseClient.from('pelanggan').select();
      setState(() {
        pelangganList = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching pelanggan: ${e.toString()}");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pelanggan"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fecthPelanggan,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pelangganList.isEmpty
              ? const Center(child: Text("Belum ada pelanggan"))
              : ListView.builder(
  padding: const EdgeInsets.all(8.0),
  itemCount: pelangganList.length,
  itemBuilder: (context, index) {
    final pelanggan = pelangganList[index];

    // Validasi nomor telepon
    String nomorTelepon = pelanggan['nomortelepon']?.toString() ?? "Tidak tersedia";

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(
            pelanggan['nama_pelanggan'][0].toUpperCase(),
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
      ),
    );
  },
),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Tambahpelanggan()),
          );
          fecthPelanggan();
        },
        child: const Icon(Icons.add, color:Colors.white),
      ),
    );
  }
}
