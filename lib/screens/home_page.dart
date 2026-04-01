import 'package:flutter/material.dart';
import 'menu_produk_page.dart';
import 'manajemen_user_page.dart';
import 'daftar_pesanan_page.dart';
import 'desain_pesanan_page.dart';
import 'pesan_kontak_page.dart';
import 'pembayaran_pesanan_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard Admin Coffeeshop',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.brown[700],
        centerTitle: true,
        // Tombol logout di AppBar sudah dihapus sesuai instruksi
      ),
      body: Column(
        children: [
          // Bagian Grid Menu
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildMenuCard(
                  context,
                  'Manajemen User',
                  Icons.people,
                  Colors.brown,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManajemenUserPage(),
                    ),
                  ),
                ),
                _buildMenuCard(
                  context,
                  'Daftar Menu Produk',
                  Icons.coffee,
                  Colors.brown,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MenuProdukPage(),
                    ),
                  ),
                ),
                _buildMenuCard(
                  context,
                  'Daftar Pesanan',
                  Icons.shopping_cart,
                  Colors.brown,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DaftarPesananPage(),
                    ),
                  ),
                ),
                _buildMenuCard(
                  context,
                  'Daftar Desain Pesanan (Kue)',
                  Icons.cake,
                  Colors.brown,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DesainPesananPage(),
                    ),
                  ),
                ),
                _buildMenuCard(
                  context,
                  'Daftar Pesan Masuk',
                  Icons.mail,
                  Colors.brown,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PesanKontakPage(),
                    ),
                  ),
                ),
                _buildMenuCard(
                  context,
                  'Pembayaran Pesanan',
                  Icons.payment,
                  Colors.brown,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PembayaranPesananPage(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTapAction,
  ) {
    return InkWell(
      onTap: onTapAction,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
