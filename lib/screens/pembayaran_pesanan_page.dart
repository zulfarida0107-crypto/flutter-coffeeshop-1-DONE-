import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/pesanan_entity.dart';

class PembayaranPesananPage extends StatefulWidget {
  const PembayaranPesananPage({super.key});

  @override
  State<PembayaranPesananPage> createState() => _PembayaranPesananPageState();
}

class _PembayaranPesananPageState extends State<PembayaranPesananPage> {
  List<PesananEntity> listPembayaran = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Mengambil data dan memfilter status 'Proses' atau 'Selesai'
  void _fetchData() async {
    setState(() => isLoading = true);
    var data = await DatabaseHelper.getInstance().getAllPesanan();
    setState(() {
      // Filter: Hanya tampilkan yang sedang diproses atau sudah selesai
      listPembayaran = data
          .where(
            (p) =>
                p.statusPesanan.toLowerCase() == 'proses' ||
                p.statusPesanan.toLowerCase() == 'selesai',
          )
          .toList();
      isLoading = false;
    });
  }

  String formatRupiah(num value) {
    String str = value.toStringAsFixed(0);
    String result = '';
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      result = str[i] + result;
      count++;
      if (count == 3 && i > 0) {
        result = '.$result';
        count = 0;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Konfirmasi Pembayaran',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown[700],
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(onPressed: _fetchData, icon: const Icon(Icons.refresh)),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : listPembayaran.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listPembayaran.length,
              itemBuilder: (context, index) {
                var item = listPembayaran[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFD7D1CE),
                      child: Icon(
                        Icons.monetization_on,
                        color: Colors.brown[700],
                      ),
                    ),
                    title: Text(
                      item.namaPelanggan,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Tagihan: Rp ${formatRupiah(item.totalHarga)}",
                        ),
                        const SizedBox(height: 4),
                        _buildStatusTag(item.statusPesanan),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showPaymentDetail(item),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            "Belum ada tagihan aktif",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Text("Pesanan berstatus 'Baru' tidak muncul di sini."),
        ],
      ),
    );
  }

  Widget _buildStatusTag(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: status.toLowerCase() == 'selesai' ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showPaymentDetail(PesananEntity pesanan) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ringkasan Pembayaran",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              _rowInfo("Nama Pelanggan", pesanan.namaPelanggan),
              _rowInfo("Waktu Pesanan", pesanan.tanggalPesanan ?? "-"),
              _rowInfo("Status", pesanan.statusPesanan),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "TOTAL BAYAR",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "Rp ${formatRupiah(pesanan.totalHarga)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tutup"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _rowInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
