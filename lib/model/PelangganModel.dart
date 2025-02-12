// Model untuk merepresentasikan data Pelanggan
class PelangganModel {
  int pelangganId; // ID unik untuk pelanggan
  String namaPelanggan; // Nama pelanggan
  String alamat; // Alamat pelanggan
  String nomortelepon; // Nomor telepon pelanggan

  // Konstruktor untuk inisialisasi objek PelangganModel
  PelangganModel({
    this.pelangganId = 0, // ID pelanggan default 0 jika tidak diberikan
    required this.namaPelanggan, // Nama pelanggan wajib diisi
    required this.alamat, // Alamat pelanggan wajib diisi
    required this.nomortelepon, // Nomor telepon pelanggan wajib diisi
  });

  // Factory constructor untuk membuat objek PelangganModel dari Map (misalnya dari database)
  factory PelangganModel.fromMap(Map<String, dynamic> map) {
    return PelangganModel(
      pelangganId: map['pelanggan_id'] ?? 0, // Mengambil ID pelanggan dari Map, default 0 jika null
      namaPelanggan: map['nama_pelanggan'] ?? '', // Mengambil nama pelanggan dari Map, default string kosong jika null
      alamat: map['alamat'] ?? '', // Mengambil alamat dari Map, default string kosong jika null
      nomortelepon: map['nomor_telepon']?.toString() ?? '', // Mengambil nomor telepon, dikonversi ke String jika null
    );
  }

  // Method untuk mengubah objek PelangganModel menjadi Map (misalnya untuk disimpan ke database)
  Map<String, dynamic> toMap() {
    return {
      // 'pelanggan_id': pelangganId, // ID pelanggan bisa disertakan jika diperlukan
      'nama_pelanggan': namaPelanggan, // Menyimpan nama pelanggan
      'alamat': alamat, // Menyimpan alamat pelanggan
      'nomor_telepon': nomortelepon, // Menyimpan nomor telepon pelanggan
    };
  }
}
