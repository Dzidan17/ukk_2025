class ModelProduk {
  int produkId;
  String namaProduk;
  String harga;
  int stok;

  ModelProduk(
      {this.produkId = 0,
      required this.namaProduk,
      required this.harga,
      required this.stok});

  factory ModelProduk.fromMap(Map<String, dynamic> map) {
    return ModelProduk(
        produkId: map['produk_id'],
        namaProduk: map['nama_produk'],
        harga: map['harga'],
        stok: map['stok']);
  }

  Map<String, dynamic> toMap() {
    return {
      'nama_produk': namaProduk,
      'harga': harga,
      'stok': stok,
    };
  }
}
