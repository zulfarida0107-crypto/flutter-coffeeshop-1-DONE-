class PesananEntity {
  final int id;
  final String namaPelanggan;
  final int idProduk;
  final int jumlah;
  final double totalHarga;
  final String statusPesanan;
  final String? tanggalPesanan;
  final String detailPesanan;

  PesananEntity({
    required this.id,
    required this.namaPelanggan,
    required this.idProduk,
    required this.jumlah,
    required this.totalHarga,
    required this.statusPesanan,
    this.tanggalPesanan,
    this.detailPesanan = '[]',
  });

  factory PesananEntity.fromMap(Map<String, dynamic> map) {
    return PesananEntity(
      id: map[COL_ID_KEY],
      namaPelanggan: map[COL_NAMA_PELANGGAN_KEY],
      idProduk: map[COL_ID_PRODUK_KEY],
      jumlah: map[COL_JUMLAH_KEY],
      totalHarga: double.tryParse(map[COL_TOTAL_HARGA_KEY].toString()) ?? 0.0,
      statusPesanan: map[COL_STATUS_PESANAN_KEY],
      tanggalPesanan: map[COL_TANGGAL_PESANAN_KEY],
      detailPesanan: map[COL_DETAIL_PESANAN_KEY] ?? '[]',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      COL_ID_KEY: id,
      COL_NAMA_PELANGGAN_KEY: namaPelanggan,
      COL_ID_PRODUK_KEY: idProduk,
      COL_JUMLAH_KEY: jumlah,
      COL_TOTAL_HARGA_KEY: totalHarga,
      COL_STATUS_PESANAN_KEY: statusPesanan,
      COL_TANGGAL_PESANAN_KEY: tanggalPesanan,
      COL_DETAIL_PESANAN_KEY: detailPesanan,
    };
  }

  static String TABLE_NAME = "pesanan";
  static String COL_ID_KEY = "id";
  static String COL_NAMA_PELANGGAN_KEY = "nama_pelanggan";
  static String COL_ID_PRODUK_KEY = "id_produk";
  static String COL_JUMLAH_KEY = "jumlah";
  static String COL_TOTAL_HARGA_KEY = "total_harga";
  static String COL_STATUS_PESANAN_KEY = "status_pesanan";
  static String COL_TANGGAL_PESANAN_KEY = "tanggal_pesanan";
  static String COL_DETAIL_PESANAN_KEY = "detail_pesanan";
}
