// Model untuk merepresentasikan data Produk
class ModelProduk {
  int produkId; // ID unik untuk produk
  String namaProduk; // Nama produk
  String harga; // Harga produk dalam bentuk string (sebaiknya gunakan int atau double untuk operasi matematika)
  int stok; // Jumlah stok produk yang tersedia

  // Konstruktor ModelProduk
  ModelProduk({
    this.produkId = 0, // Default ID produk adalah 0 jika tidak diberikan
    required this.namaProduk, // Nama produk wajib diisi
    required this.harga, // Harga produk wajib diisi
    required this.stok, // Stok produk wajib diisi
  });

  // Factory constructor untuk membuat objek ModelProduk dari Map (misalnya dari database)
  factory ModelProduk.fromMap(Map<String, dynamic> map) {
    return ModelProduk(
      produkId: map['produk_id'], // Mengambil produk_id dari Map
      namaProduk: map['nama_produk'], // Mengambil nama_produk dari Map
      harga: map['harga'], // Mengambil harga dari Map
      stok: map['stok'], // Mengambil stok dari Map
    );
  }

  // Method untuk mengubah objek ModelProduk menjadi Map (misalnya untuk disimpan ke database)
  Map<String, dynamic> toMap() {
    return {
      'nama_produk': namaProduk, // Menyimpan nama produk
      'harga': harga, // Menyimpan harga produk
      'stok': stok, // Menyimpan stok produk
    };
  }
}
