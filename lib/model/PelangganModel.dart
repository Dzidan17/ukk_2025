class PelangganModel {
  int pelangganId;
  String namaPelanggan;
  String alamat;
  String nomortelepon;

  PelangganModel({this.pelangganId = 0,
  required this.namaPelanggan,
  required this.alamat,
  required this.nomortelepon
  });

  factory PelangganModel.fromMap(Map<String, dynamic> map) {
    return PelangganModel(
      pelangganId: map['pelanggan_id'] ?? 0,
      namaPelanggan: map['nama_pelanggan'] ?? 0,
      alamat: map['alamat'] ?? 0,
      nomortelepon: map['nomor_telepon']?.toString() ?? '',
      );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama_pelanggan': namaPelanggan,
      'alamat': alamat,
      'nomor_telepon': nomortelepon
    };
  }

}